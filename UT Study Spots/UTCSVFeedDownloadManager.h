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

static NSString *const ALL_EVENTS_SCHEDULE_FILENAME = @"calendar_events_feed.csv";
static NSString *const ALL_ROOMS_SCHEDULE_FILENAME = @"calendar_rooms_feed.csv";
static NSString *const ALL_TODAYS_EVENTS_FILENAME = @"calendar_events_today_feed.csv";

@interface UTCSVFeedDownloadManager : NSObject

@property (assign, nonatomic, readonly) bool downloadIsInProgress;

+ (UTCSVFeedDownloadManager *) csv_dl_manager;
+ (void) download_all;

+ (bool) is_valid_filename : (NSString *) filename;

+ (InputReader *) get_feed_reader : (NSString *) filename;
+ (NSString *) get_feed_contents_as_string : (NSString *) filename;

+ (NSString *) get_file_path : (NSString *) filename;

+ (bool) delete_all_feeds;
+ (bool) delete_feed : (NSString *) filename;

+ (bool) feed_exists : (NSString *) filename;
+ (bool) feed_is_current : (NSString *) filename;

+ (bool) get_feed_write_success : (NSString *) filename;
//+ (bool) set_feed_write_success : (NSString *) filename success : (bool) success;

+ (bool) get_feeds_write_success;

@end










