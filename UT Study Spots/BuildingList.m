//
//  BuildingList.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "BuildingList.h"

#import "Utilities.h"

/*
 TODO
 
    - need to call some sort() method after adding to the backing Dictionary
        - or not? isEqual() is order-agnostic
 */

@interface BuildingList ()

@property (strong, nonatomic) NSMutableDictionary *buildings;  // NSMutableDictionary<String, Building> / TreeMap<String, Building>

@end

@implementation BuildingList

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.buildings = [NSMutableDictionary new];
    }
    
    return self;
}

- (bool) contains_building : (NSString *) name {
    if ([Utilities is_null : [self get_building : name]]) {
        return false;
    }
    return true;
}

- (Building *) get_building : (NSString *) name {
    if ([Utilities is_null : name] || name.length <= 0) {
        // TODO - throw IAException
    }
    
    name = [name uppercaseString];
    return ([self.buildings objectForKey : name]);
}

- (NSEnumerator *) get_enumerator {
    return ([self.buildings objectEnumerator]); // ? !!!!!!!!!!!!!!!!!!!!!!!!!!!
}

- (int) get_size {
    return ((int) [self.buildings count]);
}

- (bool) put_building : (NSString *) name building : (Building *) building {
    if ([Utilities is_null : name] || name.length <= 0 || [Utilities is_null : building]) {
        // TODO - throw IAException
    }
    
    [self.buildings setObject : building forKey : name];
    return true;
}

- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [Room class]]) {
        return NO;
    }
    
    BuildingList *other_list = (BuildingList *) other;
    
    if ([self get_size] != [other_list get_size]) {
        return NO;
    }
    
    Building *curr_bldg, *other_bldg;
    NSArray *other_keyset = [other_list.buildings allKeys];
    for (NSString *name in other_keyset) {
        curr_bldg = [other_list.buildings objectForKey : name];
        
        if ([Utilities is_null : (other_bldg = [self.buildings objectForKey : name])]) {
            return NO;
        }
        
        if (![other_bldg isEqual : curr_bldg]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSString *) toString {
    NSMutableString *out = [[NSMutableString alloc] initWithCapacity : 1000];
    
    NSArray *values = [self.buildings allValues];
    for (Building *building in values) {
        [out appendFormat : @"%@\n", [building toString]];
    }
    
    return out;
}


@end

