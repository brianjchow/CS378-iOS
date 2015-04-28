//
//  Query.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "Query.h"

#import "Utilities.h"

#import "NSString+Tools.h"

/*
 
 TODO
    - fix get_this_day_of_week() (number format)
    - if doing random room search and building is NOT GDC, remember to set
        power option to false (see set_option_search_building())
 
 */

@interface Query ()

@property (strong, nonatomic, readwrite) DTTimePeriod *date;
@property (nonatomic, readwrite) int duration;
@property (strong, nonatomic, readwrite) NSString *search_building;

- (NSString *) get_current_course_schedule : (SearchStatus *) search_status;
- (int) get_this_day_of_week;
- (void) set_end_date;

@end

@implementation Query

- (instancetype) init {
    return ([self initWithStartDate : [Utilities get_date]]);
}

- (instancetype) initWithStartDate : (NSDate *) start_date {
    if ([Utilities is_null : start_date]) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        self.duration = DEFAULT_QUERY_DURATION;
        self.date = [DTTimePeriod timePeriodWithSize : DTTimePeriodSizeMinute amount : (NSUInteger) self.duration startingAt : start_date];
        
        self.search_building = GDC;
    }
    
    return self;
}

- (QueryResult *) search {
    return nil;
}

- (int) get_duration {
    return self.duration;
}

- (int) get_option_capacity {
    return 0;
}

- (bool) get_option_power {
    return false;
}

- (NSDate *) get_end_date {
    return self.date.EndDate;
}

- (NSString *) get_option_search_building {
    return self.search_building;
}

- (NSString *) get_option_search_room {
    return nil;
}

- (NSDate *) get_start_date {
    return self.date.StartDate;
}

- (NSString *) get_current_course_schedule : (SearchStatus *) search_status {
    
    NSString *out = nil;
    
    NSDate *start_date = self.date.StartDate;
    NSDate *now = [Utilities get_date];
    
    if ([Utilities date_is_during_spring_trimester : start_date]) {
        if ([Utilities date_is_during_spring : start_date]) {
            if ([Utilities date_is_during_spring_trimester : now]) {
                if ([Utilities date_is_during_spring : now]) {
                    out = COURSE_SCHEDULE_THIS_SEMESTER;
                }
                else {
                    *search_status = HOLIDAY;
                }
            }
            else if ([Utilities date_is_during_summer : now]) {
                if (!COURSE_SCHEDULE_NEXT_SEMESTER) {
                    *search_status = NO_INFO_AVAIL;
                }
                else {
                    out = COURSE_SCHEDULE_NEXT_SEMESTER;
                }
            }
            else if ([Utilities date_is_during_fall_trimester : now]) {
                if (!COURSE_SCHEDULE_NEXT_SEMESTER) {
                    *search_status = NO_INFO_AVAIL;
                }
                else {
                    out = COURSE_SCHEDULE_NEXT_SEMESTER;
                }
            }
            else {
                *search_status = HOLIDAY;
            }
        }
        else {
            *search_status = HOLIDAY;
        }
    }
    
    else if ([Utilities date_is_during_summer : start_date]) {
        *search_status = SUMMER;
    }
    
    else if ([Utilities date_is_during_fall_trimester : start_date]) {
        if ([Utilities date_is_during_fall : start_date]) {
            if ([Utilities date_is_during_spring_trimester : now]) {
                if (!COURSE_SCHEDULE_NEXT_SEMESTER) {
                    *search_status = NO_INFO_AVAIL;
                }
                else {
                    out = COURSE_SCHEDULE_NEXT_SEMESTER;
                }
            }
            else if ([Utilities date_is_during_summer : now]) {
                out = COURSE_SCHEDULE_THIS_SEMESTER;
            }
            else if ([Utilities date_is_during_fall_trimester : now]) {
                if ([Utilities date_is_during_fall : now]) {
                    out = COURSE_SCHEDULE_THIS_SEMESTER;
                }
                else {
                    *search_status = HOLIDAY;
                }
            }
            else {
                *search_status = HOLIDAY;
            }
        }
        else {
            *search_status = HOLIDAY;
        }
    }
    
    else {
        *search_status = HOLIDAY;
    }
        
    return out;
}

// PRIVATE METHOD
// http://stackoverflow.com/questions/9874503/how-do-i-get-the-day-of-the-week-using-nsdate-and-show-using-nslog-in-ios
- (int) get_this_day_of_week {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components : UNIT_FLAGS fromDate : self.date.StartDate];
//    
//    int today = (int) [components weekday];
//    
//    return today;
    
    return ((int) self.date.StartDate.weekday - 1);
}

- (bool) set_duration : (int) duration {
    if (duration <= 0) {
        return false;
    }
    
    self.duration = duration;
    [self set_end_date];
    
    return true;
}

// PRIVATE METHOD
- (void) set_end_date {
//    NSDate *copy = [Utilities get_date_clone : self.date.StartDate];
//    
//    copy = [copy dateByAddingMinutes : self.duration];
//    return true;
    
    self.date.EndDate = [self.date.StartDate dateByAddingMinutes : self.duration];
}

- (bool) set_option_search_building : (NSString *) building_code {
//    if ([Utilities is_null : building_code]) {
//        // TODO - throw IAException
//    }
//    else if (building_code.length != BUILDING_CODE_LENGTH) {
//        // TODO - throw IAException
//    }
    
    if (![building_code is_campus_building]) {
        // TODO - throw IAException
    }
    
    building_code = [building_code substring : 0 stop : 3];
    building_code = [building_code uppercaseString];
    self.search_building = building_code;

    return true;
}

- (bool) set_start_date : (NSDate *) start_date {
    if ([Utilities is_null : start_date]) {
        // TODO - throw IAException
    }
    
//    NSLog(@"In Query, setting start date: %@", [start_date toString]);
    
//    NSInteger month = start_date.month;
//    NSInteger day = start_date.day;
//    NSInteger year = start_date.year;
//    NSLog(@"month: %ld\tday: %ld\tyear: %ld", month, day, year);
    
    NSDate *temp = self.date.StartDate;
    NSInteger orig_hour = [[Utilities get_time_with_format : temp format : @"HH"] integerValue];
    NSInteger orig_min = [[Utilities get_time_with_format : temp format : @"mm"] integerValue];
    
    self.date.StartDate = start_date;
    [self set_start_time : (NSUInteger) orig_hour minute : (NSUInteger) orig_min];

    
//    start_date = [Utilities set_to_current_time_zone : start_date];
//    self.date.StartDate = start_date;
    [self set_end_date];
    
//    NSLog(@"Exiting Query, setting start date finished: %@", [self.date.StartDate toString]);
    
    return true;
}

- (bool) set_start_date_by_calendar : (NSUInteger) month day : (NSUInteger) day year : (NSUInteger) year {
    
    if (month < 1 || month > 12) {
        return false;
    }
    else if (year < MIN_YEAR || year > MAX_YEAR) {
        return false;
    }
    
    int days_in_this_month = DAYS_IN_MONTH[month - 1];
    if (month == 2 && [Utilities is_leap_year : (int) year]) {
        days_in_this_month++;
    }
    
    if (day < 1 || day > days_in_this_month) {
        return false;
    }
    
    int start_hour = [[Utilities get_time_with_format : self.date.StartDate format : @"HH"] intValue];
    int start_minute = [[Utilities get_time_with_format : self.date.StartDate format : @"mm"] intValue];
    
    self.date.StartDate = [Utilities get_date : month day : day year : year hour : (unsigned) start_hour minute : (unsigned) start_minute];
//    self.date.StartDate = [Utilities set_to_current_time_zone : self.date.StartDate];
    [self set_end_date];
    
    return true;
}

- (bool) set_start_time : (NSUInteger) hour minute : (NSUInteger) minute {
    if (hour > 23 || minute > 59) {
        return false;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components : UNIT_FLAGS fromDate : self.date.StartDate];
    
    int month = (int) components.month;
    int day = (int) components.day;
    int year = (int) components.year;       // CHECK FORMAT OF THIS !!!!!!!!!!!!!!!!
    
    self.date.StartDate = [Utilities get_date : month day : day year : year hour : hour minute : minute];
//    self.date.startDate = [Utilities set_to_current_time_zone : self.date.StartDate];
    [self set_end_date];
    
    return true;
}

- (id) copy {
    Query *copy = [[Query alloc] init];
    
    if (copy) {
        copy.date = [self.date copy];
        [copy set_duration : self.duration];
        copy.search_building = [NSString stringWithString : self.search_building];
    }

    return copy;
}

- (id) copyWithZone : (NSZone *) zone {
    Query *copy = [[[self class] allocWithZone : zone] init];
    
    if (copy) {
        copy.date = [self.date copy];   // ? !!!!!!!!!!!!!!!!!!!!!!
        [copy set_duration : self.duration];
        copy.search_building = [self.search_building copyWithZone : zone];
    }
    
    return copy;
}

- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [Query class]]) {
        return NO;
    }
    
    Query *other_query = (Query *) other;
    if ([Utilities dates_are_equal : self.date.StartDate date2 : other_query.date.StartDate] &&
        [Utilities dates_are_equal : self.date.EndDate date2 : other_query.date.EndDate] &&
        self.duration == other_query.duration &&
        [self.search_building isEqualToString : other_query.search_building]) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger) hash {
    return (37 * [[Utilities get_time_with_format : self.date.StartDate format : @"HHmm"] intValue] *
            [[Utilities get_time_with_format : self.date.EndDate format : @"HHmm"] intValue] * 17);
}

- (NSString *) toString {
    NSMutableString *out = [[NSMutableString alloc] initWithCapacity : 100];
    
    NSString *minutes = @"minutes";
    if (self.duration == 1) {
        minutes = @"minute";
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat : @"MMM dd yyyy HH:mm"];
    
    [out appendFormat : @"Start date:\t%@\n", [formatter stringFromDate : self.date.StartDate]];
    [out appendFormat : @"End date:\t%@\n", [formatter stringFromDate : self.date.EndDate]];
    [out appendFormat : @"Duration:\t%d minutes\n", self.duration];
    [out appendFormat : @"Building:\t%@", self.search_building];
    
    return out;
}

- (NSString *) description {
    return [self toString];
}

@end
