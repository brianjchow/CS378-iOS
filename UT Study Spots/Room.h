//
//  Room.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Location.h"
#import "Event.h"

#import "Constants.h"

@interface Room : NSObject <NSCopying>

- (instancetype) initWithLocation : (Location *) location;
- (instancetype) init : (Location *) location type : (NSString *) type capacity : (int) capacity has_power : (bool) has_power;

- (bool) add_event : (Event *) event day_of_week : (int) day_of_week;
- (NSDictionary *) get_events;
- (NSOrderedSet *) get_events : (int) day_of_week;
- (int) get_num_events;
- (Location *) get_location;
- (NSString *) get_name;
- (NSString *) get_building_name;
- (NSString *) get_room_number;
- (NSString *) get_type;
- (int) get_capacity;
- (bool) get_has_power;

// - (id) copy;
- (id) copyWithZone : (NSZone *) zone;
- (NSComparisonResult) compare : (Room *) otherObject;
// isEqual and hash overridden

- (NSString *) toString;

@property (strong, nonatomic, readonly, getter = get_location) Location *location;
@property (strong, nonatomic, readonly, getter = get_type) NSString *type;
@property (nonatomic, readonly, getter = get_capacity) int capacity;
@property (nonatomic, readonly, getter = get_has_power) bool has_power;


@end
