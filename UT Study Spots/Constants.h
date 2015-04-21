//
//  Constants.h
//  UT Study Spots
//
//  Created by Fatass on 3/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Location.h"
//#import "Event.h"
//#import "EventList.h"
//#import "Building.h"
//#import "BuildingList.h"
//@class Location;
@class EventList;
@class BuildingList;

/* Project-wide constants */

static bool const _DEBUG = true;
static bool const _DEBUG_USING_LOCAL_CSV_FEEDS = true;
static bool const _DEBUG_CSV_FEEDS_VERBOSE = false;
static bool const _DEBUG_CSV_READER = false;

static NSString *const CSV_FEEDS_WRITE_SUCCESS = @"CSV_FEEDS_WRITE_SUCCESS";
static NSString *const CSV_FEED_ALL_EVENTS_WRITE_SUCCESS = @"CSV_FEED_ALL_EVENTS_WRITE_SUCCESS";
static NSString *const CSV_FEED_ALL_ROOMS_WRITE_SUCCESS = @"CSV_FEED_ALL_ROOMS_WRITE_SUCCESS";
static NSString *const CSV_FEED_ALL_TODAYS_EVENTS_WRITE_SUCCESS = @"CSV_FEED_ALL_ROOMS_WRITE_SUCCESS";

static NSString *const COURSE_SCHEDULE_THIS_SEMESTER = @"master_course_schedule_s15";    //"master_course_schedule_f14"
static NSString *const COURSE_SCHEDULE_NEXT_SEMESTER = nil;     //"master_course_schedule_s15"
static NSString *const DEFAULT_DB_EXT = @"db";

static NSString *const CSV_EXT = @"csv";

extern bool DISABLE_SEARCHES_NEXT_SEMESTER;

static int const BUILDING_CODE_LENGTH = 3;

static int const SPRING_START_MONTH = 1;
static int const SPRING_START_DAY = 20;
static int const SPRING_END_MONTH = 5;
static int const SPRING_END_DAY = 8;
static int const SUMMER_START_MONTH = 6;
static int const SUMMER_START_DAY = 4;
static int const SUMMER_END_MONTH = 8;
static int const SUMMER_END_DAY = 14;
static int const FALL_START_MONTH = 8;
static int const FALL_START_DAY = 27;
static int const FALL_END_MONTH = 12;
static int const FALL_END_DAY = 5;
\
extern NSDate *DAYBREAK;
extern NSDate *NIGHTFALL;

static NSString *const EXIT = @"EXIT";

static NSString *const ALL_DAY = @"all day";
static NSString *const ATRIUM = @"Atrium";\
extern NSDictionary *CAMPUS_BUILDINGS;
extern NSArray *CAMPUS_BUILDINGS_FULLY_QUALIFIED;
\
extern NSLocale *DEFAULT_LOCALE;

static NSString *const CAPACITY = @"capacity";
static NSString *const POWER = @"power";
static NSString *const SEARCH_GDC_ONLY = @"search_gdc_only";
static NSString *const SEARCH_BUILDING = @"search_building";
static NSString *const SEARCH_ROOM = @"search_room";
static NSString *const RANDOM = @"Random";

static int const MAX_CAPACITY = 50;
\
extern int const DAYS_IN_MONTH[];
extern NSString *const DAYS_OF_WEEK_LONG[];
extern NSString *const DAYS_OF_WEEK_SHORT[];
extern int const DAYS_OF_WEEK_ARR_LENGTH;

static int const MONDAY = 1;
static int const TUESDAY = 2;
static int const WEDNESDAY = 3;
static int const THURSDAY = 4;
static int const FRIDAY = 5;
static int const SATURDAY = 6;
static int const SUNDAY = 7;
static int const NUM_DAYS_IN_WEEK = 8;
\
extern NSString *const DEPARTMENTS[];

static int const DEFAULT_EVENT_DURATION = 90;   // minutes
static int const DEFAULT_QUERY_DURATION = 60;
static bool const DEFAULT_ROOM_HAS_POWER = false;
static int const DEFAULT_ROOM_CAPACITY = -1;
static NSString *const CLASS = @"class";
static NSString *const CONFERENCE = @"conference";
static NSString *const LAB = @"lab";
static NSString *const LECTURE_HALL = @"lecture_hall";
static NSString *const LOBBY = @"lobby";
static NSString *const LOUNGE = @"lounge";
static NSString *const SEMINAR = @"seminar";
static NSString *const DEFAULT_ROOM_TYPE = @"class";            // FIX THIS LATER
static NSString *const DEFAULT_GDC_LOCATION = @"Gateshenge";
static NSString *const START_DATE = @"start_date";
static NSString *const END_DATE = @"end_date";
static NSString *const EVENT_NAME = @"event_name";
static NSString *const GDC = @"GDC";
extern Location *GDC_ATRIUM;
extern Location *GDC_GATESHENGE;
extern NSString *const IGNORE_ROOMS[];
extern int const IGNORE_ROOMS_LENGTH;
static NSString *const LOCATION = @"location";

extern NSString *const MONTHS_LONG[];
extern NSString *const MONTHS_SHORT[];

static int const YAM = DEFAULT_ROOM_CAPACITY;
static int const MIN_YEAR = 2014;
static int const MAX_YEAR = 2099;
static int const MIN_YEAR_2 = 14;
static int const MAX_YEAR_2 = 99;
static int const MAX_TIME = 2359;
static int const MIN_TIME = 0000;
static int const MINUTES_IN_HOUR = 60;
static int const MINUTES_IN_DAY = 1440;
static int const HOURS_IN_DAY = 24;
static int const LAST_TIME_OF_DAY = 2230;
static int const LAST_HOUR_OF_DAY = 22;
static int const LAST_MINUTE_OF_DAY = 30;
static int const LAST_TIME_OF_NIGHT = 730;
static int const LAST_HOUR_OF_NIGHT = 7;
static int const LAST_MINUTE_OF_NIGHT = 30;

static NSString *const UTCS_CSV_FEED_FORMAT = @"EEE dd MMM yyyy HHmm";
static NSString *const US_DATE_24H_TIME_FORMAT = @"MMM dd yyyy HHmm";
static NSString *const US_DATE_NO_TIME_FORMAT = @"MMM dd yyyy";

extern NSString *const VALID_GDC_ROOMS[];
extern NSString *const VALID_GDC_ROOMS_TYPES[];
extern int const VALID_GDC_ROOMS_CAPACITIES[];
extern bool const VALID_GDC_ROOMS_POWERS[];
extern int const NUM_VALID_GDC_ROOMS;

/* Optimisation flags */
static bool const STORE_LOCAL_COPY_CSV_FEEDS = false;
static bool const INCLUDE_GDC_CONFERENCE_ROOMS = false;
static bool const INCLUDE_GDC_LOBBY_ROOMS = false;
static bool const INCLUDE_GDC_LOUNGE_ROOMS = false;
static bool const SHORT_CIRCUIT_SEARCH_FOR_ROOM = false;

static unsigned const UNIT_FLAGS = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

static NSStringEncoding const DEFAULT_STRING_ENCODING = NSUTF8StringEncoding;

static NSString *const BOOL_STRS[] = { @"false", @"true" };





// http://stackoverflow.com/a/10573787
typedef NS_ENUM(NSUInteger, SearchStatus) {
    ALL_ROOMS_AVAIL = 0,
    NO_ROOMS_AVAIL = 1,
    ROOM_FREE_ALL_DAY = 2,
    GO_HOME = 3,
    SUMMER = 4,
    HOLIDAY = 5,
    NO_INFO_AVAIL = 6,
    SEARCH_ERROR = 7,
    SEARCH_SUCCESS = 8
};

static int const NUM_SEARCH_STATII = 9;

static NSString *const SEARCH_STATUS_STRINGS[] = {
    @"All rooms available",
    @"No rooms available; please try again",
    @"This room has no scheduled events for today",
    @"Go home and sleep, you procrastinator",
    @"Some or all rooms available (summer hours); check course schedules",
    @"Some or all rooms available (finals schedule or campus closed for holidays",
    @"Not enough info available for search; please try again",
    @"Unknown search error; please try again",
    @"Search successful"
};


static int const NUM_SEARCH_TYPES = 2;
typedef NS_ENUM(NSUInteger, SearchType) {
    RANDOM_ROOM = 0,
    ROOM_SCHEDULE = 1
};

typedef NS_ENUM(NSUInteger, HTTPResponseCode) {
    CONTINUE = 100,
    SWITCHING_PROTOCOLS = 101,
    PROCESSING = 102,
    RESPONSE_OK = 200,
    CREATED = 201,
    ACCEPTED = 202,
    NON_AUTH_INFO = 203,
    NO_CONTENT = 204,
    RESET_CONTENT = 205,
    PARTIAL_CONTENT = 206,
    MULTI_STATUS = 207,
    IM_USED = 226,
    MULTIPLE_CHOICES = 300,
    MOVED_PERMANENTLY = 301,
    FOUND = 302,
    SEE_OTHER = 303,
    NOT_MODIFIED = 304,
    USE_PROXY = 305,
    SWITCH_PROXY = 306,
    TEMP_REDIRECT = 308,
    BAD_REQUEST = 400,
    UNAUTHORIZED = 401,
    PAYMENT_REQUIRED = 402,
    FORBIDDEN = 403,
    NOT_FOUND = 404,
    METHOD_NOT_ALLOWED = 405,
    NOT_ACCEPTABLE = 406,
    PROXY_AUTH_REQUIRED = 407,
    REQUEST_TIMEOUT = 408,
    CONFLICT = 409,
    GONE = 410,
    LENGTH_REQUIRED = 411,
    PRECONDITION_FAILED = 412,
    REQUEST_ENTITY_TOO_LARGE = 413,
    REQUEST_URI_TOO_LONG = 414,
    UNSUPPORTED_MEDIA_TYPE = 415,
    REQUESTED_RANGE_NOT_SATISFIABLE = 416,
    EXPECTATION_FAILED = 417,
    IM_A_TEAPOT = 418,
    AUTH_TIMEOUT = 419,
    METHOD_FAILURE = 420,
    ENHANCE_YOUR_CALM = 420,
    UNPROCESSABLE_ENTITY = 422,
    LOCKED = 423,
    FAILED_DEPENDENCY = 424,
    UPGRADE_REQUIRED = 426,
    PRECONDITION_REQUIRED = 428,
    TOO_MANY_REQUESTS = 429,
    REQUEST_HEADER_FIELDS_TOO_LARGE = 431,
    LOGIN_TIMEOUT = 440,
    NO_RESPONSE = 444,
    RETRY_WITH = 449,
    BLOCKED_BY_WINDOWS_PARENTAL_CONTROLS = 450,
    UNAVAILABLE_FOR_LEGAL_REASONS = 451,
    REDIRECT = 451,
    REQUEST_HEADER_TOO_LARGE = 494,
    CERT_ERROR = 495,
    NO_CERT = 496,
    HTTP_TO_HTTPS = 497,
    TOKEN_EXPIRED_OR_INVALID = 498,
    TOKEN_REQUIRED = 499,
    INTERNAL_SERVER_ERROR = 500,
    NOT_IMPLEMENTED = 501,
    BAD_GATEWAY = 502,
    SERVICE_UNAVAILABLE = 503,
    GATEWAY_TIMEOUT = 504,
    HTTP_VERSION_NOT_SUPPORTED = 505,
    VARIANT_ALSO_NEGOTIATES = 506,
    INSUFFICIENT_STORAGE = 507,
    LOOP_DETECTED = 508,
    BANDWIDTH_LIMIT_EXCEEDED = 509,
    NOT_EXTENDED = 510,
    NETWORK_AUTH_REQUIRED = 511,
    NETWORK_READ_TIMEOUT_ERROR = 598,
    NETWORK_CONNECT_TIMEOUT_ERROR = 599
};

@interface Constants : NSObject

+ (void) load;

+ (bool) get_has_feed_been_read;
+ (void) set_has_feed_been_read;

+ (void) init;

+ (EventList *) get_csv_feeds_master;
+ (EventList *) get_csv_feeds_cleaned;

+ (BuildingList *) get_building_cachelist_this_semester;
+ (BuildingList *) get_building_cachelist_next_semester;

@end











