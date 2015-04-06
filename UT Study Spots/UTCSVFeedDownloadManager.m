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
@synthesize delegate;

- (instancetype) initWithURLString : (NSString *) url_str filename : (NSString *) filename {
    if ([Utilities is_null : url_str] || url_str.length <= 0 || [Utilities is_null : filename] || filename.length <= 0) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        
        self.filename = filename;
        self.url = [NSURL URLWithString : [url_str url_encode]];
        self.delegate = self;
        
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
    
    if (_DEBUG) {
        NSLog(@"Download of file at \"%@\" launched", self.filename);
    }
    
    NSURLRequest *url_request = [NSURLRequest requestWithURL : self.url];
    [NSURLConnection connectionWithRequest : url_request delegate : self];
    
    NSStringEncoding encoding = 0;
    NSString *file = [Utilities get_file_path : @"calendar_events_feed" ext : @"csv"];
    NSString *csv = [NSString stringWithContentsOfFile : file usedEncoding : &encoding error : nil];
    NSLog(@"%@", csv);
}

- (NSString *) get_documents_dir_path {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *basePath = [paths firstObject];
    return basePath;
}

/* *********** ************* */

- (void) connectionDidFinishLoading : (NSURLConnection *) connection {
    NSString *file_path = [NSString stringWithFormat : @"%@/%@", [self get_documents_dir_path], self.filename];
    [self.buffer writeToFile : file_path atomically : YES];
    
    NSLog(@"In connectionDidFinishLoading\n%@", self.buffer);
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
    NSLog(@"Error downloading file from URL \"%@\"", self.url);
}



@end










