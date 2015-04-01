//
//  Utilities.h
//  UT Study Spots
//
//  Created by Fatass on 3/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utilities : NSObject

// protected static String getRotation(Context context);

+ (bool) is_null : (NSObject *) obj;
+ (bool) valid_day_of_week : (int) day_of_week;
+ (bool) search_is_at_night : (NSDate *) start end : (NSDate *) end;
+ (bool) start_is_before_end : (NSDate *) start end : (NSDate *) end;
+ (bool) date_is_during_weekend : (NSDate *) date;
+ (bool) date_is_in_range : (NSDate *) what
                    start : (NSDate *) start
                      end : (NSDate *) end;

+ (bool) date_is_during_spring : (NSDate *) date;
+ (bool) date_is_during_spring_trimester : (NSDate *) date;
+ (bool) date_is_during_summer : (NSDate *) date;
+ (bool) date_is_during_fall : (NSDate *) date;
+ (bool) date_is_during_fall_trimester : (NSDate *) date;
+ (bool) dates_are_equal : (NSDate *) date1 date2 : (NSDate *) date2;
+ (bool) times_overlap : (NSDate *) start1
                  end1 : (NSDate *) end1
                start2 : (NSDate *) start2
                  end2 : (NSDate *) end2;

+ (bool) dates_overlap : (NSDate *) start1
                  end1 : (NSDate *) end1
                start2 : (NSDate *) start2
                  end2 : (NSDate *) end2;

+ (bool) dates_occur_on_same_day : (NSDate *) date1 date2 : (NSDate *) date2;
+ (bool) is_leap_year : (int) year;

+ (NSString *) get_time : (NSDate *) date;
+ (NSString *) get_time_with_format : (NSDate *) date format : (NSString *) format;
+ (NSString *) get_file_path : (NSString *) filename ext : (NSString *) ext;
+ (NSString *) get_current_course_schedule : (NSDate *) date;

+ (NSDate *) get_date;
+ (NSDate *) get_date : (NSUInteger) hour minute : (NSUInteger) minute;
+ (NSDate *) get_date : (NSUInteger) month day : (NSUInteger) day year : (NSUInteger) year hour : (NSUInteger) hour minute : (NSUInteger) minute;
+ (NSDate *) get_date_with_time : (NSInteger) time;

+ (NSDateComponents *) get_date_components : (unsigned) unit_flags date : (NSDate *) date;
+ (NSDateComponents *) get_date_components_with_calendar : (unsigned) unit_flags calendar : (NSCalendar *) calendar date : (NSDate *) date;

// protected static String time_to_24h(String time);

// protected static String pad_to_len_leading_zeroes(String str, int final_len);

// protected static String time_to_12h(String time);

@end










