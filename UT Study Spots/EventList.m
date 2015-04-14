//
//  EventList.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "EventList.h"

#import "Utilities.h"

@interface EventList ()

@property (strong, nonatomic, readwrite) NSMutableArray *list;     // of Events

@end

@implementation EventList

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.list = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype) initWithSize : (NSUInteger) size {
    self = [super init];
    
    if (self) {
        self.list = [[NSMutableArray alloc] initWithCapacity : size];
    }
    
    return self;
}

// arg: NSArray<NSDictionary<NSString, NSString>
- (instancetype) initWithHashMapList : (NSArray *) strings {
    if ([Utilities is_null : strings]) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        self.list = [[NSMutableArray alloc] initWithCapacity : [strings count]];
        
        if (![self add_hashmap_list : strings]) {
            // TODO - throw ISException
        }
    }
    
    return self;
}

- (bool) add_event : (Event *) eo {
    if ([Utilities is_null : eo]) {
        return false;
    }
    
    [self.list addObject : eo];
    return true;
}

// arg: NSArray<NSDictionary<NSString, NSString>
- (bool) add_hashmap_list : (NSArray *) strings {
    if ([Utilities is_null : strings]) {
        // TODO - throw IAException
    }
    
    NSDictionary *curr_event;
    NSString *event_name, *start_date, *end_date, *location;
    Event *event_to_add;
    for (int i = 0; i < [strings count]; i++) {
        curr_event = strings[i];
        
        // don't add if already present
        event_name = [curr_event objectForKey : EVENT_NAME];
        start_date = [curr_event objectForKey : START_DATE];
        if ([Utilities is_null : event_name] || [Utilities is_null : start_date]) {
            continue;
        }
        
        // verify that start date has the correct format
        NSDate *verify_start_date = [Event to_date : start_date];
        if ([Utilities is_null : verify_start_date]) {
            return false;   // TODO - return false, or continue?
        }
        
        // set dummy location if not specified in feed
        location = [curr_event objectForKey : LOCATION];
        if ([Utilities is_null : location]) {
            location = [NSString stringWithFormat : @"%@ %@", GDC, DEFAULT_GDC_LOCATION];
        }
        
        // set default duration of Event as 90 minutes if none specified
        end_date = [curr_event objectForKey : END_DATE];
        if ([Utilities is_null : end_date]) {
            event_to_add = [[Event alloc] initWithStrings : event_name start_date : start_date end_date : nil location : location];
            [self.list addObject : event_to_add];
        }
        else {
            NSDate *verify_end_date = [Event to_date : end_date];
            if ([Utilities is_null : verify_end_date]) {
                return false;
            }
            
            event_to_add = [[Event alloc] initWithStrings : event_name start_date : start_date end_date : end_date location : location];
            [self.list addObject : event_to_add];
        }
    }
    
    return true;
}

- (NSEnumerator *) get_enumerator {
    return ([self.list objectEnumerator]);
}

- (Event *) get_event : (unsigned int) index {
    if (index >= [self.list count]) {
        // TODO - throw IAException
    }
    
    return [self.list objectAtIndex : index];
}

// protected Iterator<Event> get_iterator();

- (NSUInteger) get_size {
    return [self.list count];
}

- (id) copy {
    EventList *out = [[EventList alloc] initWithSize : [self.list count]];
    
    if (out) {
        for (Event *event in self.list) {
            [out add_event : [event copy]];
        }
    }
    
    return out;
}

- (id) copyWithZone : (NSZone *) zone {
    EventList *out = [[[self class] allocWithZone : zone] init];
    
    if (out) {
        for (Event *event in self.list) {
            [out add_event : [event copyWithZone : zone]];
        }
    }
    
    return out;
}

//- (NSComparisonResult) compare : (Event *) otherObject {
//
//    return NSOrderedSame;
//}

- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [EventList class]]) {
        return NO;
    }
    
    EventList *other_eo = (EventList *) other;
    NSUInteger this_size = [self.list count];
    if (this_size != [other_eo get_size]) {
        return NO;
    }
    
    for (int i = 0; i < this_size; i++) {
        if (![[self.list objectAtIndex : i] isEqual : [other_eo.list objectAtIndex : i]]) {
            return NO;
        }
    }

    return YES;
}

- (NSString *) toString {
    if ([Utilities is_null : self.list]) {
        // TODO - throw ISException
    }
    
    if ([self.list count] == 0) {
        return @"";
    }
    
    NSMutableString *out = [NSMutableString new];
    
    int i = 0;
    Event *event;
    NSString *temp;
    for (; i < [self.list count] - 1; i++) {
        event = [self.list objectAtIndex : i];
        temp = [NSString stringWithFormat : @"%@\n\n", [event toString]];
        [out appendString : temp];
    }
    
    event = [self.list objectAtIndex : i];
    temp = [NSString stringWithFormat : @"%@\n", [event toString]];
    [out appendString : temp];
    
    return out;
}

- (NSString *) description {
    return [self toString];
}


@end
