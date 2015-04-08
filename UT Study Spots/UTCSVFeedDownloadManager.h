//
//  UTCSVFeedDownloadManager.h
//  UT Study Spots
//
//  Created by Fatass on 4/1/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "InputReader.h"

#import "Constants.h"
#import "Utilities.h"

static NSString *const ALL_EVENTS_SCHEDULE = @"https://apps.cs.utexas.edu/calendar/touch/feed";
static NSString *const ALL_ROOMS_SCHEDULE = @"https://apps.cs.utexas.edu/calendar/touch/all/feed";
static NSString *const ALL_TODAYS_EVENTS = @"https://apps.cs.utexas.edu/calendar/touch/today/feed";

static NSString *const ALL_EVENTS_SCHEDULE_FILENAME = @"calendar_events_feed.csv";
static NSString *const ALL_ROOMS_SCHEDULE_FILENAME = @"calendar_rooms_feed.csv";
static NSString *const ALL_TODAYS_EVENTS_FILENAME = @"calendar_events_today_feed.csv";

static const int TIMEOUT_INTERVAL = 20;
static const NSUInteger DAILY_UPDATE_TIME = 859;   // 8:59a; update if curr time is 9a or after
static const NSUInteger DAILY_UPDATE_HOUR = 8;
static const NSUInteger DAILY_UPDATE_MINUTE = 59;

@interface UTCSVFeedDownloadManager : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic, readonly) NSString *filename;
@property (strong, nonatomic, readonly) NSURL *url;

@property (strong, nonatomic) id <NSURLConnectionDataDelegate> url_cxn_delegate;

- (instancetype) initWithURLString : (NSString *) url_str filename : (NSString *) filename;
//- (instancetype) initWithURL : (NSURL *) url filename : (NSString *) filename;
//- (instancetype) init : (NSString *) filename;    // IMPLEMENT? RETURN NIL IF NOT VALID FILENAME?

//- (void) download;
//- (InputReader *) get_feed_reader;
//- (NSString *) get_feed_contents_as_string;

+ (bool) is_valid_filename : (NSString *) filename;

+ (bool) download_all;

+ (InputReader *) get_feed_reader : (NSString *) filename;
+ (NSString *) get_feed_contents_as_string : (NSString *) filename;

+ (NSString *) get_file_path : (NSString *) filename;

+ (void) delete_all_feeds;
+ (bool) delete_feed : (NSString *) filename;

+ (bool) feed_exists : (NSString *) filename;
+ (bool) feed_is_current : (NSString *) filename;

+ (bool) get_feed_write_success : (NSString *) filename;
//+ (bool) set_feed_write_success : (NSString *) filename success : (bool) success;

+ (bool) get_feeds_write_success;

@end










