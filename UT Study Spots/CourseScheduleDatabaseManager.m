//
//  CourseScheduleDatabaseManager.m
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "CourseScheduleDatabaseManager.h"

#import "Room.h"
#import "Constants.h"
#import "Utilities.h"

#import "NSString+Tools.h"
#import "SQLiteManager.h"

@interface CourseScheduleDatabaseManager ()

// of bool
+ (NSMutableArray *) initialise_days_of_week_array;

// of bool
+ (NSMutableArray *) set_meeting_days : (NSString *) code;

// Map<String, Room>
+ (NSMutableDictionary *) initialise_gdc_room_properties;

@end

@implementation CourseScheduleDatabaseManager

static NSString *const ROOM = @"room";
static NSString *const NAME = @"name";
static NSString *const MEETING_DAYS = @"meeting_days";
static NSString *const START_TIME = @"start_time";
static NSString *const END_TIME = @"end_time";

// Map<String, Room>
+ (NSDictionary *) get_courses : (NSString *) building_code db_filename : (NSString *) db_filename {
    if ([Utilities is_null : building_code] || ![building_code is_campus_building]) {
        // TODO - throw IAException
    }
    
//    NSMutableDictionary *out = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *out;
    
    building_code = [building_code uppercaseString];
    
    NSString *table_name, *query;
    NSString *db_path;
    SQLiteManager *db;
    
    table_name = [db_filename strip_filename_ext : nil];
    db_path = [Utilities get_file_path : table_name ext : DEFAULT_DB_EXT];
    db = [[SQLiteManager alloc] initWithDatabaseNamed : db_path];
    
    query = [NSString stringWithFormat : @"SELECT * FROM %@ WHERE building=\"%@\"", table_name, building_code];
    
    NSLog(@"Selecting from table %@ in db file %@", table_name, db_filename);
    NSLog(@"Query: %@", query);
    
    /* Contains dictionaries, each of which represents a single row in the DB. Dictionary keys are
        the names of each column in the table.*/
    NSArray *results = [db getRowsForQuery : query];
    
    bool building_is_gdc = [building_code is_gdc];
    if (building_is_gdc) {
        out = [self initialise_gdc_room_properties];
        
//        NSLog(@"%@", out);
        
//        for (NSString *room_num in out) {
//            NSLog(@"Room num: %@\tType is NSString: %d", room_num, [room_num isKindOfClass : [NSString class]]);
//        }
        
//        NSArray *fuck = [out allValues];
//        for (Room *crap in fuck) {
//            if ([Utilities is_null : crap]) {
//                NSLog(@"crap");
//            }
//            else {
//                NSLog(@"%@", crap);
//            }
//        }
        
//        for (id key in [out allKeys]) {
//            NSLog(@"%@: %@", key, [[key class] description]);
//        }
//        NSString *regstr = @"Hello world";
//        NSLog(@"Regular string: %@: %@", regstr, [[regstr class] description]);
    }
    
    NSString *room_num, *name;
    NSMutableArray *meeting_days;
    NSDate *start_date, *end_date;
    NSInteger capacity;
    
    Room *room;
    Location *location;
    Event *event;
    NSInteger start_time, end_time;
    
    for (NSDictionary *curr_row in results) {
        room_num = [[curr_row objectForKey : ROOM] stringValue];
        capacity = [[curr_row objectForKey : CAPACITY] integerValue];
        name = [curr_row objectForKey : NAME];
        meeting_days = [self set_meeting_days : [curr_row objectForKey : MEETING_DAYS]];
        
        start_time = [[curr_row objectForKey : START_TIME] integerValue];
        end_time = [[curr_row objectForKey : END_TIME] integerValue];
        
        start_date = [Utilities get_date_with_time: start_time];
        end_date = [Utilities get_date_with_time : end_time];
        
//        NSLog(@"\n\tCurr row: %@", curr_row);
//        NSLog(@"\n\tRoom num: %@", room_num);
//        NSLog(@"\n\tRoom num: %@\n\tCapacity: %ld\n\tName: %@\n\tMeets: %@\n\tStart: %ld\n\tEnd: %ld", room_num, capacity, name, meeting_days, start_time, end_time);
//        NSLog(@"\n\tStart date: %@\n\tEnd date: %@", start_date, end_date);
//        NSLog(@"Room number: %@ (%lu) (%d) (%@)", room_num, room_num.length, [room_num isKindOfClass : [NSString class]], [[room_num class] description]);
        
        if (start_date && end_date) {
            
            room = [out objectForKey : room_num];
//            if (room == nil && building_is_gdc) {
////                NSLog(@"Skipping %@", room_num);
//                
//                continue;
//            }

            location = [[Location alloc] initSeparated : building_code room : room_num];
            event = [[Event alloc] initWithDatesAndLocation : name start_date : start_date end_date : end_date location : location];
            
            if (room == nil) {
                
//                if (_DEBUG && building_is_gdc ) NSLog(@"SHOULDN'T SEE THIS FOR GDC (%@)", room_num);
                
                if (building_is_gdc) {
                    NSString *curr_room = nil;
                    for (curr_room in out) {
//                        NSLog(@"Curr room: %@ Room num from db: %@", curr_room, room_num);
                        if ([curr_room equalsIgnoreCase : room_num]) {
//                            NSLog(@"BREAKING");
                            room = [out objectForKey : curr_room];
                            break;
                        }
                    }
                    
                    if (curr_room != nil) {
//                        room = [[out objectForKey : curr_room] copy];
                        [out removeObjectForKey : curr_room];
                    }
                    else {
//                        continue;
                    }
                }
                
                if (capacity > 0) {
                    room = [[Room alloc] init : location type : DEFAULT_ROOM_TYPE capacity : (int) capacity has_power : false];
                }
                else {
                    room = [[Room alloc] initWithLocation : location];
                }
            }
            
            for (int i = MONDAY; i <= SUNDAY; i++) {
                if ([[meeting_days objectAtIndex : i] boolValue]) {
                    [room add_event : event day_of_week : i];
                }
            }
            
            [out setObject : room forKey : room_num];
        }
    }
    
    if (_DEBUG) {
//        NSLog(@"Number of courses in %@: %lu", building_code, [out count]);
//        NSLog(@"%@", out);
        
//        NSArray *keys = [out allKeys];
//        NSLog(@"%@", keys);
    }
    
    return out;
}

/* ************************************ PRIVATE METHODS ************************************ */

// of bool
+ (NSMutableArray *) initialise_days_of_week_array {
    NSMutableArray *out = [[NSMutableArray alloc] initWithCapacity : NUM_DAYS_IN_WEEK];
    
    for (int i = 0; i < NUM_DAYS_IN_WEEK; i++) {
        out[i] = [NSNumber numberWithBool : NO];
    }
    
    return out;
}

// of bool
+ (NSMutableArray *) set_meeting_days : (NSString *) code {
    if ([Utilities is_null : code]) {
        // TODO - throw IAException
    }
    
    NSMutableArray *days = [self initialise_days_of_week_array];
    
    NSUInteger code_length = code.length;
    for (int i = 0; i < code_length ; i++) {
        unichar curr_char = [code characterAtIndex : i];
        NSString *char_to_str = [NSString stringWithCharacters : &curr_char length : 1];    // RISKY BIZNIZ
        
        if ([char_to_str containsIgnoreCase : @"t"]) {
//            unichar next_char = [code characterAtIndex : i + 1];
//            if (i < code_length - 1 && [Utilities containsIgnoreCase : [NSString stringWithCharacters : &next_char length : 1] what : @"h"]) {
//                days[THURSDAY] = [NSNumber numberWithBool : YES];
//                i++;
//            }
            if (i < code_length - 1) {
                unichar next_char = [code characterAtIndex : i + 1];
                if ([[NSString stringWithCharacters : &next_char length : 1] containsIgnoreCase : @"h"]) {
                    days[THURSDAY] = [NSNumber numberWithBool : YES];
                }
                else {
                    days[TUESDAY] = [NSNumber numberWithBool : YES];
                }
            }
            else {
                days[TUESDAY] = [NSNumber numberWithBool : YES];
            }
            continue;
        }
        
        if ([char_to_str containsIgnoreCase : @"m"]) {
            days[MONDAY] = [NSNumber numberWithBool : YES];
            continue;
        }
        else if ([char_to_str containsIgnoreCase : @"w"]) {
            days[WEDNESDAY] = [NSNumber numberWithBool : YES];
            continue;
        }
        else if ([char_to_str containsIgnoreCase : @"f"]) {
            days[FRIDAY] = [NSNumber numberWithBool : YES];
            continue;
        }
    }
    
    return days;
}

// Map<String, Room>
+ (NSMutableDictionary *) initialise_gdc_room_properties {
    NSMutableDictionary *out = [[NSMutableDictionary alloc] initWithCapacity : NUM_VALID_GDC_ROOMS];
    
    Room *room;
    for (int i = 0; i < NUM_VALID_GDC_ROOMS; i++) {
        if ((!INCLUDE_GDC_CONFERENCE_ROOMS && [VALID_GDC_ROOMS_TYPES[i] equalsIgnoreCase : CONFERENCE]) ||
            (!INCLUDE_GDC_LOBBY_ROOMS && [VALID_GDC_ROOMS_TYPES[i] equalsIgnoreCase : LOBBY]) ||
            (!INCLUDE_GDC_LOUNGE_ROOMS && [VALID_GDC_ROOMS_TYPES[i] equalsIgnoreCase : LOUNGE])) {
            
//            NSLog(@"Skipping GDC %@", VALID_GDC_ROOMS[i]);
            
            continue;
        }
        
        NSString *curr_room = [VALID_GDC_ROOMS[i] copy];
        
        room = [[Room alloc] init : [[Location alloc] initSeparated : GDC room : curr_room]
                             type : VALID_GDC_ROOMS_TYPES[i]
                         capacity : VALID_GDC_ROOMS_CAPACITIES[i]
                        has_power : VALID_GDC_ROOMS_POWERS[i]];
        
//        NSLog(@"%@", [room toString]);
        
        [out setObject : room forKey : curr_room];
    }
    
//    NSLog(@"%@", out);
    
    return out;
}

@end









