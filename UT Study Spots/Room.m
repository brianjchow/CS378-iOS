//
//  Room.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "Room.h"

#import "Utilities.h"

#import "NSString+Tools.h"

static NSString *const TAB = @"    ";

@interface Room ()

@property (strong, nonatomic, readwrite) Location *location;
@property (strong, nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) int capacity;
@property (nonatomic, readwrite) bool has_power;

// NSMutableDictionary<NSNumber, NSMutableSet<Event>>
@property (strong, nonatomic) NSMutableDictionary *course_schedule;

@end

@implementation Room

- (instancetype) initWithLocation : (Location *) location {
    return [self init : location type : DEFAULT_ROOM_TYPE capacity : DEFAULT_ROOM_CAPACITY has_power : false];
}

- (instancetype) init : (Location *) location type : (NSString *) type capacity : (int) capacity has_power : (bool) has_power {
    if ([Utilities is_null : location] || [Utilities is_null : type] || capacity < DEFAULT_ROOM_CAPACITY) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        self.location = location;
        self.type = type;
        self.capacity = capacity;
        self.has_power = has_power;
        
        NSMutableDictionary *course_schedule_mutable = [[NSMutableDictionary alloc] initWithCapacity : 7];
        
        [course_schedule_mutable setObject : [NSMutableOrderedSet new] forKey : [NSNumber numberWithInt : MONDAY]];
        [course_schedule_mutable setObject : [NSMutableOrderedSet new] forKey : [NSNumber numberWithInt : TUESDAY]];
        [course_schedule_mutable setObject : [NSMutableOrderedSet new] forKey : [NSNumber numberWithInt : WEDNESDAY]];
        [course_schedule_mutable setObject : [NSMutableOrderedSet new] forKey : [NSNumber numberWithInt : THURSDAY]];
        [course_schedule_mutable setObject : [NSMutableOrderedSet new] forKey : [NSNumber numberWithInt : FRIDAY]];
        [course_schedule_mutable setObject : [NSMutableOrderedSet new] forKey : [NSNumber numberWithInt : SATURDAY]];
        [course_schedule_mutable setObject : [NSMutableOrderedSet new] forKey : [NSNumber numberWithInt : SUNDAY]];
        
        self.course_schedule = course_schedule_mutable;
    }
    
    return self;
}

- (bool) add_event : (Event *) event day_of_week : (int) day_of_week {
    if ([Utilities is_null : event] || ![Utilities valid_day_of_week : day_of_week]) {
//        NSLog(@"fuck1");
        return false;
    }

//    NSLog(@"%@", [event toString]);
    
    NSNumber *day = [NSNumber numberWithInt : day_of_week];
    
    NSMutableOrderedSet *events = [self.course_schedule objectForKey : day];
    if ([events containsObject : event]) {
//        NSLog(@"fuck2");
        return false;
    }
    
    if ([events count] == 0) {
        [events addObject : event];
    }
    else {
        NSUInteger insert_index = 0;
        while (insert_index < [events count]) {
            if ([event compare : [events objectAtIndex : insert_index]] < 0) {
                [events insertObject : event atIndex : insert_index];
                break;
            }
            
            insert_index++;
        }
    }
    
//    [events addObject : event];
    [self.course_schedule setObject : events forKey : day];
    
//    NSLog(@"%@", self.course_schedule);
    
    return true;
}

- (NSDictionary *) get_events {
    return self.course_schedule;
}

- (NSOrderedSet *) get_events : (int) day_of_week {
    if (![Utilities valid_day_of_week : day_of_week]) {
        // TODO - throw IAException
    }
    
    NSOrderedSet *curr_day_events = [self.course_schedule objectForKey : [NSNumber numberWithInt : day_of_week]];
    return curr_day_events;
}

- (int) get_num_events {
    int total_size = 0;
    
    NSOrderedSet *curr_day_events;
    for (int i = MONDAY; i <= SUNDAY; i++) {
        curr_day_events = [self.course_schedule objectForKey : [NSNumber numberWithInt : i]];
        total_size += [curr_day_events count];
    }
    
    return total_size;
}

- (Location *) get_location {
    return self.location;
}

- (NSString *) get_name {
    return ([self.location toString]);
}

- (NSString *) get_building_name {
    return ([self.location get_building]);
}

- (NSString *) get_room_number {
    return ([self.location get_room]);
}

- (NSString *) get_type {
    return self.type;
}

- (int) get_capacity {
    return self.capacity;
}

- (bool) get_has_power {
    return self.has_power;
}

- (id) copy {
    Room *out = [[Room alloc] initWithLocation : [self.location copy]];

    if (out) {
        out.type = self.type;
        out.capacity = self.capacity;
        out.has_power = self.has_power;
        
        NSMutableDictionary *course_schedule_mutable = [[NSMutableDictionary alloc] initWithCapacity : 7];
        NSMutableOrderedSet *curr_schedule;
        NSMutableOrderedSet *schedule_to_add;
        
        for (int i = MONDAY; i <= SUNDAY; i++) {
            curr_schedule = [self.course_schedule objectForKey : [NSNumber numberWithInt : i]];
            if (![Utilities is_null : curr_schedule] && [curr_schedule count] > 0) {
                schedule_to_add = [[NSMutableOrderedSet alloc] initWithCapacity : [curr_schedule count]];
                for (Event *event in curr_schedule) {
                    [schedule_to_add addObject : [event copy]];
                }
            }
            else {
                schedule_to_add = [NSMutableOrderedSet new];
            }
            [course_schedule_mutable setObject : schedule_to_add forKey : [NSNumber numberWithInt : i]];
        }
        
        out.course_schedule = course_schedule_mutable;
    }
    
    return out;
}

- (id) copyWithZone : (NSZone *) zone {
    
    Room *out = [[[self class] allocWithZone : zone] init];
    
    if (out) {
//        out.location = [self.location copyWithZone : zone];
 //       out.type = [self.type copyWithZone : zone];
        out.location = [self.location copy];
        out.type = [self.type copy];
        out.capacity = self.capacity;
        out.has_power = self.has_power;
        
//        out.course_schedule = [self.course_schedule copyWithZone : zone];   // ? !!!!!!!!!!!!!!!!!!!!!!!!!!!!
        out.course_schedule = [[NSMutableDictionary alloc] initWithCapacity : [self.course_schedule count]];
        for (NSNumber *num in self.course_schedule) {
            NSNumber *num_copy = [num copy];
            
            NSMutableSet *curr_day_events = [self.course_schedule objectForKey : num];
            NSMutableSet *curr_day_events_copy = [[NSMutableSet alloc] initWithCapacity : [curr_day_events count]];
            for (Event *curr_event in curr_day_events) {
                Event *curr_event_copy = [curr_event copy];
                [curr_day_events_copy addObject : curr_event_copy];
            }
            
            [out.course_schedule setObject : curr_day_events_copy forKey : num_copy];
        }
    }
    
//    if (out) {
//        out.location = self.location;
//        out.type = self.type;
//        out.capacity = self.capacity;
//        out.has_power = self.has_power;
//        out.course_schedule = self.course_schedule;
//    }
    
    return out;
    
//    return self;
}

// IS THIS WHAT WE REALLY WANT? !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
- (NSComparisonResult) compare : (Room *) otherObject {
    int compare;
    
    compare = [self.location compare : otherObject.location];
    if (compare != 0) {
        return compare;
    }
    
    compare = [self.type compare : otherObject.type];
    if (compare != 0) {
        return compare;
    }
    
    compare = [[NSNumber numberWithInt : self.capacity] compare : [NSNumber numberWithInt : otherObject.capacity]];
    if (compare != 0) {
        return compare;
    }
    
//    if (self.has_power != otherObject.has_power) {
//        if (self.has_power) {
//            return NSOrderedDescending;
//        }
//        else {
//            return NSOrderedAscending;
//        }
//    }
    
    return NSOrderedSame;
}

- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [Room class]]) {
        return NO;
    }
    
    Room *other_room = (Room *) other;
    if ([self.location isEqual : other_room.location] &&
        [self.type isEqualToString : other_room.type] &&
        self.capacity == other_room.capacity &&
        self.has_power == other_room.has_power) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger) hash {
    return ([[self.location toString] hash]);
}

- (NSString *) toString {
    NSMutableString *out = [NSMutableString new];
    
    [out appendFormat : @"Room:\t%@\n", [self.location toString]];
    [out appendFormat : @"Type:\t%@\n", self.type];
    [out appendFormat : @"Size:\t%d\n", self.capacity];
    [out appendFormat : @"Power:\t%@\n", BOOL_STRS[self.has_power]];
    [out appendFormat : @"Schedule:\n%@%d weekly class(es)\n", TAB, [self get_num_events]];
    
    for (int i = MONDAY; i <= SUNDAY; i++) {
        [out appendFormat : @"%@%@: ", TAB, DAYS_OF_WEEK_SHORT[i]];
        
        NSMutableOrderedSet *temp = [self.course_schedule objectForKey : [NSNumber numberWithInt : i]];
//        Set<Event> sorted_by_time = new TreeSet<Event>(temp);
        
        int counter = 0;
        for (Event *event in temp) {
            if (counter > 0) {
                [out appendFormat : @", "];
            }
            [out appendFormat : @"%@ (%@)", [event get_event_name], [Utilities get_time : [event get_start_date]]];
            counter++;
        }
        
        [out appendFormat : @"\n"];
    }
    
    return out;
}

- (NSString *) description {
    return [self toString];
}


@end
