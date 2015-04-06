//
//  UTCSVFeedDownloadManager.h
//  UT Study Spots
//
//  Created by Fatass on 4/1/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Utilities.h"

static NSString *const ALL_EVENTS_SCHEDULE = @"https://www.cs.utexas.edu/calendar/touch/feed";
static NSString *const ALL_ROOMS_SCHEDULE = @"https://www.cs.utexas.edu/calendar/touch/all/feed";
static NSString *const ALL_TODAYS_EVENTS = @"https://www.cs.utexas.edu/calendar/touch/today/feed";

static NSString *const ALL_EVENTS_SCHEDULE_FILENAME = @"calendar_events_feed.csv";
static NSString *const ALL_ROOMS_SCHEDULE_FILENAME = @"calendar_rooms_feed.csv";
static NSString *const ALL_TODAYS_EVENTS_FILENAME = @"calendar_events_today_feed.csv";


@interface UTCSVFeedDownloadManager : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic, readonly) NSString *filename;
@property (strong, nonatomic, readonly) NSURL *url;

@property (strong, nonatomic) id <NSURLConnectionDataDelegate> delegate;

- (instancetype) initWithURLString : (NSString *) url_str filename : (NSString *) filename;
//- (instancetype) initWithURL : (NSURL *) url filename : (NSString *) filename;

- (void) download;

+ (bool) delete_all_feeds;
+ (bool) delete_feed : (NSString *) filename;

+ (bool) feed_exists : (NSString *) filename;
+ (bool) feed_is_current : (NSString *) filename;

+ (bool) get_csv_feed_write_success : (NSString *) pref_name;
+ (bool) set_csv_feed_write_success : (NSString *) filename success : (bool) success;

+ (bool) get_csv_feeds_write_success;

@end










