//
//  UTCSVFeedDownloadManager.m
//  UT Study Spots
//
//  Created by Fatass on 4/1/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "UTCSVFeedDownloadManager.h"

#import "InputReader.h"
#import "DateTools.h"
#import "NSString+Tools.h"

/*
    Simulating WWAN
        - http://stackoverflow.com/questions/1077701/iphone-connectivity-testing-how-do-i-force-it-to-lose-connection
        - use network link conditioner
 
    TODO
        - disallow actions that read/modify/write feeds if downloadIsInProgress
        - fill in connectionDidFinishDownloading()
        - instead of a single downloadIsInProgress, make it per-connection (so if only one feed fails we can recover the other two, etc)
 */

/* *********** ************* */

@interface UTCSVFeedDownloadManager ()

//@property (strong, nonatomic) DownloadHandler *handler;

@property (strong, nonatomic, readwrite) NSString *filename;
@property (strong, nonatomic, readwrite) NSURL *url;

@property (strong, nonatomic) NSURLConnection *all_events_cxn;
@property (strong, nonatomic) NSURLConnection *all_rooms_cxn;
@property (strong, nonatomic) NSURLConnection *todays_events_cxn;

@property (strong, nonatomic) NSMutableData *all_events_buf;
@property (strong, nonatomic) NSMutableData *all_rooms_buf;
@property (strong, nonatomic) NSMutableData *todays_events_buf;

@property (assign, nonatomic) bool allEventsDidFinishDownloading;
@property (assign, nonatomic) bool allRoomsDidFinishDownloading;
@property (assign, nonatomic) bool todaysEventsDidFinishDownloading;

@property (assign, nonatomic) bool allEventsDidFinishSuccessfully;
@property (assign, nonatomic) bool allEventsDidFailWithError;
@property (assign, nonatomic) bool allRoomsDidFinishSuccessfully;
@property (assign, nonatomic) bool allRoomsDidFailWithError;
@property (assign, nonatomic) bool todaysEventsDidFinishSuccessfully;
@property (assign, nonatomic) bool todaysEventsDidFailWithError;

@property (assign, nonatomic, readwrite) bool downloadIsInProgress;
@property (assign, nonatomic) bool didFinishSuccessfully;
@property (assign, nonatomic) bool didStopWithError;

@property (strong, nonatomic) NSMutableURLRequest *url_request;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *buffer;
@property (strong, nonatomic) NSFileHandle *file_handle;

@end

@implementation UTCSVFeedDownloadManager

@synthesize url_cxn_delegate;

+ (UTCSVFeedDownloadManager *) csv_dl_manager {
    static UTCSVFeedDownloadManager *_csv_dl_manager = nil;
    static dispatch_once_t once_tok;
    
    dispatch_once(&once_tok, ^{
        _csv_dl_manager = [[UTCSVFeedDownloadManager alloc] init];
    });
    
    return _csv_dl_manager;
}

+ (void) download_all {
    [UTCSVFeedDownloadManager download_all_RETVAL_BROKEN];
}

+ (bool) download_all_RETVAL_BROKEN {
    __block UTCSVFeedDownloadManager *manager = [UTCSVFeedDownloadManager csv_dl_manager];
    
    if (manager.downloadIsInProgress) {
        NSLog(@"Download is already in progress!");
        return false;
    }
    manager.downloadIsInProgress = true;
    
    manager.allEventsDidFinishDownloading = false;
    manager.allRoomsDidFinishDownloading = false;
    manager.todaysEventsDidFinishDownloading = false;
    
//    manager.allEventsDidFinishSuccessfully = false;
//    manager.allEventsDidFailWithError = false;
//    manager.allRoomsDidFinishSuccessfully = false;
//    manager.allRoomsDidFailWithError = false;
//    manager.todaysEventsDidFinishSuccessfully = false;
//    manager.todaysEventsDidFailWithError = false;
    
    NSURL *all_events_url = [[NSURL alloc] initWithString : [ALL_EVENTS_SCHEDULE url_encode]];
    NSURL *all_rooms_url = [[NSURL alloc] initWithString : [ALL_ROOMS_SCHEDULE url_encode]];
    NSURL *todays_events_url = [[NSURL alloc] initWithString : [ALL_TODAYS_EVENTS url_encode]];
    
//    NSURLRequest *all_events_url_request = [NSURLRequest requestWithURL : all_events_url];
//    NSURLRequest *all_rooms_url_request = [NSURLRequest requestWithURL : all_rooms_url];
//    NSURLRequest *todays_events_url_request = [NSURLRequest requestWithURL : todays_events_url];
    
    __block NSURLRequest *all_events_url_request = [[NSURLRequest alloc] initWithURL : all_events_url
                                                      cachePolicy : NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                  timeoutInterval : TIMEOUT_INTERVAL];
    
    __block NSURLRequest *all_rooms_url_request = [[NSURLRequest alloc] initWithURL : all_rooms_url
                                                                 cachePolicy : NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                             timeoutInterval : TIMEOUT_INTERVAL];
    
    __block NSURLRequest *todays_events_url_request = [[NSURLRequest alloc] initWithURL : todays_events_url
                                                                 cachePolicy : NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                             timeoutInterval : TIMEOUT_INTERVAL];
    
    const char *download_queue = "download_queue";
    dispatch_queue_t _serial_queue = dispatch_queue_create(download_queue, DISPATCH_QUEUE_SERIAL);
    
    __block bool SUCCESS = true;
    dispatch_sync(_serial_queue, ^{
        
        manager.all_events_cxn = [[NSURLConnection alloc] initWithRequest : all_events_url_request
                                                                 delegate : nil
                                                         startImmediately : NO];    // use delegate : self  if desired
        
        manager.all_rooms_cxn = [[NSURLConnection alloc] initWithRequest : all_rooms_url_request
                                                                delegate : nil
                                                        startImmediately : NO];    // use delegate : self  if desired
        
        manager.todays_events_cxn = [[NSURLConnection alloc] initWithRequest : todays_events_url_request
                                                                    delegate : nil
                                                            startImmediately : NO];    // use delegate : self  if desired
        
        NSOperationQueue *dl_queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest : all_events_url_request
                                           queue : dl_queue
         
         // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLResponse_Class/index.html#//apple_ref/occ/instp/NSURLResponse/URL
                               completionHandler : ^(NSURLResponse *response, NSData *data, NSError *error) {
                                   long response_code = (long) ((NSHTTPURLResponse *) response).statusCode;
                                   
                                   if (_DEBUG) {
                                       NSLog(@"all_events CSV feed download complete; HTTP response code %ld; download in progress: %@", response_code, BOOL_STRS[manager.downloadIsInProgress]);
                                   }
                                   
                                   SUCCESS = [UTCSVFeedDownloadManager handle_completion_handler : ALL_EVENTS_SCHEDULE_FILENAME
                                                                                    curr_success : SUCCESS
                                                                                        response : response
                                                                                            data : data
                                                                                           error : error];
                               }];
        
        [NSURLConnection sendAsynchronousRequest : all_rooms_url_request
                                           queue : dl_queue
         
                               completionHandler : ^(NSURLResponse *response, NSData *data, NSError *error) {
                                   long response_code = (long) ((NSHTTPURLResponse *) response).statusCode;
                                   
                                   if (_DEBUG) {
                                       NSLog(@"all_rooms CSV feed download complete; HTTP response code %ld; download in progress: %@", response_code, BOOL_STRS[manager.downloadIsInProgress]);
                                   }
                                   
                                   SUCCESS = [UTCSVFeedDownloadManager handle_completion_handler : ALL_ROOMS_SCHEDULE_FILENAME
                                                                                    curr_success : SUCCESS
                                                                                        response : response
                                                                                            data : data
                                                                                           error : error];
                                   
                               }];
        
        [NSURLConnection sendAsynchronousRequest : todays_events_url_request
                                           queue : dl_queue
         
                               completionHandler : ^(NSURLResponse *response, NSData *data, NSError *error) {
                                   long response_code = (long) ((NSHTTPURLResponse *) response).statusCode;
                                   
                                   if (_DEBUG) {
                                       NSLog(@"todays_events CSV feed download complete; HTTP response code %ld; download in progress: %@", response_code, BOOL_STRS[manager.downloadIsInProgress]);
                                   }
                                   
                                   SUCCESS = [UTCSVFeedDownloadManager handle_completion_handler : ALL_TODAYS_EVENTS_FILENAME
                                                                                    curr_success : SUCCESS
                                                                                        response : response
                                                                                            data : data
                                                                                           error : error];
                                   
                               }];

        NSLog(@"HERE 2.0");
    });
    
    // parse downloaded files here
    dispatch_sync(_serial_queue, ^{
        
        
        NSLog(@"HERE 2.1");
    });
   
    NSLog(@"HERE 2.2");
    
//    dispatch_sync(_serial_queue, ^{
//       manager.downloadIsInProgress = false;
//        
//        NSLog(@"HERE 2.3");
//    });

    return SUCCESS;
    
//    return false;
}

+ (bool) handle_completion_handler : (NSString *) filename
                      curr_success : (bool) curr_success
                      response : (NSURLResponse *) response
                              data : (NSData *) data
                             error : (NSError *) error {
    /*
     if (error or !data or response != 200)
     set pref to false
     AND false to success
     else
     write contents of buffer to file
     set pref to true
     AND true to success
     */
    
    NSLog(@"Entered completion handler for file \"%@\"", filename);
    
    UTCSVFeedDownloadManager *manager = [UTCSVFeedDownloadManager csv_dl_manager];
    
    long response_code = (long) ((NSHTTPURLResponse *) response).statusCode;
    
    if (error || !data || response_code != RESPONSE_OK) {
        if (_DEBUG) {
            NSLog(@"%@: error : %@, data is null: %@", filename, [error localizedDescription], BOOL_STRS[!data]);
        }
        
        [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
        curr_success &= false;
    }
    else {
        
        NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
        if ([UTCSVFeedDownloadManager feed_exists : filename]) {
            [UTCSVFeedDownloadManager delete_feed_private : filename];
        }
        
        NSString *contents = [[NSString alloc] initWithData : data encoding : DEFAULT_STRING_ENCODING];
        
        if (_DEBUG) NSLog(@"\nContents of %@:\n\n%@\n", filename, contents);
        
        
        // https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSData_Class/index.html#//apple_ref/doc/uid/20000172-BCIICCHI
        // http://stackoverflow.com/questions/7471270/secure-contents-in-documents-directory
        NSError *write_error = nil;
//        bool write_success = [contents writeToFile : file_path atomically : YES encoding : DEFAULT_STRING_ENCODING error : &write_error];
        bool write_success = [data writeToFile : file_path options : NSDataWritingFileProtectionComplete | NSDataWritingAtomic error : &write_error];
        
        if (write_error || !write_success) {
            if (_DEBUG) {
                NSLog(@"Failed to write to %@ with error %@", filename, [write_error localizedDescription]);
            }
            
//                                           if ([UTCSVFeedDownloadManager feed_exists : filename]) {
//                                               [UTCSVFeedDownloadManager set_feed_write_success : ALL_EVENTS_SCHEDULE_FILENAME success : true];
//                                               SUCCESS &= true;
//                                           }
//                                           else {
            
            if ([UTCSVFeedDownloadManager feed_exists : filename]) {
                [UTCSVFeedDownloadManager delete_feed_private : filename];
            }
            
            [UTCSVFeedDownloadManager set_feed_write_success : ALL_EVENTS_SCHEDULE_FILENAME success : false];
            curr_success &= false;
//                                           }
        }
        else {
            [UTCSVFeedDownloadManager set_feed_write_success : ALL_EVENTS_SCHEDULE_FILENAME success : true];
            curr_success &= true;
        }
        
    }
    
    if ([filename equals : ALL_EVENTS_SCHEDULE_FILENAME]) {
        manager.allEventsDidFinishDownloading = true;
        
//        if (_DEBUG) {
//            NSLog(@"\nDownloaded all events CSV feed:\n\n%@\n", [UTCSVFeedDownloadManager get_feed_contents_as_string : filename]);
//        }
    }
    else if ([filename equals : ALL_ROOMS_SCHEDULE_FILENAME]) {
        manager.allRoomsDidFinishDownloading = true;
        
//        if (_DEBUG) {
//            NSLog(@"\nDownloaded all events CSV feed:\n\n%@\n", [UTCSVFeedDownloadManager get_feed_contents_as_string : filename]);
//        }
    }
    else {
        manager.todaysEventsDidFinishDownloading = true;
        
//        if (_DEBUG) {
//            NSLog(@"\nDownloaded all events CSV feed:\n\n%@\n", [UTCSVFeedDownloadManager get_feed_contents_as_string : filename]);
//        }
    }
    
    // parse feeds into global EventList
    if (manager.allEventsDidFinishDownloading &&
        manager.allRoomsDidFinishDownloading &&
        manager.todaysEventsDidFinishDownloading) {
        
        manager.downloadIsInProgress = false;
        
        if (_DEBUG) {
            NSLog(@"All 3 CSV feed downloads complete; download in progress: %@", BOOL_STRS[manager.downloadIsInProgress]);
        }
    }
    
    return curr_success;
}

- (void) connectionDidFinishLoading : (NSURLConnection *) connection {
    
    UTCSVFeedDownloadManager *manager = [UTCSVFeedDownloadManager csv_dl_manager];
    
    if ([connection isEqual : manager.all_events_cxn]) {
        if (_DEBUG) {
            NSLog(@"connectionDidFinishLoading() for all_events_cxn");
        }
        
        if (!manager.allEventsDidFailWithError) {
            manager.allEventsDidFinishSuccessfully = true;
        }
        else {
            manager.allEventsDidFinishSuccessfully = false;
        }
    }
    else if ([connection isEqual : manager.all_rooms_cxn]) {
        if (_DEBUG) {
            NSLog(@"connectionDidFinishLoading() for all_rooms_cxn");
        }
        
        if (!manager.allRoomsDidFailWithError) {
            manager.allRoomsDidFinishSuccessfully = true;
        }
        else {
            manager.allRoomsDidFinishSuccessfully = false;
        }
    }
    else {
        if (_DEBUG) {
            NSLog(@"connectionDidFinishLoading() for todays_events_cxn");
        }
        
        if (!manager.todaysEventsDidFailWithError) {
            manager.todaysEventsDidFinishSuccessfully = true;
        }
        else {
            manager.todaysEventsDidFinishSuccessfully = false;
        }
    }
    
    if ((manager.allEventsDidFailWithError || manager.allEventsDidFinishSuccessfully) &&
        (manager.allRoomsDidFailWithError || manager.allRoomsDidFinishSuccessfully) &&
        (manager.todaysEventsDidFailWithError || manager.todaysEventsDidFinishSuccessfully)) {
        
        manager.downloadIsInProgress = false;
    }
    
//    __block BOOL success = NO;
//
//    if (self.buffer) {
//        //        success = [self.buffer writeToFile : file_path atomically : YES];
//
//        // http://stackoverflow.com/questions/679104/the-easiest-way-to-write-nsdata-to-a-file
//        // dispatch as async in CSVDownloader
//        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSString *file_path = [UTCSVFeedDownloadManager get_file_path : self.filename];
//        NSString *data = [[NSString alloc] initWithData : self.buffer encoding : DEFAULT_STRING_ENCODING];
//
//        NSError *error = nil;
//        success = [data writeToFile : file_path atomically : YES encoding : DEFAULT_STRING_ENCODING error : &error];
//
//        if (!self.didStopWithError && success && !error) {
//            self.didFinishSuccessfully = true;  // ??????????????????
//        }
//        else {
//            self.didFinishSuccessfully = false;
//            [UTCSVFeedDownloadManager delete_feed : self.filename];
//            // TODO - CALL DELEGATE METHOD HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//
//            if (_DEBUG && error) {
//                NSLog(@"FAILED to finish loading filename \"%@\" with error \"%@\"", self.filename, error);
//            }
//        }
//        
//        [UTCSVFeedDownloadManager set_feed_write_success : self.filename success : self.didFinishSuccessfully];
//        
//        if (_DEBUG) {
//            NSLog(@"In connectionDidFinishLoading");
//            if (success && self.didFinishSuccessfully) {
//                NSString *csv = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : nil error : nil];
//                NSLog(@"%@", csv);
//            }
//            else {
//                NSLog(@"FAILED to finish loading filename \"%@\" with error \"%@\"", self.filename, error);
//            }
//        }
//        
//        NSLog(@"HERE 0");
//        //        });
//    }
//    
//    //    NSString *data = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
//    //
//    //    BOOL success = [data writeToFile : file_path atomically : YES encoding : DEFAULT_STRING_ENCODING error : nil];
//    //
//    //    NSString *csv = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : nil error : nil];
//    //    NSLog(@"%@", csv);
//    
//    NSLog(@"HERE 1");
//    
//    self.downloadIsInProgress = false;
}

//- (void) connection : (NSURLConnection *) connection didReceiveData : (NSData *) data {
//    UTCSVFeedDownloadManager *manager = [UTCSVFeedDownloadManager csv_dl_manager];
//    
//    if ([connection isEqual : manager.all_events_cxn]) {
//        if (_DEBUG) {
//            NSLog(@"Received data for all_events_cxn");
//        }
//        
//        if (manager.all_events_buf) {
//            [manager.all_events_buf appendData : data];
//        }
//        else {
//            manager.all_events_buf = [[NSMutableData alloc] initWithData : data];
//        }
//    }
//    else if ([connection isEqual : manager.all_rooms_cxn]) {
//        if (_DEBUG) {
//            NSLog(@"Received data for all_rooms_cxn");
//        }
//        
//        if (manager.all_rooms_buf) {
//            [manager.all_rooms_buf appendData : data];
//        }
//        else {
//            manager.all_rooms_buf = [[NSMutableData alloc] initWithData : data];
//        }
//    }
//    else {
//        if (_DEBUG) {
//            NSLog(@"Received data for todays_events_cxn");
//        }
//        
//        if (manager.todays_events_buf) {
//            [manager.todays_events_buf appendData : data];
//        }
//        else {
//            manager.todays_events_buf = [[NSMutableData alloc] initWithData : data];
//        }
//    }
//    
//    NSLog(@"Exiting connection.didReceiveData()");
//}

- (void) connection : (NSURLConnection *) connection didFailWithError : (NSError *) error {
    UTCSVFeedDownloadManager *manager = [UTCSVFeedDownloadManager csv_dl_manager];
    
    if ([connection isEqual : manager.all_events_cxn]) {
        if (_DEBUG) {
            NSLog(@"Error downloading with connection %@ (err: %@)", connection, [error localizedDescription]);
        }
        
        manager.allEventsDidFinishSuccessfully = false;
        manager.allEventsDidFailWithError = true;
        [connection cancel];
    }
    else if ([connection isEqual : manager.all_rooms_cxn]) {
        if (_DEBUG) {
            NSLog(@"Error downloading with connection %@ (err: %@)", connection, [error localizedDescription]);
        }
        
        manager.allRoomsDidFinishSuccessfully = false;
        manager.allRoomsDidFailWithError = true;
        [connection cancel];
    }
    else {
        if (_DEBUG) {
            NSLog(@"Error downloading with connection %@ (err: %@)", connection, [error localizedDescription]);
        }
        
        manager.todaysEventsDidFinishSuccessfully = false;
        manager.todaysEventsDidFailWithError = true;
        [connection cancel];
    }

    
//    if ([connection isEqual : manager.all_events_cxn]) {
//        if (_DEBUG) {
//            NSLog(@"Error downloading with connection %@ (err: %@)", connection, [error localizedDescription]);
//        }
//        
//        manager.allEventsDidFinishSuccessfully = false;
//        manager.allEventsDidFailWithError = true;
//        [connection cancel];
//    }
//    else if ([connection isEqual : manager.all_rooms_cxn]) {
//        if (_DEBUG) {
//            NSLog(@"Error downloading with connection %@ (err: %@)", connection, [error localizedDescription]);
//        }
//        
//        manager.allRoomsDidFinishSuccessfully = false;
//        manager.allRoomsDidFailWithError = true;
//        [connection cancel];
//    }
//    else {
//        if (_DEBUG) {
//            NSLog(@"Error downloading with connection %@ (err: %@)", connection, [error localizedDescription]);
//        }
//        
//        manager.todaysEventsDidFinishSuccessfully = false;
//        manager.todaysEventsDidFailWithError = true;
//        [connection cancel];
//    }
    
    // clear buffers, set flags, etc in connectionDidFinishLoading
    
//    NSLog(@"Error downloading file \"%@\" with error \"%@\"", self.filename, error);
//    
//    self.didFinishSuccessfully = false;
//    self.didStopWithError = true;
//    
//    [UTCSVFeedDownloadManager set_feed_write_success : self.filename success : false];
}



/* *********** ************* */

+ (NSString *) get_documents_dir_path {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *basePath = [paths firstObject];
    return basePath;
}

- (NSString *) get_file_path {
    return ([UTCSVFeedDownloadManager get_file_path : self.filename]);
}

+ (NSString *) get_file_path : (NSString *) filename {
    NSString *out = [NSString stringWithFormat : @"%@/%@", [UTCSVFeedDownloadManager get_documents_dir_path], filename];
    return out;
}

/* *********** ************* */

// - (BOOL)setAttributes:(NSDictionary *)attributes ofItemAtPath:(NSString *)path error:(NSError **)error


/* *********** ************* */

+ (bool) is_valid_filename : (NSString *) filename {
    if ([Utilities is_null : filename]) {
        return false;
    }
    else if (![filename equals : ALL_EVENTS_SCHEDULE_FILENAME] &&
               ![filename equals : ALL_ROOMS_SCHEDULE_FILENAME] &&
               ![filename equals : ALL_TODAYS_EVENTS_FILENAME]) {
        return false;
    }
    return true;
}

+ (InputReader *) get_feed_reader : (NSString *) filename {
    if (([UTCSVFeedDownloadManager csv_dl_manager]).downloadIsInProgress) {
        return nil;
    }
    if (![UTCSVFeedDownloadManager is_valid_filename : filename] ||
        ![UTCSVFeedDownloadManager feed_exists : filename]) {
        return nil;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    InputReader *out = [[InputReader alloc] initWithFilePath : file_path];
    return out;
}

+ (NSString *) get_feed_contents_as_string : (NSString *) filename {
    if (([UTCSVFeedDownloadManager csv_dl_manager]).downloadIsInProgress) {
        return nil;
    }
    if (![UTCSVFeedDownloadManager is_valid_filename : filename] ||
        ![UTCSVFeedDownloadManager feed_exists : filename]) {
        return nil;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    NSString *out = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : nil error : nil];
    return out;
}

+ (bool) delete_all_feeds {
    if (([UTCSVFeedDownloadManager csv_dl_manager]).downloadIsInProgress) {
        return false;
    }
    
    [UTCSVFeedDownloadManager delete_feed : ALL_EVENTS_SCHEDULE_FILENAME];
    [UTCSVFeedDownloadManager delete_feed : ALL_ROOMS_SCHEDULE_FILENAME];
    [UTCSVFeedDownloadManager delete_feed : ALL_TODAYS_EVENTS_FILENAME];
    return true;
}

+ (bool) delete_feed : (NSString *) filename {
    if (([UTCSVFeedDownloadManager csv_dl_manager]).downloadIsInProgress) {
        return false;
    }
    
    return ([UTCSVFeedDownloadManager delete_feed_private : filename]);
}

// TODO - UPDATE SHARED PREFS
// http://stackoverflow.com/questions/15017902/delete-specified-file-from-document-directory
// CHECK HOW TO SET FILE ATTRS WHEN WRITING (SET (IM)MUTABLE ATTR)
+ (bool) delete_feed_private : (NSString *) filename {
    if (![UTCSVFeedDownloadManager is_valid_filename : filename]) {
        return false;
    }
    else if (![UTCSVFeedDownloadManager feed_exists : filename]) {
        [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
        return false;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    if (!file_path) {
        
        if (_DEBUG) {
            NSLog(@"Attempting to delete file \"%@\"; invalid path found (%@)", filename, file_path);
        }
        
        [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
        return false;
    }
    
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath : file_path error : &error];
    if (error || !success) {
        if (_DEBUG && error) {
            NSLog(@"Failed to delete file \"%@\" due to error \"%@\"", filename, [error localizedDescription]);
        }
        
        [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
        return false;
    }
    else {
        if (_DEBUG) {
            NSLog(@"Successfully removed file: (%@) at path \"%@\" with no error: (%@)", BOOL_STRS[success], file_path, BOOL_STRS[(error == nil)]);
        }
    }
    
    [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
    return true;
}

// TODO - MAY NOT WORK WITH JAILBROKEN PHONES (SEE LINK BELOW)
// http://stackoverflow.com/questions/1638834/how-to-check-if-a-file-exists-in-documents-folder
+ (bool) feed_exists : (NSString *) filename {
    if (![UTCSVFeedDownloadManager is_valid_filename : filename]) {
        // TODO - throw IAException
        return false;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    if (!file_path) {
        return false;
    }
    
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath : file_path];
    return exists;
}

+ (bool) feed_is_current : (NSString *) filename {
    if ([Utilities is_null : filename]) {
        // TODO - throw IAException
    }
    else if (![filename equals : ALL_EVENTS_SCHEDULE_FILENAME] &&
             ![filename equals : ALL_ROOMS_SCHEDULE_FILENAME] &&
             ![filename equals : ALL_TODAYS_EVENTS_FILENAME]) {
        return true;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    if (!file_path) {
        return false;
    }
    
    // http://stackoverflow.com/questions/9365355/get-last-file-modification-date-of-application-data-files
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath : file_path error : &error];
    if (error || !attributes) {
        return false;
    }
    
    NSDate *now = [Utilities get_date : DAILY_UPDATE_HOUR minute : DAILY_UPDATE_MINUTE];
    NSInteger curr_month = now.month;
    NSInteger curr_day = now.day;
    NSInteger curr_day_of_year = now.dayOfYear;
    NSInteger curr_year = now.year;
    
    NSDate *last_modified = [attributes fileModificationDate];
    
    if (_DEBUG) {
        NSLog(@"\nChecking if file \"%@\" is current\n\tLast modified: %@\n\tUpdate time: %@", filename, [last_modified toString], [now toString]);
    }
    
    if (last_modified.dayOfYear == curr_day_of_year &&
        last_modified.year == curr_year &&
        [last_modified isLaterThan : now]) {
        
        return true;
    }
    
    // disable this block if updates should always occur from 0000 to 0859
    else if (last_modified.dayOfYear == curr_day_of_year - 1 &&
             last_modified.year == curr_year &&
             [now isLaterThan : now]) {
        
        NSDate *yesterday_update_time = [Utilities get_date : curr_month day : curr_day - 1 year : curr_year hour : DAILY_UPDATE_HOUR minute : DAILY_UPDATE_MINUTE];
        if ([last_modified isLaterThan : yesterday_update_time]) {
            return true;
        }
    }
    
    return false;
}

+ (bool) get_feed_write_success : (NSString *) filename {
    if (![UTCSVFeedDownloadManager is_valid_filename : filename]) {
        return false;
    }
    else if (![UTCSVFeedDownloadManager feed_exists : filename]) {
        return false;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([filename equals : ALL_EVENTS_SCHEDULE_FILENAME]) {
        return ([prefs boolForKey : CSV_FEED_ALL_EVENTS_WRITE_SUCCESS]);
    }
    else if ([filename equals : ALL_ROOMS_SCHEDULE_FILENAME]) {
        return ([prefs boolForKey : CSV_FEED_ALL_ROOMS_WRITE_SUCCESS]);
    }
    else if ([filename equals : ALL_TODAYS_EVENTS_FILENAME]) {
        return ([prefs boolForKey : CSV_FEED_ALL_TODAYS_EVENTS_WRITE_SUCCESS]);
    }
    
    return false;
}

+ (bool) set_feed_write_success : (NSString *) filename success : (bool) success {
//    if (![UTCSVFeedDownloadManager is_valid_filename : filename]) {
//        return false;
//    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool was_set = false;
    
    if ([filename equals : ALL_EVENTS_SCHEDULE_FILENAME]) {
        [prefs setBool : success forKey : CSV_FEED_ALL_EVENTS_WRITE_SUCCESS];
        was_set = true;
    }
    else if ([filename equals : ALL_ROOMS_SCHEDULE_FILENAME]) {
        [prefs setBool : success forKey : CSV_FEED_ALL_ROOMS_WRITE_SUCCESS];
        was_set = true;
    }
    else if ([filename equals : ALL_TODAYS_EVENTS_FILENAME]) {
        [prefs setBool : success forKey : CSV_FEED_ALL_TODAYS_EVENTS_WRITE_SUCCESS];
        was_set = true;
    }
    
    if (was_set) {
        [prefs synchronize];
        return true;
    }
    
    return false;
}

+ (bool) get_feeds_write_success {
    BOOL success = [[NSUserDefaults standardUserDefaults] boolForKey : CSV_FEEDS_WRITE_SUCCESS];
    return success;
}



@end










