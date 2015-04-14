//
//  Utilities.m
//  UT Study Spots
//
//  Created by Fatass on 3/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "Utilities.h"

#import "Constants.h"
#import "DateTools.h"
#import "NSString+Tools.h"

@implementation Utilities

+ (bool) date_is_in_range : (NSDate *) what
                    start : (NSDate *) start
                      end : (NSDate *) end {
    
    if ([self is_null : what] || [self is_null : start] || [self is_null : end]) {
        // TODO - throw IAException
    }
    return (![what isEarlierThan : start] && ![what isLaterThan : end]);
}

+ (bool) date_is_during_spring : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSInteger year = date.year;
    NSDate *start = [self get_date : SPRING_START_MONTH
                               day : SPRING_START_DAY
                              year : year
                              hour : 0
                            minute : 0];
    
    NSDate *end = [self get_date : SPRING_END_MONTH
                             day : SPRING_END_DAY
                            year : year
                            hour : 0
                          minute : 0];
    
    bool result = [self date_is_in_range : date start : start end : end];
    return result;
}

+ (bool) date_is_during_spring_trimester : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSInteger year = date.year;
    NSDate *start = [self get_date : 1 day : 1 year : year hour : 0 minute : 0];
    NSDate *end = [self get_date : SUMMER_START_MONTH
                             day : SUMMER_START_DAY
                            year : year
                            hour : 0
                          minute : 0];
    
    bool result = [self date_is_in_range : date start : start end : end];
    return result;
}

+ (bool) date_is_during_summer : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSInteger year = date.year;
    NSDate *start = [self get_date : SUMMER_START_MONTH
                               day : SUMMER_START_DAY
                              year : year
                              hour : 0
                            minute : 0];
    
    NSDate *end = [self get_date : SUMMER_END_MONTH
                             day : SUMMER_START_DAY
                            year : year
                            hour : 0
                          minute : 0];
    
    bool result = [self date_is_in_range : date start : start end : end];
    return result;
}

+ (bool) date_is_during_fall : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSInteger year = date.year;
    NSDate *start = [self get_date : FALL_START_MONTH
                               day : FALL_START_DAY
                              year : year
                              hour : 0
                            minute : 0];
    
    NSDate *end = [self get_date : FALL_END_MONTH
                             day : FALL_END_DAY
                            year : year
                            hour : 0
                          minute : 0];
    
    bool result = [self date_is_in_range : date start : start end : end];
    return result;
}

+ (bool) date_is_during_fall_trimester : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSInteger year = date.year;
    NSDate *start = [self get_date : SUMMER_END_MONTH
                               day : SUMMER_END_DAY
                              year : year
                              hour : 0
                            minute : 0];
    
    NSDate *end = [self get_date : 12
                             day : 31
                            year : year
                            hour : 0
                          minute : 0];
    
    bool result = [self date_is_in_range : date start : start end : end];
    return result;
}

+ (bool) dates_are_equal : (NSDate *) date1 date2 : (NSDate *) date2 {
    if ([self is_null : date1] || [self is_null : date2]) {
        // TODO - throw IAException
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *date1_comps = [calendar components : UNIT_FLAGS fromDate : date1];
    NSDateComponents *date2_comps = [calendar components : UNIT_FLAGS fromDate : date2];
    
    if (date1_comps.year == date2_comps.year &&
        date1_comps.month == date2_comps.month &&
        date1_comps.day == date2_comps.day &&
        date1_comps.hour == date2_comps.hour &&
        date1_comps.minute == date2_comps.minute) {
        return true;
    }
    return false;
}

+ (NSString *) get_time : (NSDate *) date {
    return ([self get_time_with_format : date format : @"HH:mm"]);
}

+ (NSString *) get_time_with_format : (NSDate *) date format : (NSString *) format {
    if ([self is_null : date] || [self is_null : format]) {
        // TODO - throw IAException
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat : format];
    
    NSString *out = [formatter stringFromDate : date];
    
    return out;
}

+ (bool) valid_day_of_week : (int) day {
    if (day < MONDAY || day > SUNDAY) {
        return false;
    }
    return true;
}

+ (NSDate *) get_date_with_time : (NSInteger) time {
    if (time < MIN_TIME || time > MAX_TIME || time % 100 >= MINUTES_IN_HOUR ) {
        return nil;
    }
    
    NSDate *out = nil;
    
    NSUInteger hour, minute;
    
    NSString *temp = [NSString stringWithFormat : @"%ld", time];
    if (temp.length == 3) {
        hour = (NSUInteger) [[temp substring : 0 stop : 1] integerValue];
        minute = (NSUInteger) [[temp substring : 1 stop : 3] integerValue];
        out = [self get_date : hour minute : minute];
    }
    else if (temp.length == 4) {
        hour = (NSUInteger) [[temp substring : 0 stop : 2] integerValue];
        minute = (NSUInteger) [[temp substring : 2 stop : 4] integerValue];
        out = [self get_date : hour minute : minute];
    }
    
    return out;
}

// http://stackoverflow.com/questions/17659314/how-can-i-set-only-time-in-nsdate-variable
+ (NSDate *) get_date : (NSUInteger) hour minute : (NSUInteger) minute {
    if (hour > 23 || minute > 59) {
        return nil;
    }
    
    NSDate *old_date = [self get_date];
    
//    NSLog(@"hi %@", old_date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components : UNIT_FLAGS fromDate : old_date];
    
    components.hour = hour;
    components.minute = minute;
    components.second = 0;
    
//    NSLog(@"Sent in hour, minute: %lu/%lu", hour, minute);
//    NSLog(@"fffff %ld %ld", components.hour, components.minute);
    
    NSDate *out = [calendar dateFromComponents : components];

    return out;
}

+ (NSDateComponents *) get_date_components : (unsigned) unit_flags date : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components : unit_flags fromDate : date];
    
    return components;
}

+ (NSDateComponents *) get_date_components_with_calendar : (unsigned) unit_flags calendar : (NSCalendar *) calendar date : (NSDate *)  date {
    
    if ([self is_null : date]) {
        // TODO - throw iAException
    }
    
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    NSDateComponents *components = [calendar components : unit_flags fromDate : date];
    
    return components;
}

// assumes search duration will not exceed 1440 minutes (as limited by search)
+ (bool) times_overlap : (NSDate *) start1
                  end1 : (NSDate *) end1
                start2 : (NSDate *) start2
                  end2 : (NSDate *) end2 {
    
    if ([self is_null : start1] || [self is_null : end1] || [self is_null : start2] || [self is_null : end2] || ![self start_is_before_end : start1 end : end1] || ![self start_is_before_end : start2 end : end2]) {
        // TODO - throw IAException
    }
    
    NSDate *start1_copy, *end1_copy, *start2_copy, *end2_copy;
    NSUInteger end1_day, end2_day;
    
    start1_copy = [self get_date : 1 day : 1 year : 15 hour : start1.hour minute : start1.minute];
    if (start1.weekday == end1.weekday) {
        end1_day = 1;
    }
    else {
        end1_day = 2;
    }
    end1_copy = [self get_date : 1 day : end1_day year : 15 hour : end1.hour minute : end1.minute];
    
    start2_copy = [self get_date : 1 day : 1 year : 15 hour : start2.hour minute : start2.minute];
    if (start2.weekday == end2.weekday) {
        end2_day = 1;
    }
    else {
        end2_day = 2;
    }
    end1_copy = [self get_date : 1 day : end2_day year : 15 hour : end1.hour minute : end1.minute];
    
    return ([self dates_overlap : start1_copy end1 : end1_copy start2 : start2_copy end2 : end2_copy]);
}

+ (bool) dates_overlap : (NSDate *) start1
                  end1 : (NSDate *) end1
                start2 : (NSDate *) start2
                  end2 : (NSDate *) end2 {
    
    if ([self is_null : start1] || [self is_null : end1] || [self is_null : start2] || [self is_null : end2]) {
        // TODO - throw IAException
    }
    
    DTTimePeriod *first = [[DTTimePeriod alloc] initWithStartDate : start1 endDate : end1];
    DTTimePeriod *second = [[DTTimePeriod alloc] initWithStartDate : start2 endDate : end2];
    
    return ([first overlapsWith : second]);
}

+ (bool) dates_occur_on_same_day : (NSDate *) date1 date2 : (NSDate *) date2 {
    if ([self is_null : date1] || [self is_null : date2]) {
        // TODO - throw IAException
    }
    
    return (date1.weekday == date2.weekday);
}

+ (bool) is_leap_year : (int) year {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return true;
    }
    return false;
}

+ (NSDate *) get_date : (NSUInteger) month day : (NSUInteger) day year : (NSUInteger) year hour : (NSUInteger) hour minute : (NSUInteger) minute {
    if (month < 1 || month > 12) {
        return nil;
    }
//    else if (year < MIN_YEAR || year > MAX_YEAR) {
//        return nil;
//    }
    
    else if (hour > 23 || minute > 59) {
        return nil;
    }
    else if (month == 2 && ![self is_leap_year : (int) year] && day == 29) {
        return nil;
    }
    
    NSString *year_str = [[NSString alloc] initWithFormat : @"%lu", year];
    if (year_str.length == 4 && (year < MIN_YEAR || year > MAX_YEAR)) {
        return nil;
    }
    else if (year_str.length == 2) {
        if (year < MIN_YEAR_2 || year > MAX_YEAR_2) {
            return nil;
        }
        else {
            year_str = [[NSString alloc] initWithFormat : @"20%lu", year];
            year = (NSUInteger) [year_str integerValue];
        }
    }
    else if (year_str.length != 2 && year_str.length != 4) {
        return nil;
    }
    
    NSDate *out = [NSDate dateWithYear : (NSInteger) year month : (NSInteger) month day : (NSInteger) day hour : (NSInteger) hour minute : (NSInteger) minute second : 0];

    return out;
}

// https://buildingmyworld.wordpress.com/2011/04/13/get-local-time-from-iphone-local-nsdate/
+ (NSDate *) get_date {
    NSDate *out = [NSDate date];
    
    return out;
}

+ (bool) is_null : (NSObject *) obj {
    if (!obj || [obj isEqual : [NSNull class]]) {
        return true;
    }
    return false;
}

/*
 NSBundle *main_bundle = [NSBundle mainBundle];
 NSString *file_path = [main_bundle pathForResource : @"calendar_events_feed_0412" ofType : @"csv"];
 //    NSString *test_csv = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : NSUTF8StringEncoding error : nil];
 
 NSString *test_csv_read = [NSString stringWithContentsOfFile : file_path encoding : NSUTF8StringEncoding error : nil];
 NSArray *test_csv_read_arr = [test_csv_read componentsSeparatedByString : @"\n"];
 NSLog(@"Test read CSV feed:\n%@", test_csv_read_arr);
 */
+ (NSString *) get_file_path : (NSString *) filename ext : (NSString *) ext {
    NSBundle *main_bundle = [NSBundle mainBundle];
    NSString *file_path = [main_bundle pathForResource : filename ofType : ext];
    
    return file_path;
}

// consider making DAYBREAK and NIGHTFALL DTTTimePeriods
+ (bool) search_is_at_night : (NSDate *) start end : (NSDate *) end {
    if ([self is_null : start] || [self is_null : end] || ![self start_is_before_end : start end : end]) {
        // TODO - throw IAException
    }
    
    int start_time = [[self get_time_with_format : start format : @"HHmm"] intValue];
    int end_time = [[self get_time_with_format : end format : @"HHmm"] intValue];
    
    if (start_time >= LAST_TIME_OF_DAY && start_time <= MAX_TIME) {
        return true;
    }
    else if (start_time >= MIN_TIME && start_time < LAST_TIME_OF_NIGHT) {
        return true;
    }
    else if (end_time > LAST_TIME_OF_DAY && end_time <= MAX_TIME) {
        return true;
    }
    else if (end_time >= MIN_TIME && end_time < LAST_TIME_OF_NIGHT) {
        return true;
    }
    
    return false;
}

+ (bool) start_is_before_end : (NSDate *) start end : (NSDate *) end {
    if ([self is_null : start] || [self is_null : end]) {
        // TODO - throw IAException
    }
    
    double seconds_from_start = [end secondsFrom : start];
    
    if (seconds_from_start < 0) {
        return false;
    }
    return true;
}

// isWeekend property - see NSDate+DateTools.h
+ (bool) date_is_during_weekend : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSInteger weekday = date.weekday;
    if (weekday == SATURDAY || weekday == SUNDAY) {
        return true;
    }
    return false;
}

+ (NSString *) get_current_course_schedule : (NSDate *) date {
    if ([self is_null : date]) {
        // TODO - throw IAException
    }
    
    NSString *out = nil;
    
    NSDate *now = [self get_date];
    
    if ([self date_is_during_spring_trimester : date]) {
        if ([self date_is_during_spring_trimester : now]) {
            out = COURSE_SCHEDULE_THIS_SEMESTER;
        }
        else if ([self date_is_during_summer : now]) {
            if (!COURSE_SCHEDULE_NEXT_SEMESTER) {
                // TODO - throw ISException
            }
            else {
                out = COURSE_SCHEDULE_NEXT_SEMESTER;
            }
        }
        else if ([self date_is_during_fall_trimester : now]) {
            if (!COURSE_SCHEDULE_NEXT_SEMESTER) {
                // TODO - throw ISException
            }
            else {
                out = COURSE_SCHEDULE_NEXT_SEMESTER;
            }
            
        }
        else {
            out = SEARCH_STATUS_STRINGS[HOLIDAY];
        }
    }
    
    else if ([self date_is_during_summer : date]) {
        out = SEARCH_STATUS_STRINGS[HOLIDAY];
    }
    
    else if ([self date_is_during_fall_trimester : date]) {
        if ([self date_is_during_spring_trimester : now]) {
            if (!COURSE_SCHEDULE_NEXT_SEMESTER) {
                // TODO - throw ISException
            }
            else {
                out = COURSE_SCHEDULE_NEXT_SEMESTER;
            }
        }
        else if ([self date_is_during_summer : now]) {
            out = COURSE_SCHEDULE_THIS_SEMESTER;
        }
        else if ([self date_is_during_fall_trimester : now]) {
            out = COURSE_SCHEDULE_THIS_SEMESTER;
        }
        else {
            out = SEARCH_STATUS_STRINGS[HOLIDAY];
        }
    }
    
    else {
        out = SEARCH_STATUS_STRINGS[HOLIDAY];
    }
    
    return out;
}

@end










