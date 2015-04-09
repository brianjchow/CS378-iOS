//
//  CSVReader.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "CSVReader.h"

#import "ConnectionManager.h"
#import "UTCSVFeedDownloadManager.h"

#import "InputReader.h"
#import "FileOutputWriter.h"

#import "Utilities.h"
#import "Constants.h"
#import "NSMutableString+Stack.h"
#import "NSString+Tools.h"

@interface CSVReader ()

+ (NSArray *) read_csv_from_file : (NSString *) filename;
//+ (NSArray *) read_csv_from_url : (NSURL *) url;
+ (NSDictionary *) split_line : (NSString *) str;

// helper methods to be used when downloading feeds/data
//+ (bool) file_exists : (NSString *) filename;
//+ (bool) file_is_current : (NSString *) filename;
////+ (bool) delete_all_feeds;
//+ (bool) get_csv_feeds_write_success : (NSString *) pref_name;
//+ (bool) set_csv_feeds_write_success : (NSString *) filename success : (bool) success;

// misc private methods
- (instancetype) init;

@end

@implementation CSVReader

//static int const DAILY_UPDATE_TIME = 859;   // 8:59a; update if curr time is 9a or after

static char const DELIMITER = '\"';

static int lines_read = 0;
static int lines_ignored = 0;

+ (EventList *) read_csv_default {
    return ([self read_csv : _DEBUG_USING_LOCAL_CSV_FEEDS]);
}

+ (EventList *) read_csv : (bool) read_from_local_feeds {
    if ([Constants get_has_feed_been_read]) {
        if (_DEBUG) NSLog(@"CSVReader: sequential attempt to read CSV feeds detected");
        return ([Constants get_csv_feeds_master]);
    }
    [Constants set_has_feed_been_read];
    
//    NSArray *event_strings;     // List<HashMap<String, String>>
    EventList *events = [[EventList alloc] init];
    
    if (!read_from_local_feeds) {
        if (!_DEBUG) NSLog(@"CSVReader: now reading CSV feeds from UTCS servers...");
        
        if ([ConnectionManager has_wifi] || [ConnectionManager has_wwan]) {
////            bool success = [UTCSVFeedDownloadManager download_all];
            [UTCSVFeedDownloadManager download_all];
            
////            if (success) {
//            if ([Constants get_csv_feeds_cleaned]) {
//                NSLog(@"CSVReader: successfully downloaded all CSV feeds from UTCS servers");
//                
//                events = [CSVReader read_csv_from_all_downloaded_files];
//            }
//            else {
//                NSLog(@"CSVReader: failed to download all CSV feeds or all feeds empty; now reading from local files");
//                
//                events = [CSVReader read_csv_from_all_local_files];
//            }
            
            UTCSVFeedDownloadManager *manager = [UTCSVFeedDownloadManager csv_dl_manager];
            while (manager.downloadIsInProgress) {
                // do nothing
                // this blocks for a max of UTCSVFeedDownloadManager.TIMEOUT_DURATION
            }
            
            NSLog(@"CSVReader: finished downloading CSV feeds from UTCS servers. Now attempting to read from Documents dir...");
            
            events = [CSVReader read_csv_from_all_downloaded_files];
        }
        else {
            NSLog(@"CSVReader: failed to detect WiFi or WWAN signal; now reading from local files (wifi: %@ - wwan: %@)", BOOL_STRS[[ConnectionManager has_wifi]], BOOL_STRS[[ConnectionManager has_wwan]]);
            
            events = [CSVReader read_csv_from_all_local_files];
        }
        
    }
    else {
        if (_DEBUG) NSLog(@"CSVReader: now reading CSV feeds from local files...");
        
        events = [CSVReader read_csv_from_all_local_files];
        
//        event_strings = [self read_csv_from_file : @"calendar_events_today_feed_0412"];
//        [events add_hashmap_list : event_strings];
//        
//        event_strings = [self read_csv_from_file : @"calendar_events_feed_0412"];
//        [events add_hashmap_list : event_strings];
//        
//        event_strings = [self read_csv_from_file : @"calendar_rooms_feed_0412"];
//        [events add_hashmap_list : event_strings];
    }
    
    if (_DEBUG) {
        if (read_from_local_feeds) {
            NSLog(@"CSVReader: read in %d lines from local CSV feeds", lines_read);
        }
        else {
            NSLog(@"CSVReader: read in %d lines from CSV feeds from UTCS servers", lines_read);
        }
        
        NSLog(@"CSVReader: corresponding EventList size: %lu (ignored %d malformed lines)", [events get_size], lines_ignored);
    }
    
    return events;
}

/* ************************************ PRIVATE METHODS ************************************ */

- (instancetype) init {
    self = [super init];
    return self;
}

+ (EventList *) read_csv_from_all_downloaded_files {
    EventList *out = [[EventList alloc] init];
    NSArray *event_strings;
    
    event_strings = [self read_csv_from_downloaded_file : ALL_EVENTS_SCHEDULE_FILENAME];
    [out add_hashmap_list : event_strings];

    event_strings = [self read_csv_from_downloaded_file : ALL_ROOMS_SCHEDULE_FILENAME];
    [out add_hashmap_list : event_strings];
    
    event_strings = [self read_csv_from_downloaded_file : ALL_TODAYS_EVENTS_FILENAME];
    [out add_hashmap_list : event_strings];
    
    return out;
}

// all downloads reside in Documents dir
+ (NSArray *) read_csv_from_downloaded_file : (NSString *) filename {
    if ([Utilities is_null : filename] || filename.length <= 0) {
        // TODO - throw IAException
    }
    
    //    NSMutableArray *schedules = [[NSMutableArray alloc] initWithCapacity : 100];
    
    NSString *file_path = [UTCSVFeedDownloadManager get_file_path : filename];
    if ([Utilities is_null : file_path]) {
        if (_DEBUG) {
            NSLog(@"ERROR: could not find path for file \"%@\", CSVReader.read_csv_from_downloaded_file()", filename);
        }
        return [NSArray new];
    }
    
    return ([self read_csv_with_file_path : file_path]);
}

// store all local files in the Assets folder
+ (EventList *) read_csv_from_all_local_files {
    EventList *out = [[EventList alloc] init];
    NSArray *event_strings;
    
    event_strings = [self read_csv_from_file : @"calendar_events_today_feed_0412"];
    [out add_hashmap_list : event_strings];
    
    event_strings = [self read_csv_from_file : @"calendar_events_feed_0412"];
    [out add_hashmap_list : event_strings];

    event_strings = [self read_csv_from_file : @"calendar_rooms_feed_0412"];
    [out add_hashmap_list : event_strings];
    
//    NSLog(@"CSVReader: finished reading from local files:\n%@", [out toString]);
    
    return out;
}

+ (NSArray *) read_csv_with_file_path : (NSString *) file_path {
    NSMutableArray *schedules = [[NSMutableArray alloc] initWithCapacity : 100];
    
    InputReader *input;
    input = [[InputReader alloc] initWithFilePath : file_path];
    
    int temp;
    char curr_byte;
    
    NSMutableString *curr_line = [NSMutableString new];     // StringBuilder
    NSDictionary *result;                                   // HashMap<String, String>
    
    while ((temp = [input read]) != -1) {
        curr_byte = (char) temp;
        
        if (curr_byte != '\n') {
            [curr_line appendFormat : @"%c", curr_byte];
        }
        
        // end of line reached in file; parse this event
        else {
            result = [self split_line : curr_line];
            
            if (![Utilities is_null : result]) {
                [schedules addObject : result];
            }
            
            curr_line = [NSMutableString new];
            lines_read++;
        }
    }
    
    return schedules;
}

// returns List<HashMap<String, String>>
+ (NSArray *) read_csv_from_file : (NSString *) filename {
    if ([Utilities is_null : filename] || filename.length <= 0) {
        // TODO - throw IAException
    }
    
//    NSMutableArray *schedules = [[NSMutableArray alloc] initWithCapacity : 100];
    
    NSString *file_path = [Utilities get_file_path : filename ext : CSV_EXT];
    if ([Utilities is_null : file_path]) {
        if (_DEBUG) {
            NSLog(@"ERROR: could not find path for file \"%@\", CSVReader.read_csv_from_file()", filename);
        }
        return [NSArray new];
    }
    
    return ([self read_csv_with_file_path : file_path]);
    
//    InputReader *input;
//    input = [[InputReader alloc] initWithFilePath : file_path];
//    
//    int temp;
//    char curr_byte;
//    
//    NSMutableString *curr_line = [NSMutableString new];     // StringBuilder
//    NSDictionary *result;                                   // HashMap<String, String>
//    
//    while ((temp = [input read]) != -1) {
//        curr_byte = (char) temp;
//
//        if (curr_byte != '\n') {
//            [curr_line appendFormat : @"%c", curr_byte];
//        }
//        
//        // end of line reached in file; parse this event
//        else {
//            result = [self split_line : curr_line];
//            
//            if (![Utilities is_null : result]) {
//                [schedules addObject : result];
//            }
//            
//            curr_line = [NSMutableString new];
//            lines_read++;
//        }
//    }
//    
//    return schedules;
}

// returns HashMap<String, String>; arg type is equivalent to StringBuilder (each cell is a char)
+ (NSDictionary *) split_line : (NSString *) str {
    if ([Utilities is_null : str]) {
        // TODO - throw IAException
        
        if (_DEBUG) NSLog(@"CSVReader: null string encountered in split_line()");
        return nil;
    }
    else if (str.length == 0) {
        return nil;
    }
    
    NSMutableDictionary *tuple = [[NSMutableDictionary alloc] initWithCapacity : 3];
    bool delim_in_stack = false;
//    str = [[str reverseObjectEnumerator] allObjects];
    str = [str reverse];
    
    NSMutableString *stack = [[NSMutableString alloc] init];
    
    NSUInteger length = str.length;
    char curr_char;
    NSString *temp_to_str = nil;
    
    for (int i = 0; i < length; i++) {
        curr_char = [str characterAtIndex : i];
        
        /*
         Enough info collected from one segment of current event String; pop
         everything off the Stack and process the resultant String according
         to what info it contains.
         */
        if (curr_char == DELIMITER && delim_in_stack) {
            NSMutableString *temp = [NSMutableString new];
            char curr_stack_char;
            while (![stack empty] && ((curr_stack_char = [stack pop]) != DELIMITER)) {
                [temp appendFormat : @"%c", curr_stack_char];
            }
            delim_in_stack = false;
            
            // strip formatting
            temp_to_str = temp;
            temp_to_str = [temp_to_str replaceAll : @"(  )+" replace_with : @" "];
            temp_to_str = [temp_to_str replaceAll : @"(CST|CDT|registrar?( - )*|room?(: )*)?[():,]*" replace_with : @""];
            
            if ([temp_to_str isEqualToString : @"Location"] || [temp_to_str isEqualToString : @"Title"]) {
                if (_DEBUG) {
                    NSLog(@"Reading CSV feed; invalid line token detected:1 (%@)", temp_to_str);
                }
                lines_ignored++;
                return nil;
            }
            
            if (temp_to_str.length > 0) {
                
                // location encountered
                if ([temp_to_str containsIgnoreCase : GDC] ||
                    [temp_to_str is_campus_building]) {
                    [tuple setValue : temp_to_str forKey : LOCATION];
                }
                
                // event time and date encountered
                else if ([temp_to_str is_date_string]) {
                    if ([temp_to_str containsIgnoreCase : ALL_DAY]) {
                        temp_to_str = [temp_to_str replaceAll : [NSString stringWithFormat : @"(%@)", ALL_DAY] replace_with : @"0001"];
                        NSString *copy = temp_to_str;
                        copy = [copy replaceAll : @"0001" replace_with : @"2359"];
                        [tuple setValue : copy forKey : END_DATE];
                    }
                    [tuple setValue : temp_to_str forKey : START_DATE];
                }
                
                // event name encountered
                else {
                    NSString *curr_event_name;
                    if (![Utilities is_null : (curr_event_name = [tuple objectForKey : EVENT_NAME])]) {
                        NSMutableString *copy = [NSMutableString stringWithString : temp_to_str];
                        [copy appendFormat : @"%@", curr_event_name];
                        temp_to_str = copy;
                    }
                    [tuple setValue : temp_to_str forKey : EVENT_NAME];
                }
            }
//            else {
////                NSLog(@"CSVReader: empty temp_to_str, CSVReader.split_line()");
//                continue;
//            }
        }
        
        /* Begin processing next segment in current event String. */
        else if (curr_char == DELIMITER && !delim_in_stack) {
            [stack push : curr_char];
            delim_in_stack = true;
        }
        
        else {
            [stack push : curr_char];
        }
        
    }
    
    /* Skip malformed lines by counting the number of remaining delimiters in the Stack. */
    if (![stack empty]) {
        int num_delims = 0;
        while (![stack empty]) {
            if ((curr_char = [stack pop]) == DELIMITER) {
                num_delims++;
            }
        }
        
        if (num_delims % 2 > 0) {
            if (_DEBUG) NSLog(@"Reading CSV feed; invalid line detected:2");
            lines_ignored++;
            return nil;
        }
    }
    
    /* Set default location of this event, if none specified. */
    if ([Utilities is_null : [tuple objectForKey : LOCATION]]) {
        [tuple setValue : [NSString stringWithFormat : @"%@ %@", GDC, DEFAULT_GDC_LOCATION] forKey : LOCATION];
    }
    
    if (_DEBUG) {
//                NSLog(@"Now returning from processing line\n\tEvent name: %@\n\t\tStart date: %@\n\t\tEnd date: %@\n\t\tLocation: %@", [tuple objectForKey : EVENT_NAME], [tuple objectForKey : START_DATE], [tuple objectForKey : END_DATE], [tuple objectForKey : LOCATION]);
//        
//                NSLog(@"\tEvent name: %@", [tuple objectForKey : EVENT_NAME]);
//                NSLog(@"\tStart date: %@", [tuple objectForKey : START_DATE]);
//                NSLog(@"\tEnd date: %@", [tuple objectForKey : END_DATE]);
//                NSLog(@"\tLocation: %@", [tuple objectForKey : LOCATION]);
    }
    
    return tuple;
}

//// returns List<HashMap<String, String>>
//+ (NSArray *) read_csv_from_url : (NSURL *) url {
//    
//    return nil;
//}
//
//// only use when downloading feeds
//+ (bool) file_exists : (NSString *) filename {
//    
//    return false;
//}
//
//// only use when downloading feeds
//+ (bool) file_is_current : (NSString *) filename {
//    
//    return false;
//}
//
//// only use when downloading feeds
//+ (bool) get_csv_feeds_write_success : (NSString *) pref_name {
//    
//    return false;
//}
//
//// only use when downloading feeds
//+ (bool) set_csv_feeds_write_success : (NSString *) filename success : (bool) success {
//    
//    return false;
//}
//
//// only use when downloading feeds
//+ (bool) file_delete : (NSString *) filename {
//    
//    return false;
//}



@end







