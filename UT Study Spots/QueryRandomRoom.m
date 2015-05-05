//
//  QueryRandomRoom.m
//  UT Study Spots
//
//  Created by Fatass on 3/30/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "QueryRandomRoom.h"

#import "EventList.h"
#import "Room.h"
#import "Building.h"

#import "Constants.h"
#import "Utilities.h"

#import "DateTools.h"
#import "NSString+Tools.h"

/*
    NOTE - all NSOrderedSets contain Strings
 */

// http://stackoverflow.com/questions/12633627/expose-a-private-objective-c-method-or-property-to-subclasses
@interface Query ()
- (NSString *) get_current_course_schedule : (SearchStatus *) search_status;
- (int) get_this_day_of_week;
- (NSDate *) copy_date_mdy : (NSDate *) from to : (NSDate *) to;
@end

@interface QueryRandomRoom ()

// search-specific helper methods

- (QueryResult *) search : (EventList *) eolist;
- (bool) is_valid_gdc_room : (Room *) room;

- (NSMutableOrderedSet *) add_invalid_rooms_by_gdc_csv_feeds : (EventList *) eolist
                                      rooms_to_remove : (NSMutableOrderedSet *) rooms_to_remove;

- (NSMutableOrderedSet *) add_invalid_rooms_by_options : (Building *) search_building
                                    valid_rooms : (NSOrderedSet *) valid_rooms
                                rooms_to_remove : (NSMutableOrderedSet *) rooms_to_remove;

- (NSMutableOrderedSet *) add_invalid_rooms_by_course_schedule : (Building *) search_building
                                            valid_rooms : (NSOrderedSet *) valid_rooms
                                        rooms_to_remove : (NSMutableOrderedSet *) rooms_to_remove;

// misc methods

- (bool) is_truncated_gdc_room : (NSString *) room;

@property (nonatomic, readwrite) int capacity;
@property (nonatomic, readwrite) bool has_power;

@end

@implementation QueryRandomRoom

// overridden
- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.capacity = 0;
        self.has_power = false;
    }
    
    return self;
}

// overridden
- (instancetype) initWithStartDate : (NSDate *) date {
    self = [super initWithStartDate : date];
    
    if (self) {
        self.capacity = 0;
        self.has_power = false;
    }
    
    return self;
}

// overridden
- (QueryResult *) search {
    return ([self search : [Constants get_csv_feeds_cleaned]]);
}

- (int) get_option_capacity {
    return self.capacity;
}

- (bool) get_option_power {
    return self.has_power;
}

- (bool) set_option_capacity : (int) capacity {
    if (capacity < 0) {
        return false;
    }
    
    self.capacity = capacity;
    return true;
}

- (bool) set_option_power : (bool) power {
    if (![[super get_option_search_building] is_gdc] && power) {
        return false;
    }
    
    self.has_power = power;
    return true;
}

// overridden
- (bool) set_option_search_building : (NSString *) building_code {
    if (![building_code is_gdc]) {
        [self set_option_power : false];
    }
    
    return [super set_option_search_building : building_code];
}

// overridden
- (id) copy {
    QueryRandomRoom *copy = [super copy];
    
    copy.capacity = self.capacity;
    copy.has_power = self.has_power;
    
    return copy;
}

// overridden
- (id) copyWithZone : (NSZone *) zone {
    QueryRandomRoom *copy = [super copyWithZone : zone];
    
    copy.capacity = self.capacity;
    copy.has_power = self.has_power;
    
    return copy;
}

// overridden
- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [QueryRandomRoom class]]) {
        return NO;
    }
    
    QueryRandomRoom *other_qrr = (QueryRandomRoom *) other;
    if (![super isEqual : other_qrr]) {
        return false;
    }
    else if (self.capacity != other_qrr.capacity || self.has_power != other_qrr.has_power) {
        return false;
    }
    
    return true;
}

// overridden
- (NSString *) toString {
    NSMutableString *out = [[super toString] mutableCopy];
    
    [out appendFormat : @"\n"];
    [out appendFormat : @"Capacity:\t%d\n", self.capacity];
    [out appendFormat : @"Power:\t%@", BOOL_STRS[self.has_power]];
    
    return out;
}

/* ************************************ PRIVATE METHODS ************************************ */

- (QueryResult *) search : (EventList *) eolist {
    
    QueryResult *query_result;
    
    NSString *search_building_str = [super get_option_search_building];
    bool searching_gdc = [search_building_str is_gdc];
    
    bool search_is_during_long_semester = true;
    SearchStatus search_status = SEARCH_ERROR;
    NSString *course_schedule = [super get_current_course_schedule : &search_status];
    
    if ([Utilities is_null : course_schedule]) {
        course_schedule = COURSE_SCHEDULE_THIS_SEMESTER;
        search_is_during_long_semester = false;
    }
    else if (![course_schedule is_valid_db_filename]) {
        // TODO - throw ISException
    }
    
    Building *search_building = [Building get_instance : search_building_str db_filename : course_schedule];
    if (!search_building) {
        query_result = [[QueryResult alloc] init : RANDOM_ROOM
                                   search_status : NO_INFO_AVAIL
                                   building_name : search_building_str
                                         results : [NSArray new]];
        
        return query_result;
    }
    
    /* Actual searching begins here */
    NSOrderedSet *all_rooms = [search_building get_keyset];     // of String
    NSMutableOrderedSet *rooms_to_remove = [NSMutableOrderedSet new];   // of String
    
    NSMutableArray *all_valid_rooms = [[NSMutableArray alloc] initWithCapacity : [all_rooms count]];    // of String
    
    /* Filter out by CSV feeds */
    if (searching_gdc && eolist) {
        rooms_to_remove = [self add_invalid_rooms_by_gdc_csv_feeds : eolist
                                                   rooms_to_remove : rooms_to_remove];
    }
    
//    NSLog(@"step 0: rooms to remove is now\n%@", rooms_to_remove);
    
    /* Check room characteristics (options) */
    rooms_to_remove = [self add_invalid_rooms_by_options : search_building
                                             valid_rooms : all_rooms
                                         rooms_to_remove : rooms_to_remove];
    
//    NSLog(@"step 1: rooms to remove is now\n%@", rooms_to_remove);
    
    /* If search occurs during one of the two long semesters, check course schedule */
    if (search_is_during_long_semester) {
        rooms_to_remove = [self add_invalid_rooms_by_course_schedule : search_building
                                                         valid_rooms : all_rooms
                                                     rooms_to_remove : rooms_to_remove];
    }

//    NSLog(@"step 2: rooms to remove is now\n%@", rooms_to_remove);
    
    /* Search complete */
    
    /* "Remove" invalid rooms from valid_rooms */
    for (NSString *check_remove_room in all_rooms) {
        if (![rooms_to_remove containsObject : check_remove_room]) {
            if (searching_gdc && [self is_truncated_gdc_room : check_remove_room]) {
                NSString *temp = [NSString stringWithFormat : @"%@0", check_remove_room];
                [all_valid_rooms addObject : temp];
            }
            else {
                [all_valid_rooms addObject : check_remove_room];
            }
        }
    }
    
    if (search_is_during_long_semester) {
        if ([all_valid_rooms count] <= 0) {
            search_status = NO_ROOMS_AVAIL;
        }
        else {
            search_status = SEARCH_SUCCESS;
        }
    }
    
    all_valid_rooms = [self sort_by_time : all_valid_rooms];
    
    query_result = [[QueryResult alloc] init : RANDOM_ROOM
                               search_status : search_status
                               building_name : search_building_str
                                     results : all_valid_rooms];
    
    return query_result;
}

- (NSMutableOrderedSet *) add_invalid_rooms_by_gdc_csv_feeds : (EventList *) eolist
                                      rooms_to_remove : (NSMutableOrderedSet *) rooms_to_remove {
    
    Event *curr_event;
    NSString *curr_room_str;
    
    NSEnumerator *itr = [eolist get_enumerator];
    while (curr_event = [itr nextObject]) {
        curr_room_str = [[curr_event get_location] get_room];

        if ([Utilities dates_occur_on_same_day : [curr_event get_start_date]
                                         date2 : [super get_start_date]] &&
            
            [Utilities times_overlap : [curr_event get_start_date]
                                end1 : [curr_event get_end_date]
                              start2 : [super get_start_date]
                                end2 : [super get_end_date]]) {
            
                [rooms_to_remove addObject : curr_room_str];
        }
        
    }
    
    return rooms_to_remove;
}

- (NSMutableOrderedSet *) add_invalid_rooms_by_options : (Building *) search_building
                                    valid_rooms : (NSOrderedSet *) valid_rooms
                                rooms_to_remove : (NSMutableOrderedSet *) rooms_to_remove {
    
    Room *curr_room;
    NSString *curr_room_str;
    
    for (curr_room_str in valid_rooms) {
        curr_room = [search_building get_room : curr_room_str];
        
        if ([rooms_to_remove containsObject : curr_room_str]) {
            continue;
        }
        
        if ([[super get_option_search_building] is_gdc] &&
            ![self is_valid_gdc_room : curr_room]) {
            
            [rooms_to_remove addObject : curr_room_str];
        }
        else {
            if ([curr_room get_capacity] < self.capacity) {
                [rooms_to_remove addObject : curr_room_str];
            }
        }
    }
    
    return rooms_to_remove;
}

- (NSMutableOrderedSet *) add_invalid_rooms_by_course_schedule : (Building *) search_building
                                            valid_rooms : (NSOrderedSet *) valid_rooms
                                        rooms_to_remove : (NSMutableOrderedSet *) rooms_to_remove {
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int today = [super get_this_day_of_week];   // NSLog(@"TODAY IS %d\n", today);
    Room *curr_room;
    
    NSDate *curr_start_date, *curr_end_date, *query_start_date, *query_end_date;
//    NSInteger start_month, start_day, start_year, end_month, end_day, end_year;
    
    query_start_date = [super get_start_date];
//    start_month = query_start_date.month;
//    start_day = query_start_date.day;
//    start_year = query_start_date.year;
    
    query_end_date = [super get_end_date];
//    end_month = query_end_date.month;
//    end_day = query_end_date.day;
//    end_year = query_end_date.year;
    
//    NSDateComponents *start_comps, *end_comps;
//    start_comps = [Utilities get_date_components_with_calendar : UNIT_FLAGS calendar : calendar date : query_start_date];
//    end_comps = [Utilities get_date_components_with_calendar : UNIT_FLAGS calendar : calendar date : query_end_date];
    
//    NSDateComponents *curr_comps;
    for (NSString *curr_room_str in valid_rooms) {
        if ([rooms_to_remove containsObject : curr_room_str]) {
            continue;
        }
        
        curr_room = [search_building get_room : curr_room_str];
        if (!curr_room) {
            continue;
        }
        
        NSOrderedSet *courses = [curr_room get_events : today];    // of Events
        
        for (Event *curr_event in courses) {
            curr_start_date = [curr_event get_start_date];
            curr_end_date = [curr_event get_end_date];
            
//            curr_comps = [Utilities get_date_components_with_calendar : UNIT_FLAGS calendar : calendar date : curr_start_date];
//            curr_comps.month = start_month;
//            curr_comps.day = start_day;
//            curr_comps.year = start_year;
//            curr_start_date = [calendar dateFromComponents : curr_comps];
//            
//            curr_comps = [Utilities get_date_components_with_calendar : UNIT_FLAGS calendar : calendar date : curr_end_date];
//            curr_comps.month = end_month;
//            curr_comps.day = end_day;
//            curr_comps.year = end_year;
//            curr_end_date = [calendar dateFromComponents : curr_comps];
            
            curr_start_date = [self copy_date_mdy : query_start_date to : curr_start_date];
            curr_end_date = [self copy_date_mdy : query_end_date to : curr_end_date];
            
//            NSLog(@"\nCurr start date: %@\nCurr end date: %@\nQuery start date: %@\nQuery end date: %@\n", [curr_start_date toString], [curr_end_date toString], [query_start_date toString], [query_end_date toString]);
            
//            if ([Utilities times_overlap : curr_start_date
            if ([Utilities dates_overlap : curr_start_date
                                    end1 : curr_end_date
                                  start2 : query_start_date
                                    end2 : query_end_date]) {
                
                [rooms_to_remove addObject : curr_room_str];
                break;
            }
        }
    }
    
    return rooms_to_remove;
}

- (NSDate *) copy_date_mdy : (NSDate *) from to : (NSDate *) to {
    NSDateComponents *comps = [Utilities get_date_components : UNIT_FLAGS date : to];
    comps.month = from.month;
    comps.day = from.day;
    comps.year = from.year;
    
    NSDate *out = [[NSCalendar currentCalendar] dateFromComponents : comps];
    
    return out;
}

- (bool) is_valid_gdc_room : (Room *) room {
    if ([Utilities is_null : room]) {
        return false;
    }
    
    Location *location = [room get_location];
    if (![[location get_building] is_gdc]) {
        return false;
    }
    
    if ([[location get_room] equalsIgnoreCase : @"2.506"]) {
        return false;
    }
    
    if ([room get_capacity] < self.capacity ||
        (self.has_power && ![room get_has_power])) {
        return false;
    }
    
    return true;
}

- (bool) is_truncated_gdc_room : (NSString *) room {
    if ([Utilities is_null : room]) {
        return false;
    }
    
    if ([[super get_option_search_building] is_gdc] &&
        ([room isEqualToString : @"2.21"] || [room isEqualToString : @"2.41"])) {
        return true;
    }
    return false;
}

- (NSMutableArray *) sort_by_time : (NSArray *) to_sort {
    NSMutableArray *out = [[NSMutableArray alloc] initWithCapacity : [to_sort count]];
    
    for (Event *event in to_sort) {
        bool inserted = false;
        NSUInteger insert_index = 0;
        while (insert_index < [out count]) {
            if ([event compare : [out objectAtIndex : insert_index]] < 0) {
                [out insertObject : event atIndex : insert_index];
                inserted = true;
                break;
            }
            
            insert_index++;
        }
        
        if (!inserted) {
            [out addObject : event];
        }
    }
    
    return out;
}

@end










