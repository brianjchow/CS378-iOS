//
//  Building.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "Building.h"

#import "BuildingList.h"
#import "CourseScheduleDatabaseManager.h"
#import "Utilities.h"

#import "NSString+Tools.h"

@interface Building ()

- (instancetype) init : (NSString *) name;
+ (NSDictionary *) populate : (NSString *) building_code db_filename : (NSString *) db_filename;

@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, retain) NSDictionary *rooms;  // NSDictionary<String, Room>

@end

@implementation Building

- (bool) contains_room : (NSString *) room_num {
    if ([Utilities is_null : room_num]) {
        // TODO - throw IAException
    }
    
    return ([self.rooms objectForKey : room_num] != nil);
}

+ (Building *) get_instance : (NSString *) building_code db_filename : (NSString *) db_filename {
    if ([Utilities is_null : building_code] || ![building_code is_campus_building] ||
        [Utilities is_null : db_filename] || db_filename.length <= 0) {
        // TODO - throw IAException
    }
    
    building_code = [building_code uppercaseString];
    
    int file_ext_dot_index = [db_filename last_index_of : '.'];
    if (file_ext_dot_index == -1) {
        db_filename = [NSString stringWithFormat : @"%@.%@", db_filename, DEFAULT_DB_EXT];
    }
    
    Building *out;
    
    if (COURSE_SCHEDULE_NEXT_SEMESTER &&
        [COURSE_SCHEDULE_NEXT_SEMESTER containsIgnoreCase : db_filename]) {
        
        BuildingList *blns = [Constants get_building_cachelist_next_semester];
        
        if ((out = [blns get_building : building_code])) {
            return out;
        }
        
        out = [[Building alloc] init : building_code];
        out.rooms = [self populate : building_code db_filename : db_filename];
        
        if (blns) {
            [blns put_building : building_code building : out];
        }
    }
    else {
        
        BuildingList *blts = [Constants get_building_cachelist_this_semester];
        
        if ((out = [blts get_building : building_code])) {
            return out;
        }
        
        out = [[Building alloc] init : building_code];
        out.rooms = [self populate : building_code db_filename : db_filename];
        
        if (blts) {
            [blts put_building : building_code building : out];
        }
        
    }
    
    return out;
}

// NSOrderedSet of Strings
- (NSOrderedSet *) get_keyset {
    NSArray *keyset = [self.rooms allKeys];
    keyset = [keyset sortedArrayUsingSelector : @selector(localizedCaseInsensitiveCompare : )];
    
    NSOrderedSet *out = [[NSOrderedSet alloc] initWithArray : keyset];
    
//    NSLog(@"%@", out);
    
    return out;
}

- (NSString *) get_name {
    return self.name;
}

- (int) get_num_rooms {
    return ((int) [self.rooms count]);
}

- (Room *) get_random_room {
    NSOrderedSet *all_rooms = [self get_keyset];
    int random_index = arc4random_uniform((unsigned int) [all_rooms count]);
    
    return ([self get_room : [all_rooms objectAtIndex : (NSUInteger) random_index]]);
}

- (Room *) get_room : (NSString *) room_num {
    return ([self.rooms objectForKey : room_num]);
}

// overridden
- (id) copy {
//    Building *copy = [[Building alloc] init : [self.name copy]];
//    copy.rooms = [[NSMutableDictionary alloc] initWithCapacity : [self.rooms count]];
//    
//    NSString *curr_room_str;
//    Room *curr_room;
//    for (curr_room_str in [self.rooms allKeys]) {
//        curr_room = [self.rooms objectForKey : curr_room_str];
//        [copy.rooms setValue : [curr_room copy] forKey : [curr_room_str copy]];
//    }
//    
//    return copy;
    
    return self;
}

- (id) copyWithZone : (NSZone *) zone {
//    Building *copy = [[[self class] allocWithZone : zone] init : [self.name copy]];
//    copy.rooms = [[NSMutableDictionary alloc] initWithCapacity : [self.rooms count]];
//    
//    NSString *curr_room_str;
//    Room *curr_room;
//    for (curr_room_str in [self.rooms allKeys]) {
//        curr_room = [self.rooms objectForKey : curr_room_str];
//        [copy.rooms setValue : [curr_room copyWithZone : zone] forKey : [curr_room_str copyWithZone : zone]];
//    }
//    
//    return copy;
    
    return self;
}

- (NSComparisonResult) compare : (Building *) otherObject {
    return ([self.name compare : otherObject.name]);
}

// overridden
- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [Building class]]) {
        return NO;
    }
    
    Building *other_building = (Building *) other;
    if (![self.name isEqualToString : other_building.name] ||
        [self.rooms count] != [other_building.rooms count]) {
        return false;
    }
    
//    NSString *curr_room_num;
    Room *curr_room, *other_room;
    NSOrderedSet *other_keyset = [other_building get_keyset];
    for (NSString *curr_room_num in other_keyset) {
        curr_room = [other_building.rooms objectForKey : curr_room_num];
        
        if (!(other_room = [self.rooms objectForKey : curr_room_num])) {
            return false;
        }
        else {
            if (![other_room isEqual : curr_room]) {
                return false;
            }
        }
    }
    
    return true;
}

// overridden
- (NSUInteger) hash {
    return (37 * [self.name hash]);
}

- (NSString *) toString {
    NSMutableString *out = [[NSMutableString alloc] initWithCapacity : 500];
    
    NSArray *values_arr = [self.rooms allValues];
//    NSArray *values_arr = [self get_values];
    values_arr = [values_arr sortedArrayUsingSelector : @selector(compare : )];
    
//    NSOrderedSet *values = [[NSOrderedSet alloc] initWithArray : values_arr];
    for (Room *room in values_arr) {
        [out appendFormat : @"%@\n", [room toString]];
    }
    
    return out;
}

- (NSString *) description {
    return [self toString];
}

/* ************************************ PRIVATE METHODS ************************************ */

- (instancetype) init : (NSString *) name {
    if (![name is_campus_building]) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        self.name = [name uppercaseString];
        self.rooms = [NSDictionary new];
    }
    
    return self;
}

+ (NSDictionary *) populate : (NSString *) building_code db_filename : (NSString *) db_filename {
    if ([Utilities is_null : db_filename] || db_filename.length <= 0) {
        // TODO - throw IAException
    }
    
    NSDictionary *out = [CourseScheduleDatabaseManager get_courses : building_code db_filename : db_filename];
    
//    NSLog(@"\n\n\n%@\n\n\n", out);
    
    return out;
    
//    return [CourseScheduleDatabaseManager get_courses : building_code db_filename : db_filename];
}

- (NSArray *) get_values {
    NSMutableArray *out = [[NSMutableArray alloc] initWithCapacity : [self.rooms count]];
    
    NSString *room_num;
    for (room_num in self.rooms) {
        [out addObject : [self.rooms objectForKey : room_num]];
        
//        NSLog(@"%@", [[self.rooms objectForKey : room_num] toString]);
    }
    
    return out;
}


@end
