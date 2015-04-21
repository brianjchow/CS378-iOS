//
//  QueryRoomSchedule.m
//  UT Study Spots
//
//  Created by Fatass on 3/30/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "QueryRoomSchedule.h"

#import "EventList.h"
#import "Room.h"
#import "Building.h"
#import "QueryResult.h"

#import "Utilities.h"
#import "Constants.h"

#import "DateTools.h"
#import "NSString+Tools.h"

/*
    TODO
        - override copy/copyWithZone/equals
 */

@interface Query ()
- (NSString *) get_current_course_schedule : (SearchStatus *) search_status;
- (int) get_this_day_of_week;
@end

@interface QueryRoomSchedule ()

// search-specific methods

- (QueryResult *) search : (EventList *) eolist;
- (Room *) get_search_room : (Building *) search_building;

- (NSOrderedSet *) get_course_schedule_for_room : (Room *) search_room
          search_is_during_long_semester : (bool) search_is_during_long_semester;

// returns NSMutableSet of Events
- (NSOrderedSet *) add_gdc_csv_feed_events : (EventList *) eolist
                         all_events : (NSMutableOrderedSet *) all_events   // of Events
                        search_room : (Room *) search_room
     search_is_during_long_semester : (bool) search_is_during_long_semester;

// returns NSArray of Strings
- (NSArray *) eventset_to_string : (NSOrderedSet *) eventset;   // of Events

// misc methods

- (bool) needs_truncation_gdc_room : (NSString *) room;

@property (strong, nonatomic, readwrite) NSString *search_room;

@end

@implementation QueryRoomSchedule

// overridden
- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.search_room = RANDOM;
    }
    
    return self;
}

// overridden
- (instancetype) initWithStartDate : (NSDate *) date {
    self = [super initWithStartDate : date];
    
    if (self) {
        self.search_room = RANDOM;
    }
    
    return self;
}

// overridden
- (QueryResult *) search {
    return ([self search : [Constants get_csv_feeds_cleaned]]);    
}

- (NSString *) get_option_search_room {
    return self.search_room;
}

- (bool) set_option_search_room : (NSString *) room_num {
    if ([Utilities is_null : room_num]) {
        // TODO - throw IAException
    }
    
    if ([self needs_truncation_gdc_room : room_num]) {
        self.search_room = [room_num substring : 0 stop : 4];     // [0, 4) is guaranteed; see needs_truncation_gdc_room()
    }
    else {
        self.search_room = room_num;
    }
    
    return true;
}

// overridden
- (id) copy {
    QueryRoomSchedule *copy = [super copy];
    
    copy.search_room = [self.search_room copy];
    
    return copy;
}

// overridden
- (id) copyWithZone : (NSZone *) zone {
    QueryRoomSchedule *copy = [super copyWithZone : zone];
    
    copy.search_room = [self.search_room copyWithZone : zone];
    
    return copy;
}

// overridden
- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [QueryRoomSchedule class]]) {
        return NO;
    }
    
    QueryRoomSchedule *other_qrs = (QueryRoomSchedule *) other;
    if (![super isEqual : other_qrs]) {
        return false;
    }
    else if (![self.search_room isEqualToString : other_qrs.search_room]) {
        return false;
    }
    
    return true;
}

// overridden
- (NSString *) toString {
    NSMutableString *out = [[super toString] mutableCopy];
    
    [out appendFormat : @"\n"];
    [out appendFormat : @"Room:\t%@", self.search_room];
    
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
        query_result = [[QueryResult alloc] init : ROOM_SCHEDULE
                                   search_status : NO_INFO_AVAIL
                                   building_name : search_building_str
                                         results : [NSArray new]];
        
        return query_result;
    }
    
    Room *search_room = [self get_search_room : search_building];
    if (!search_room) {
        query_result = [[QueryResult alloc] init : ROOM_SCHEDULE
                                   search_status : NO_INFO_AVAIL
                                   building_name : search_building_str
                                         results : [NSArray new]];
        
        return query_result;
    }
    
    /* Actual searching begins here */
    
    NSOrderedSet *all_events = [self get_course_schedule_for_room : search_room search_is_during_long_semester : search_is_during_long_semester];
    
    if (searching_gdc && eolist) {
        all_events = [self add_gdc_csv_feed_events : eolist
                                        all_events : [all_events mutableCopy]
                                       search_room : search_room
                    search_is_during_long_semester : search_is_during_long_semester];
    }
    
    NSArray *schedule = [self eventset_to_string : all_events];
    
    /* Search complete here */
    
    if (search_is_during_long_semester) {
        if ([schedule count] <= 0) {
            search_status = ROOM_FREE_ALL_DAY;
        }
        else {
            search_status = SEARCH_SUCCESS;
        }
    }
    
    query_result = [[QueryResult alloc] init : ROOM_SCHEDULE
                               search_status : search_status
                               building_name : search_building_str
                                     results : schedule];
    
    return query_result;
}

- (Room *) get_search_room : (Building *) search_building {
    NSString *search_room_str = self.search_room;
    if (![search_room_str isEqualToString : RANDOM]) {
        return ([search_building get_room : search_room_str]);
    }
    return ([search_building get_random_room]);
}

- (NSOrderedSet *) get_course_schedule_for_room : (Room *) search_room
          search_is_during_long_semester : (bool) search_is_during_long_semester {
    
    NSMutableOrderedSet *all_events;       // of Events
    
    if (search_is_during_long_semester) {
        int today = [super get_this_day_of_week];
        all_events = [[search_room get_events : today] mutableCopy];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *start_date = [super get_start_date];
        NSInteger month = start_date.month;
        NSInteger day = start_date.day;
        NSInteger year = start_date.year;
        
//        NSDateComponents *start_comps = [Utilities get_date_components : UNIT_FLAGS date : start_date];
        
        NSDate *curr_start_date;
        NSDateComponents *curr_start_date_comps;
        for (Event *event in all_events) {
            curr_start_date = [event get_start_date];
            curr_start_date_comps = [Utilities get_date_components_with_calendar : UNIT_FLAGS calendar : calendar date : curr_start_date];
            
            curr_start_date_comps.month = month;
            curr_start_date_comps.day = day;
            curr_start_date_comps.year = year;
            
            [event set_start_date : [calendar dateFromComponents : curr_start_date_comps]];
        }
    }
    
    // summer hours
    else {
        all_events = [NSMutableOrderedSet new];
    }
    
    return all_events;
}

- (NSMutableSet *) add_gdc_csv_feed_events : (EventList *) eolist
                         all_events : (NSMutableSet *) all_events
                        search_room : (Room *) search_room
     search_is_during_long_semester : (bool) search_is_during_long_semester {
    
    bool is_valid = true;
    NSEnumerator *itr = [eolist get_enumerator];
    
    Event *event;
    while (event = [itr nextObject]) {
        
        if ([[event get_location] isEqual : [search_room get_location]] &&
            [Utilities dates_occur_on_same_day : [event get_start_date] date2 : [super get_start_date]]) {
            
            if (search_is_during_long_semester) {
                
                /*
                    This loop IS necessary. The CSV feeds also list courses occurring, with
                    their names prefixed by the word "Registrar"; however, it also files
                    extracurricular events (such as tutoring sessions) with the "Registrar"
                    prefix, meaning that for maximum accuracy we can't just simply ignore
                    all Events from the CSV feeds that are prefixed with "Registrar."
                 */
                for (Event *course_event in all_events) {
                    if ([[course_event get_event_name] containsIgnoreCase : [event get_event_name]]) {
                        
                        is_valid = false;
                        break;
                    }
                }
            }
            
            if (is_valid) {
                [all_events addObject : event];
            }
            
            is_valid = true;
        }
    }
    
    return all_events;
}

// returns List<String>
- (NSArray *) eventset_to_string : (NSSet *) eventset {
    NSMutableArray *schedule = [[NSMutableArray alloc] initWithCapacity : [eventset count]];
    
    NSString *event_name, *start_time, *end_time;
    NSMutableString *event_str = [[NSMutableString alloc] initWithCapacity : 50];
    
    Event *prev_event = nil;
    for (Event *event in eventset) {
        event_name = [event get_event_name];
        start_time = [Utilities get_time : [event get_start_date]];
        end_time = [Utilities get_time : [event get_end_date]];
        
        if (prev_event) {
            
            /* Allow identical courses listed under different departments */
            if ([event_name equalsIgnoreCase : [prev_event get_event_name]] &&
                [start_time isEqualToString : [Utilities get_time : [prev_event get_start_date]]]) {
                continue;
            }
        }
        else {
            prev_event = event;
        }
        
        [event_str appendFormat : @"%@\n", event_name];
        [event_str appendFormat : @"Start: %@\n", start_time];
        [event_str appendFormat : @"End: %@\n", end_time];
        [event_str appendFormat : @"\n"];
        
        [schedule addObject : event_str];
        event_str = [[NSMutableString alloc] initWithCapacity : 50];
    }
    
    return schedule;
}

- (bool) needs_truncation_gdc_room : (NSString *) room {
    if ([Utilities is_null : room]) {
        return false;
    }
    
    if ([[super get_option_search_building] is_gdc] &&
        ([room isEqualToString : @"2.210"] || [room isEqualToString : @"2.410"])) {
        return true;
    }
    return false;
}


@end










