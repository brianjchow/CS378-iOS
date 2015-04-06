//
//  ViewController.m
//  UT Study Spots
//
//  Created by Fatass on 3/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "NSMutableString+Stack.h"

#import "Event.h"
#import "InputReader.h"
#import "CSVReader.h"
#import "Query.h"
#import "QueryRandomRoom.h"
#import "QueryRoomSchedule.h"
#import "UTCSVFeedDownloadManager.h"

#import "DateTools.h"
#import "NSString+Tools.h"

#import "Stopwatch.h"

/*
    TODO
        - create NSString class extension for methods in Utilities
        - multiple categories for Query?
        - fix copyWithZone methods for all classes
        - figure out how to enforce UTF8 encoding
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self test_csvreader_local];
  
    [self test_constants_init_default];
    
//    [self test_stopwatch];
    
    
    
    
    
    
//    [self test_weekend_dates];
    
//    [self qrr_basic_test];
    
    // http://stackoverflow.com/questions/640885/best-cocoa-objective-c-wrapper-library-for-sqlite-on-iphone
    // https://github.com/misato/SQLiteManager4iOS
    
//    UIImage *panda_cycle_loader = [UIImage animatedImageNamed : @"frame_" duration : 1.0f];
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage : [UIImage imageNamed : @"backgroundinitial"]];
    
//    NSString *google = @"http://www.google.com/trends/trendsReport?hl=en-US&cat=0-14&date=today%207-d&cmpt=q&content=1&export=1";
//    google = [google stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    google = ALL_EVENTS_SCHEDULE;
//    UTCSVFeedDownloadManager *downloader = [[UTCSVFeedDownloadManager alloc] initWithURLString : google filename : ALL_EVENTS_SCHEDULE_FILENAME];
//
//    [downloader download];
}

- (void) test_dates {
    NSDate *curr_date = [Utilities get_date];
    NSLog(@"Current date: %@", curr_date);
    
    NSDate *test_date = [Utilities get_date : 11 day : 12 year : 2014 hour : 22 minute : 10];
    NSLog(@"Test date: %@", test_date);
    
    NSDate *test0 = [Utilities get_date : 13 minute : 12];
    NSLog(@"test0: %@", test0);
}

- (void) test_file_path_and_read_csv_into_memory {
    NSBundle *main_bundle = [NSBundle mainBundle];
    NSString *file_path = [main_bundle pathForResource : @"calendar_events_feed_0412" ofType : @"csv"];
//    NSString *test_csv = [[NSString alloc] initWithContentsOfFile : file_path usedEncoding : NSUTF8StringEncoding error : nil];
    
    NSString *test_csv_read = [NSString stringWithContentsOfFile : file_path encoding : NSUTF8StringEncoding error : nil];
    NSArray *test_csv_read_arr = [test_csv_read componentsSeparatedByString : @"\n"];
    NSLog(@"Test read CSV feed:\n%@", test_csv_read_arr);
}

- (void) test_inputreader_read {
    NSString *file_path = [Utilities get_file_path : @"calendar_events_feed_0412" ext : @"csv"];
    
    InputReader *reader = [[InputReader alloc] initWithFilePath : file_path];
    int curr_byte;
    while ((curr_byte = [reader read]) != -1) {
        NSLog(@"%c", (char) curr_byte);
    }
}

- (void) test_inputreader_read_line {
    NSString *file_path = [Utilities get_file_path : @"calendar_events_feed_0412" ext : @"csv"];

    InputReader *reader_line = [[InputReader alloc] initWithFilePath : file_path];
    NSString *curr_line;
    while ((curr_line = [reader_line read_line]) != nil) {
        NSLog(@"%@", curr_line);
    }
}

- (void) test_event {
    NSDate *curr_date = [Utilities get_date];
    Event *test_event0 = [[Event alloc] initWithDatesNoLocation : @"Test Event 0" start_date : curr_date end_date : nil location : @"GDC 2.410"];
    NSLog(@"%@", [test_event0 toString]);
}

- (void) test_campus_buildings_static_map {
    NSArray *campus_buildings_keyset = [CAMPUS_BUILDINGS allKeys];
    NSLog(@"\nCampus buildings (size %lu):", [campus_buildings_keyset count]);
    for (int i = 0; i < [campus_buildings_keyset count]; i++) {
        NSLog(@"\t%@", campus_buildings_keyset[i]);
    }
}

- (void) test_substring {
    NSString *substring_test = @"FEOWIEJFWEIOJFIO";
    NSRange substring_test_range = NSMakeRange(0, 3);
    substring_test = [substring_test substringWithRange : substring_test_range];
    NSLog(@"Substring test: %@", substring_test);
}

- (void) test_stack {
    NSMutableString *stack_test = [NSMutableString new];
    char c = 'c';
    [stack_test push : c];
    NSLog(@"Stack is empty: %d with size: %lu", [stack_test empty], [stack_test size]);
    char stack_pop = [stack_test pop];
    NSLog(@"Popped char: %c", stack_pop);
    NSLog(@"Stack is empty: %d with size: %lu", [stack_test empty], [stack_test size]);
}

- (void) test_string_reverse {
    NSString *test_string_reverse = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    test_string_reverse = [test_string_reverse reverse];
    NSLog(@"Reversed string: %@", test_string_reverse);
}

- (void) test_csvreader_local {
    EventList *events = [CSVReader read_csv_default];
    NSLog(@"EventList:\n%@", [events toString]);
    NSLog(@"EventList size: %lu", [events get_size]);
}

- (void) test_constants_init_default {
    Stopwatch *stopwatch = [Stopwatch new];
    
    [stopwatch start];
    [Constants init_default];
    [stopwatch stop];
    
    NSLog(@"Took %f seconds to complete initialisation", [stopwatch time]);
}

- (void) test_weekend_dates {
    NSDate *saturday = [Utilities get_date : 3
                                       day : 28
                                      year : 15
                                      hour : 4
                                    minute : 39];
    NSLog(@"Date is on weekend : %d (%@)", saturday.isWeekend, saturday);
    NSLog(@"Weekday: %ld (ordinal: %ld)", saturday.weekday, saturday.weekdayOrdinal);
    
    NSDate *sunday = [Utilities get_date : 3
                                     day : 29
                                    year : 15
                                    hour : 23
                                  minute : 45];
    NSLog(@"Date is on weekend : %d (%@)", sunday.isWeekend, sunday);
    NSLog(@"Weekday: %ld (ordinal: %ld)", sunday.weekday, sunday.weekdayOrdinal);
    
    NSDate *monday = [Utilities get_date : 3
                                     day : 30
                                    year : 15
                                    hour : 4
                                  minute : 39];
    NSLog(@"Date is on weekend : %d (%@)", monday.isWeekend, monday);
    NSLog(@"Weekday: %ld (ordinal: %ld)", monday.weekday, monday.weekdayOrdinal);
    
    NSLog(@"Monday date: %ld, %ld, %ld, %ld, %ld, %ld (day of year)", monday.month, monday.day, monday.year, monday.hour, monday.minute, monday.dayOfYear);
    
    double monday_seconds_from_sunday = [monday secondsFrom : sunday];
    double sunday_seconds_from_monday = [sunday secondsFrom : monday];
    NSLog(@"Mon secs from Sun + vice versa %f %f", monday_seconds_from_sunday, sunday_seconds_from_monday);
    
    NSString *timeAgoSinceDate = [monday timeAgoSinceDate : sunday];
    NSLog(@"Mon timeAgoSinceDate sun: %@", timeAgoSinceDate);
    
    NSDate *monday_clone = [monday copy];
    NSLog(@"Monday clone: %@", monday_clone);

    NSDate *time_only = [Utilities get_date : 20 minute : 11];
    NSLog(@"Time only: %@", time_only);
}

- (void) test_sorting {
    NSMutableArray *unsorted = [[NSMutableArray alloc] initWithCapacity : 8];
    for (int i = 0; i < 8; i++) {
        NSString *temp = [DAYS_OF_WEEK_LONG[i] copy];
        [unsorted addObject : temp];
    }
    
    NSLog(@"Unsorted: %@", unsorted);
    
    NSArray *sorted = [unsorted copy];
    sorted = [sorted sortedArrayUsingSelector : @selector(localizedCaseInsensitiveCompare : )];
    
    NSLog(@"Sorted: %@", sorted);
    
    NSOrderedSet *ordered_set = [[NSOrderedSet alloc] initWithArray : sorted];
    
    NSLog(@"NSOrderedSet: %@", ordered_set);
}

- (void) qrr_basic_test {
    NSDate *curr_date = [Utilities get_date];
    QueryRandomRoom *qrr = [[QueryRandomRoom alloc] initWithStartDate : curr_date];
    Query *query = [[Query alloc] initWithStartDate : curr_date];
    NSLog(@"Curr date: %@\n\nQueryRandomRoom:\n%@\n\nQuery:\n%@\n\n", curr_date, [qrr toString], [query toString]);
    
    NSLog(@"Query isEqual to QueryRandomRoom: %@", BOOL_STRS[[query isEqual : qrr]]);
    NSLog(@"QueryRandomRoom isEqual to Query: %@", BOOL_STRS[[qrr isEqual : query]]);
    
}

- (void) test_stopwatch {
    Stopwatch *stopwatch = [Stopwatch new];
    [stopwatch start];
    sleep(1);
    [stopwatch stop];
    
    NSLog(@"Started: %f\tStopped: %f\nElapsed time: %f seconds (should be ~1 second)", stopwatch._start, stopwatch._stop, [stopwatch time]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
