//
//  UTCSVFeedDownloadManager.m
//  UT Study Spots
//
//  Created by Fatass on 4/1/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "UTCSVFeedDownloadManager.h"

#import "InputReader.h"
#import "NSString+Tools.h"

/* *********** ************* */

@interface UTCSVFeedDownloadManager ()

//@property (strong, nonatomic) DownloadHandler *handler;

@property (strong, nonatomic, readwrite) NSString *filename;
@property (strong, nonatomic, readwrite) NSURL *url;

@property (assign, nonatomic) bool didFinishSuccessfully;
@property (assign, nonatomic) bool didStopWithError;

@property (strong, nonatomic) NSMutableURLRequest *url_request;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *buffer;
@property (strong, nonatomic) NSFileHandle *file_handle;

@end

@implementation UTCSVFeedDownloadManager

@synthesize filename = _filename;
@synthesize url = _url;
@synthesize url_cxn_delegate;

- (instancetype) initWithURLString : (NSString *) url_str filename : (NSString *) filename {
//    if ([Utilities is_null : url_str] || url_str.length <= 0 || [Utilities is_null : filename] || filename.length <= 0) {
//        // TODO - throw IAException
//    }
    if (![UTCSVFeedDownloadManager is_valid_filename : filename]) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        
        self.filename = filename;
        self.url = [NSURL URLWithString : [url_str url_encode]];
        self.url_cxn_delegate = self;
        
        self.didFinishSuccessfully = false;
        self.didStopWithError = false;
        
    }
    
    return self;
}

- (void) download {
//    TCBlobDownloadManager *manager = [TCBlobDownloadManager sharedInstance];
//    NSString *filepath = [NSString stringWithFormat : @"%@/fux", [self get_documents_dir]];
//    [manager setDefaultDownloadPath : filepath];
//    [manager startDownload : self.downloader];
    
//    if ([UTCSVFeedDownloadManager feed_is_current : self.filename]) {
//        // TODO - CALL DELEGATE METHOD HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//    }
    
    if (_DEBUG) {
        NSLog(@"Download of file at \"%@\" launched", self.filename);
    }
    
    NSURLRequest *url_request = [NSURLRequest requestWithURL : self.url];
    [NSURLConnection connectionWithRequest : url_request delegate : self];

}

/* *********** ************* */

- (InputReader *) get_feed_reader {
    if (!self.didFinishSuccessfully || !self.didStopWithError) {
        return nil;
    }
    
    return ([UTCSVFeedDownloadManager get_feed_reader : self.filename]);
}

- (NSString *) get_feed_contents_as_string {
    if (!self.didFinishSuccessfully || !self.didStopWithError) {
        return nil;
    }
    
    return ([UTCSVFeedDownloadManager get_feed_contents_as_string : self.filename]);
}

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

- (void) connectionDidFinishLoading : (NSURLConnection *) connection {
    
    __block BOOL success = NO;
    
    if (self.buffer) {
//        success = [self.buffer writeToFile : file_path atomically : YES];
        
        // http://stackoverflow.com/questions/679104/the-easiest-way-to-write-nsdata-to-a-file
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSString *file_path = [UTCSVFeedDownloadManager get_file_path : self.filename];
            NSString *data = [[NSString alloc] initWithData : self.buffer encoding : DEFAULT_STRING_ENCODING];
            
            NSError *error = nil;
            success = [data writeToFile : file_path atomically : YES encoding : DEFAULT_STRING_ENCODING error : &error];
            
            if (!self.didStopWithError && success && !error) {
                self.didFinishSuccessfully = true;  // ??????????????????
            }
            else {
                self.didFinishSuccessfully = false;
                [UTCSVFeedDownloadManager delete_feed : self.filename];
                // TODO - CALL DELEGATE METHOD HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                
                if (_DEBUG && error) {
                    NSLog(@"FAILED to finish loading filename \"%@\" with error \"%@\"", self.filename, error);
                }
            }
            
            [UTCSVFeedDownloadManager set_feed_write_success : self.filename success : self.didFinishSuccessfully];
            
            if (_DEBUG) {
                NSLog(@"In connectionDidFinishLoading");
                if (success && self.didFinishSuccessfully) {
                    NSString *csv = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : nil error : nil];
                    NSLog(@"%@", csv);
                }
                else {
                    NSLog(@"FAILED to finish loading filename \"%@\" with error \"%@\"", self.filename, error);
                }
            }
        });
    }
    
//    NSString *data = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
//    
//    BOOL success = [data writeToFile : file_path atomically : YES encoding : DEFAULT_STRING_ENCODING error : nil];
//    
//    NSString *csv = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : nil error : nil];
//    NSLog(@"%@", csv);
    
}

- (void) connection : (NSURLConnection *) connection didReceiveData : (NSData *) data {
    if (self.buffer) {
        [self.buffer appendData : data];
    }
    else {
        self.buffer = [[NSMutableData alloc] initWithData : data];
    }
    
    NSLog(@"In connection.didReceiveData()");
}

- (void) connection : (NSURLConnection *) connection didFailWithError : (NSError *) error {
    NSLog(@"Error downloading file \"%@\" with error \"%@\"", self.filename, error);
    
    self.didFinishSuccessfully = false;
    self.didStopWithError = true;
    
    [UTCSVFeedDownloadManager set_feed_write_success : self.filename success : false];
}

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
    if (![UTCSVFeedDownloadManager is_valid_filename : filename] ||
        ![UTCSVFeedDownloadManager feed_exists : filename]) {
        return nil;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    InputReader *out = [[InputReader alloc] initWithFilePath : file_path];
    return out;
}

+ (NSString *) get_feed_contents_as_string : (NSString *) filename {
    if (![UTCSVFeedDownloadManager is_valid_filename : filename] ||
        ![UTCSVFeedDownloadManager feed_exists : filename]) {
        return nil;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    NSString *out = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : nil error : nil];
    return out;
}

+ (void) delete_all_feeds {
    [UTCSVFeedDownloadManager delete_feed : ALL_EVENTS_SCHEDULE_FILENAME];
    [UTCSVFeedDownloadManager delete_feed : ALL_ROOMS_SCHEDULE_FILENAME];
    [UTCSVFeedDownloadManager delete_feed : ALL_TODAYS_EVENTS_FILENAME];
}

// TODO - UPDATE SHARED PREFS
// http://stackoverflow.com/questions/15017902/delete-specified-file-from-document-directory
// CHECK HOW TO SET FILE ATTRS WHEN WRITING (SET (IM)MUTABLE ATTR)
+ (bool) delete_feed : (NSString *) filename {
    if (![UTCSVFeedDownloadManager is_valid_filename : filename]) {
        return false;
    }
    else if (![UTCSVFeedDownloadManager feed_exists : filename]) {
        [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
        return false;
    }
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    if (!file_path) {
        [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
        return false;
    }
    
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath : file_path error : &error];
    if (error || !success) {
        if (_DEBUG && error) {
            NSLog(@"Failed to delete file \"%@\" due to error \"%@\"", filename, error);
        }
        
        [UTCSVFeedDownloadManager set_feed_write_success : filename success : false];
        return false;
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

//+ (bool) feed_is_current : (NSString *) filename {
//    if ([Utilities is_null : filename]) {
//        // TODO - throw IAException
//    }
//    else if (![filename equals : ALL_EVENTS_SCHEDULE_FILENAME] &&
//             ![filename equals : ALL_ROOMS_SCHEDULE_FILENAME] &&
//             ![filename equals : ALL_TODAYS_EVENTS_FILENAME]) {
//        return true;
//    }
//    
//    return true;
//}

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










