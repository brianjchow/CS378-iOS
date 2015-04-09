//
//  Event.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "Event.h"

#import "Utilities.h"
#import "DateTools.h"
#import "NSString+Tools.h"

@interface Event ()

@property (strong, nonatomic, readwrite) NSString *event_name;
@property (strong, nonatomic) DTTimePeriod *date;
@property (strong, nonatomic, readwrite) Location *location;

@end

@implementation Event

// http://stackoverflow.com/questions/5027902/how-can-i-add-one-minutes-in-current-nsdate-of-iphone-and-save-in-nsdate
- (instancetype) initWithStrings : (NSString *) event_name start_date : (NSString *) start_date end_date : (NSString *) end_date location : (NSString *) location {
    
    if ([Utilities is_null : event_name] || [Utilities is_null : start_date] || [Utilities is_null : location]) {
        // TODO - throw exception
    }
    
    self = [super init];
    
    if (self) {
        self.event_name = event_name;
        self.date = [[DTTimePeriod alloc] init];
        self.location = [[Location alloc] initFullyQualified : location];
        
        NSDate *date_start_date = [Event to_date : start_date];
        if ([Utilities is_null : date_start_date]) {
            date_start_date = [Utilities get_date];
        }
        
        self.date.StartDate = date_start_date;
        
        if ([Utilities is_null : end_date]) {
            self.date.EndDate = date_start_date;
            self.date.EndDate = [self.date.EndDate dateByAddingTimeInterval : (DEFAULT_EVENT_DURATION * 60)];
        }
        else {
            NSDate *date_end_date = [Event to_date : end_date];
            if ([Utilities is_null : date_end_date]) {
                date_end_date = date_start_date;
                date_end_date = [date_end_date dateByAddingTimeInterval : (DEFAULT_EVENT_DURATION * 60)];
            }
            
            self.date.EndDate = date_end_date;
        }
    }
    
    return self;
}

- (instancetype) initWithDatesNoLocation : (NSString *) event_name start_date : (NSDate *) start_date end_date : (NSDate *) end_date location : (NSString *) location {
    
    return ([self initWithDatesAndLocation : event_name start_date : start_date end_date : end_date location : [[Location alloc] initFullyQualified : location]]);
}

- (instancetype) initWithDatesAndLocation : (NSString *) event_name start_date : (NSDate *) start_date end_date : (NSDate *) end_date location : (Location *) location {
    
    if ([Utilities is_null : event_name] || [Utilities is_null : start_date] || [Utilities is_null : location]) {
        // TODO - throw exception
    }
    
    self = [super init];
    
    if (self) {
        
        self.event_name = event_name;
        self.date = [[DTTimePeriod alloc] init];
        self.location = location;
        
        self.date.StartDate = start_date;
        
        if ([Utilities is_null : end_date]) {
            NSDate *date_end_date = start_date;
            date_end_date = [date_end_date dateByAddingTimeInterval : (DEFAULT_EVENT_DURATION * 60)];
            self.date.EndDate = date_end_date;
        }
        else {
            self.date.EndDate = end_date;
        }
    }
    
    return self;
}

- (NSDate *) get_end_date {
    return (self.date.EndDate);
}

// http://stackoverflow.com/questions/576265/convert-nsdate-to-nsstring
- (NSString *) get_event_date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat : US_DATE_NO_TIME_FORMAT];
    
    NSString *out = [formatter stringFromDate : self.date.StartDate];
    
    return out;
}

- (NSString *) get_event_name {
    return (self.event_name);
}

- (Location *) get_location {
    return (self.location);
}

- (NSDate *) get_start_date {
    return (self.date.StartDate);
}

- (void) set_start_date : (NSDate *) date {
    if ([Utilities is_null : date]) {
        // TODO - throw IAException
    }
    
    self.date.StartDate = date;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *start_date_components = [Utilities get_date_components : UNIT_FLAGS date : date];
    NSDateComponents *end_date_components = [Utilities get_date_components : UNIT_FLAGS date : self.date.EndDate];
    
    end_date_components.month = start_date_components.month;
    end_date_components.day = start_date_components.day;
    end_date_components.year = start_date_components.year;
    
    self.date.EndDate = [calendar dateFromComponents : end_date_components];
}

// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW1
+ (NSDate *) to_date : (NSString *) date_time {
    if ([Utilities is_null : date_time]) {
        // TODO - throw IAException
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat : UTCS_CSV_FEED_FORMAT];
    
    NSDate *out = [formatter dateFromString : date_time];
    
    if (!out) {
        NSLog(@"SON OF A BITCH");
    }

    return out;
}

- (id) copy {
    DTTimePeriod *date_copy = [self.date copy];
    Event *out = [[Event alloc] initWithDatesAndLocation : self.event_name
                                              start_date : date_copy.StartDate
                                                end_date : date_copy.EndDate
                                                location : [self.location copy]];
    
    return out;
}

- (id) copyWithZone : (NSZone *) zone {
    Event *out = [[[self class] allocWithZone : zone] init];
    
    if (out) {
        out.event_name = [self.event_name copyWithZone : zone];
        out.date.StartDate = [self.date.StartDate copyWithZone : zone];
        out.date.EndDate = [self.date.EndDate copyWithZone : zone];
        out.location = [self.location copyWithZone : zone];
    }
    
    return out;
}

/* This SHOULD emulate the behaviour of Google's Guava's ComparisonChain.
    https://code.google.com/p/guava-libraries/source/browse/guava/src/com/google/common/collect/ComparisonChain.java?r=806967c3660d231e62a52674703acb51ec4e6623
 */
- (NSComparisonResult) compare : (Event *) otherObject {
    
    if ([self.date.StartDate isEarlierThan : otherObject.date.StartDate]) {
        return NSOrderedAscending;
    }
    else if ([self.date.StartDate isLaterThan : otherObject.date.EndDate]) {
        return NSOrderedDescending;
    }
    
    int compare = [self.event_name compare : otherObject.event_name];
    if (compare != 0) {
        return compare;
    }
    
    compare = [self.location compare : otherObject.location];
    if (compare != 0) {
        return compare;
    }
    
    if ([self.date.EndDate isEarlierThan : otherObject.date.EndDate]) {
        return NSOrderedAscending;
    }
    else if ([self.date.EndDate isLaterThan : otherObject.date.EndDate]) {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [Event class]]) {
        return NO;
    }
    
    Event *other_event = (Event *) other;
    if ([self.event_name isEqualToString : other_event.event_name] &&
        [Utilities dates_are_equal : self.date.StartDate date2 : other_event.date.StartDate] &&
        [Utilities dates_are_equal : self.date.EndDate date2 : other_event.date.EndDate] &&
        [[self get_location] isEqual : [other_event get_location]]) {
        return YES;
    }
    
    return NO;
}

// http://stackoverflow.com/questions/576265/convert-nsdate-to-nsstring
- (NSUInteger) hash {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat : @"HHmm"];
    
    NSString *temp = [formatter stringFromDate : self.date.StartDate];
    int start_time = [temp intValue];
    
    return ([self.event_name hash] * start_time * [self.location hash]);
}

- (NSString *) toString {
    NSString *out = [NSString stringWithFormat : @"%@\n%@\n%@", self.event_name, [self.date toString], [self.location toString]];
    
    return out;
}

- (NSString *) description {
    return [self toString];
}

@end
