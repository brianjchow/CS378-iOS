//
//  Query.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

#import "DateTools.h"

//#import "QueryResult.h"
@class QueryResult;

@interface Query : NSObject <NSCopying>

@property (strong, nonatomic, readonly) DTTimePeriod *date;
@property (nonatomic, readonly) int duration;
@property (strong, nonatomic, readonly) NSString *search_building;

- (instancetype) init;
- (instancetype) initWithStartDate : (NSDate *) date;

- (QueryResult *) search;

- (int) get_duration;
- (NSDate *) get_end_date;
- (NSString *) get_option_search_building;
- (NSDate *) get_start_date;
- (bool) set_duration : (int) duration;
- (bool) set_option_search_building : (NSString *) building_code;
- (bool) set_start_date : (NSDate *) start_date;
- (bool) set_start_date_by_calendar : (NSUInteger) month day : (NSUInteger) day year : (NSUInteger) year;
- (bool) set_start_time : (NSUInteger) hour minute : (NSUInteger) minute;

// - (id) copy;
- (id) copyWithZone : (NSZone *) zone;
//- (NSComparisonResult) compare : (Room *) otherObject;
// isEqual and hash overridden

- (NSString *) toString;


@end

/*
 Original methods
 
    - protected Query(Context context);
        - all
    - protected Query(Context context, final Date start_date);
        - all
    - protected int get_duration();
        - all
    - protected final Date get_end_date();
        - all
    - protected final Integer get_option_capacity();
        - random room
    - protected final Boolean get_option_power();
        - random room
    - protected final String get_option_search_building();
        - all
    - protected final String get_option_search_room();
        - room schedule
    - protected final Date get_start_date();
        - all
    - protected String get_current_course_schedule();
        - move to Utilities? (not used in Query)
    - private String get_current_course_schedule(QueryResult query_result);
        - all
    - private int get_this_day_of_week();
        - all
    - private boolean is_truncated_gdc_room(String room);
        - random room
    - private boolean needs_truncation_gdc_room(String room);
        - room schedule
    - protected void reset();
        - none
    - protected boolean search_is_at_night();
        - move to Utilities? (not used in Query)
    - protected boolean search_is_on_weekend();
        - move to Utilities? (not used in Query)
    - protected boolean set_context(Context context);
        - none
    - protected boolean set_duration(int duration);
        - all
    - private boolean set_end_date();
        - all
    - protected boolean set_option(final String option, final Object value);
        - none
    - protected boolean set_option_capacity(final Integer capacity);
        - random room
    - protected boolean set_option_power(final Boolean power);
        - random room
    - protected boolean set_option_search_building(final String building_code);
        - all
    - protected boolean set_option_search_room(final String room_num);
        - room schedule
    - protected void set_standard_options();
        - none (used by reset())
    - protected boolean set_start_date(final Date start_date);
        - all
    - protected boolean set_start_date(int month, int day, int year);
        - all
    - protected boolean set_start_time(int hour, int minute);
        - all
    - protected Query clone();
    - public boolean equals(Object other);
    - public int hashCode();
    - public String toString();
 
    - Parcelable implementation
        - public Query(Parcel parcel);
        - public int describeContents();
        - public void writeToParcel(Parcel out, int flags);
        - public static final Parcelable.Creator<Query> CREATOR = new Parcelable.Creator<Query>() {
            public Query createFromParcel(Parcel in);
            public Query[] newArray(int size);
          }
 
    - search - get random room
        - user can select: building, start date, start time, duration, capacity, power
 
        - protected QueryResult search();
        - private QueryResult search(final EventList eolist);
        - private boolean is_valid_gdc_room(Room room);
        - private SortedSet<String> add_invalid_rooms_by_gdc_csv_feeds(final EventList eolist, SortedSet<String> rooms_to_remove);
        - private SortedSet<String> add_invalid_rooms_by_options(Building search_building, SortedSet<String> valid_rooms, SortedSet<String> rooms_to_remove);
        - private SortedSet<String> add_invalid_rooms_by_course_schedule(Building search_building, SortedSet<String> valid_rooms, SortedSet<String> rooms_to_remove);
 
    - search - get room schedule
        - user can select: building, room, date
 
        - protected QueryResult search_get_room_schedule();
        - protected QueryResult search_get_room_schedule(final EventList eolist);
        - private Room get_search_room(Building search_building);
        - private Set<Event> get_course_schedule_for_room(Room search_room, boolean search_is_during_long_semester);
        - private Set<Event> add_gdc_csv_feed_events(final EventList eolist, final Set<Event> all_events, final Room search_room, boolean search_is_during_long_semester);
        - private List<String> eventset_to_string(final Set<Event> eventset);
 
    - QueryResult
    - SearchStatus (enum)
    - SearchType (enum)
 
 
 */


