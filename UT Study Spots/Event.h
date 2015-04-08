//
//  Event.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Location.h"
#import "Constants.h"

@interface Event : NSObject <NSCopying>

- (instancetype) initWithStrings : (NSString *) event_name start_date : (NSString *) start_date end_date : (NSString *) end_date location : (NSString *) location;
- (instancetype) initWithDatesNoLocation : (NSString *) event_name start_date : (NSDate *) date end_date : (NSDate *) end_date location : (NSString *) location;
- (instancetype) initWithDatesAndLocation : (NSString *) event_name start_date : (NSDate *) start_date end_date : (NSDate *) end_date location : (Location *) location;

- (NSDate *) get_end_date;
- (NSString *) get_event_date;
- (NSString *) get_event_name;
- (Location *) get_location;
- (NSDate *) get_start_date;
- (void) set_start_date : (NSDate *) date;
+ (NSDate *) to_date : (NSString *) date_time;

//- (id) copy;
- (id) copyWithZone : (NSZone *) zone;
- (NSComparisonResult) compare : (Event *) otherObject;
// isEqual and hash overridden

- (NSString *) toString;

@property (strong, nonatomic, readonly, getter = get_event_name) NSString *event_name;
@property (strong, nonatomic, readonly, getter = get_location) Location *location;


@end
