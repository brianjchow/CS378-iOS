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

static NSString *const ALL_EVENTS_SCHEDULE = @"https://www.cs.utexas.edu/calendar/touch/feed";
static NSString *const ALL_ROOMS_SCHEDULE = @"https://www.cs.utexas.edu/calendar/touch/all/feed";
static NSString *const ALL_TODAYS_EVENTS = @"https://www.cs.utexas.edu/calendar/touch/today/feed";

static NSString *const ALL_EVENTS_SCHEDULE_FILENAME = @"calendar_events_feed.csv";
static NSString *const ALL_ROOMS_SCHEDULE_FILENAME = @"calendar_rooms_feed.csv";
static NSString *const ALL_TODAYS_EVENTS_FILENAME = @"calendar_events_today_feed.csv";


@interface UTCSVFeedDownloadManager : NSObject



@end










