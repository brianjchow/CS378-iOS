//
//  Constants.m
//  UT Study Spots
//
//  Created by Fatass on 3/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "Constants.h"

#import "Utilities.h"

#import "NSString+Tools.h"

#import "EventList.h"
#import "BuildingList.h"
#import "CSVReader.h"

bool DISABLE_SEARCHES_NEXT_SEMESTER;
NSDate *DAYBREAK;
NSDate *NIGHTFALL;
NSDictionary *CAMPUS_BUILDINGS;
NSLocale *DEFAULT_LOCALE;
Location *GDC_ATRIUM;
Location *GDC_GATESHENGE;

@implementation Constants

NSString *const TAG = @"Constants";

static EventList *CSV_FEEDS_MASTER;
static EventList *CSV_FEEDS_CLEANED;
static bool has_feed_been_read;

static BuildingList *BUILDING_CACHELIST_THIS_SEMESTER;
static BuildingList *BUILDING_CACHELIST_NEXT_SEMESTER;

+ (void) initialize {
    
}

// http://stackoverflow.com/questions/4360327/objective-c-how-to-use-extern-variables
// http://stackoverflow.com/questions/7097090/so-very-lost-on-initializing-const-objects
+ (void) load {
    static bool done = false;   // unnecessary; necessary if using initialize()
    if (!done) {
        CSV_FEEDS_MASTER = nil;
        CSV_FEEDS_CLEANED = nil;
        has_feed_been_read = false;
        
        BUILDING_CACHELIST_THIS_SEMESTER = nil;
        BUILDING_CACHELIST_NEXT_SEMESTER = nil;
        
        if (!COURSE_SCHEDULE_NEXT_SEMESTER) {
            DISABLE_SEARCHES_NEXT_SEMESTER = true;
        }
        else {
            DISABLE_SEARCHES_NEXT_SEMESTER = false;
        }
        
        DAYBREAK = [Utilities get_date : 1 day : 2 year : 2015 hour : LAST_HOUR_OF_DAY minute : LAST_MINUTE_OF_DAY];
        NIGHTFALL = [Utilities get_date : 1 day : 1 year : 2015 hour : LAST_HOUR_OF_NIGHT minute : LAST_MINUTE_OF_NIGHT];
        
        CAMPUS_BUILDINGS = [self init_campus_buildings];
        
        DEFAULT_LOCALE = [[NSLocale alloc] initWithLocaleIdentifier : @"en_US"];
        
        GDC_ATRIUM = [[Location alloc] initFullyQualified : @"GDC Atrium"];
        GDC_GATESHENGE = [[Location alloc] initFullyQualified : @"GDC Gateshenge"];
        
        done = true;
    }
    
}

+ (bool) get_has_feed_been_read {
    return (has_feed_been_read);
}

+ (void) set_has_feed_been_read {
    has_feed_been_read = true;
}

+ (void) init {
    if (!COURSE_SCHEDULE_THIS_SEMESTER) {
        // TODO - throw ISException
    }
    
    [self reset];
    // [self delete_all_feeds];
    
    [self init_shared_prefs];
    
    CSV_FEEDS_MASTER = [CSVReader read_csv];
    if (!CSV_FEEDS_MASTER) {
        // TODO - throw ISException
        
        NSLog(@"%@: crap", TAG);
    }
    else {
        //        if (_DEBUG) {
        //            NSLog(@"%@:\n%@", TAG, [CSV_FEEDS_MASTER toString]);
        //        }
    }
    
    CSV_FEEDS_CLEANED = [self get_events_cleaned];
    
    if (_DEBUG) {
        if (_DEBUG_CSV_FEEDS_VERBOSE) {
            NSLog(@"Now finished reading CSV feeds\n\tSize of CSV_FEEDS_MASTER: %lu\n\tSize of CSV_FEEDS_CLEANED: %lu\n%@", [CSV_FEEDS_MASTER get_size], [CSV_FEEDS_CLEANED get_size], [CSV_FEEDS_CLEANED toString]);
        }
        else {
            NSLog(@"Now finished reading CSV feeds\n\tSize of CSV_FEEDS_MASTER: %lu\n\tSize of CSV_FEEDS_CLEANED: %lu\n", [CSV_FEEDS_MASTER get_size], [CSV_FEEDS_CLEANED get_size]);
        }
        NSLog(@"Now creating initial BuildingLists...");
    }
    
    BUILDING_CACHELIST_THIS_SEMESTER = [[BuildingList alloc] init];
    Building *const gdc_instance_this_semester = [Building get_instance : GDC db_filename : COURSE_SCHEDULE_THIS_SEMESTER];
    if (!gdc_instance_this_semester) {
        // TODO - throw ISException
    }
    
    if (_DEBUG) {
        NSLog(@"Num rooms in GDC  list: %d", [[BUILDING_CACHELIST_THIS_SEMESTER get_building : GDC] get_num_rooms]);
        
        //        NSLog(@"\n");
        NSLog(@"\n%@", [gdc_instance_this_semester toString]);
    }
    
    if (COURSE_SCHEDULE_NEXT_SEMESTER) {
        BUILDING_CACHELIST_NEXT_SEMESTER = [[BuildingList alloc] init];
        
        Building *const gdc_instance_next_semester = [Building get_instance : GDC db_filename : COURSE_SCHEDULE_NEXT_SEMESTER];
        if (!gdc_instance_next_semester) {
            // TODO - throw ISException
        }
    }
    
    if (_DEBUG) {
        NSLog(@"Reached end of initialisation; program ready");
    }
}

+ (EventList *) get_csv_feeds_master {
    return CSV_FEEDS_MASTER;
}

+ (EventList *) get_csv_feeds_cleaned {
    return CSV_FEEDS_CLEANED;
}

+ (BuildingList *) get_building_cachelist_this_semester {
    return BUILDING_CACHELIST_THIS_SEMESTER;
}

+ (BuildingList *) get_building_cachelist_next_semester {
    return BUILDING_CACHELIST_NEXT_SEMESTER;
}


/* ************************************ PRIVATE METHODS ************************************ */

+ (void) reset {
    CSV_FEEDS_MASTER = nil;
    CSV_FEEDS_CLEANED = nil;
    has_feed_been_read = false;
    
    BUILDING_CACHELIST_THIS_SEMESTER = nil;
    BUILDING_CACHELIST_NEXT_SEMESTER = nil;
}

// http://stackoverflow.com/questions/4843255/where-to-initialize-iphone-application-defaults
// http://stackoverflow.com/questions/5397364/iphone-how-to-detect-if-a-key-exists-in-nsuserdefaults-standarduserdefaults
+ (void) init_shared_prefs {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *all_keys = [[prefs dictionaryRepresentation] allKeys];
    
    NSMutableDictionary *default_prefs = [NSMutableDictionary new];
    
    if (![all_keys containsObject : CSV_FEEDS_WRITE_SUCCESS]) {
        [default_prefs setValue : [NSNumber numberWithBool : NO] forKey : CSV_FEEDS_WRITE_SUCCESS];
    }
    
    if (![all_keys containsObject : CSV_FEED_ALL_EVENTS_WRITE_SUCCESS]) {
        [default_prefs setValue : [NSNumber numberWithBool : NO] forKey : CSV_FEED_ALL_EVENTS_WRITE_SUCCESS];
    }
    
    if (![all_keys containsObject : CSV_FEED_ALL_EVENTS_WRITE_SUCCESS]) {
        [default_prefs setValue : [NSNumber numberWithBool : NO] forKey : CSV_FEED_ALL_EVENTS_WRITE_SUCCESS];
    }
    
    if (![all_keys containsObject : CSV_FEED_ALL_TODAYS_EVENTS_WRITE_SUCCESS]) {
        [default_prefs setValue : [NSNumber numberWithBool : NO] forKey : CSV_FEED_ALL_TODAYS_EVENTS_WRITE_SUCCESS];
    }
    
    if ([default_prefs count] > 0) {
        [[NSUserDefaults standardUserDefaults] registerDefaults : default_prefs];
    }
    
}

// http://stackoverflow.com/questions/992901/how-do-i-iterate-over-an-nsarray
+ (EventList *) get_events_cleaned {
    if (!CSV_FEEDS_MASTER) {
        // TODO - throw ISException
    }
    
    EventList *out = [[EventList alloc] init];
    NSEnumerator *itr = [CSV_FEEDS_MASTER get_enumerator];
    
    //  id event;
    Event *event;
    Location *curr_eo_loc;
    NSString *loc_str;
    
    while (event = [itr nextObject]) {
        curr_eo_loc = [event get_location];
        loc_str = [curr_eo_loc toString];
        
        if ([loc_str containsIgnoreCase : @"1.210"] ||
            [loc_str containsIgnoreCase : @"2.100"] ||
            [loc_str containsIgnoreCase : @"3.100"] ||
            [loc_str containsIgnoreCase : @"3.100"] ||
            [loc_str containsIgnoreCase : @"4.100"] ||
            [loc_str containsIgnoreCase : @"4.202"] ||
            [loc_str containsIgnoreCase : @"4.314"] ||
            [loc_str containsIgnoreCase : @"5.100"] ||
            [loc_str containsIgnoreCase : @"6.100"] ||
            [loc_str containsIgnoreCase : @"6.302"] ||
            [loc_str containsIgnoreCase : ATRIUM] ||
            [loc_str containsIgnoreCase : DEFAULT_GDC_LOCATION]) {
            continue;
        }
        [out add_event : [event copy]];
    }
    
    return out;
}

+ (NSDictionary *) init_campus_buildings {
    static NSString *const CAMPUS_BUILDINGS[] = {
        @"ACA", @"AHG", @"ART", @"ATT",
        @"BAT", @"BEL", @"BEN", @"BIO", @"BMC", @"BME", @"BRB", @"BTL", @"BUR",
        @"CAL", @"CBA", @"CCJ", @"CLA", @"CMA", @"CMB", @"CRD", @"DFA",
        @"ECJ", @"ENS", @"EPS", @"ETC",
        @"FAC", @"FDH", @"FNT",
        @"GAR", @"GDC", @"GEA", @"GEB", @"GOL", @"GRE", @"GSB",
        @"HRC", @"HRH",
        @"INT",
        @"JES", @"JGB", @"JON",
        @"LTH",
        @"MAI", @"MBB", @"MEZ", @"MRH",
        @"NEZ", @"NHB", @"NMS", @"NOA", @"NUR",
        @"PAC", @"PAI", @"PAR", @"PAT", @"PCL", @"PHR", @"POB",
        @"RLM", @"RSC",
        @"SAC", @"SEA", @"SRH", @"SSB", @"SSW", @"STD", @"SUT", @"SZB",
        @"TNH", @"TSC",
        @"UTA", @"UTC",
        @"WAG", @"WCH", @"WEL", @"WIN", @"WMB", @"WRW"
    };
    static unsigned int const NUM_CAMPUS_BUILDINGS = 78;     // change as necessary
    
    NSMutableDictionary *out = [[NSMutableDictionary alloc] initWithCapacity : NUM_CAMPUS_BUILDINGS];
    for (int i = 0; i < NUM_CAMPUS_BUILDINGS; i++) {
        [out setValue : [NSNumber numberWithInt : i] forKey : CAMPUS_BUILDINGS[i]];
    }
    
    return out;
}




int const DAYS_IN_MONTH[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
NSString *const DAYS_OF_WEEK_LONG[] = { @"", @"MONDAY", @"TUESDAY", @"WEDNESDAY", @"THURSDAY", @"FRIDAY", @"SATURDAY", @"SUNDAY" };
NSString *const DAYS_OF_WEEK_SHORT[] = { @"", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", @"SUN" };
int const DAYS_OF_WEEK_ARR_LENGTH = 8;

NSString *const DEPARTMENTS[] = {
    @"ACC", @"ACF", @"ADV", @"ASE", @"AFR", @"AFS", @"ASL", @"AMS", @"AHC", @"ANT", @"ALD", @"ARA", @"ARE", @"ARI", @"ARC", @"AED", @"ARH", @"AAS", @"ANS", @"AST",
    @"BSN", @"BCH", @"BIO", @"BME", @"BDP", @"B A", @"BGS",
    @"CHE", @"CH", @"CHI", @"C E", @"CLA", @"C C", @"CGS", @"CSD", @"COM", @"CMS", @"CRP", @"C L", @"CSE", @"C S", @"CON", @"CTI", @"CRW",
    @"EDC", @"CZ", @"DAN", @"DES", @"DEV", @"D B", @"DRS", @"DCH",
    @"ECO", @"EDA", @"EDP", @"E E", @"EER", @"ENM", @"E M", @"E S", @"E", @"ESL", @"ENS", @"EVS", @"EUP", @"EUS",
    @"FIN", @"F A", @"FLU", @"FLE", @"FR", @"F H",
    @"G E", @"GRG", @"GEO", @"GER", @"GSD", @"GOV", @"GRS", @"GK", @"GUI",
    @"HAR", @"H S", @"HED", @"HEB", @"HIN", @"HIS", @"HDF", @"HDO", @"HMN",
    @"ILA", @"LAL", @"INF", @"I B", @"IRG", @"ISL", @"ITL", @"ITC",
    @"JPN", @"J S", @"J",
    @"KIN", @"KOR", @"LAR",
    @"LAT", @"LAS", @"LAW", @"LEB", @"L A", @"LAH", @"LIN",
    @"MAL", @"MAN", @"MIS", @"MFG", @"MNS", @"MKT", @"MSE", @"M", @"M E", @"MDV", @"MAS", @"MEL", @"MES", @"M S", @"MOL", @"MUS", @"MBU", @"MRT",
    @"NSC", @"N S", @"NEU", @"NOR", @"N", @"NTR",
    @"OBO", @"OPR", @"O M", @"ORI", @"ORG",
    @"PER", @"PRS", @"PGE", @"PHR", @"PGS", @"PHL", @"PED", @"P S", @"PHY", @"PIA", @"POL", @"POR", @"PRC", @"PSY", @"P A", @"PBH", @"P R",
    @"RTF", @"R E", @"R S", @"RHE", @"R M", @"REE", @"RUS",
    @"SAN", @"SAX", @"STC", @"STM", @"SCI", @"S C", @"SEL", @"S S", @"S W", @"SOC", @"SPN", @"SPC", @"SED", @"STA", @"SDS", @"ART", @"SWE",
    @"TAM", @"TEL", @"TXA", @"T D", @"TRO", @"TRU", @"TBA", @"TUR", @"T C",
    @"UGS", @"URB", @"URD", @"UTL", @"UTS",
    @"VIA", @"VIO", @"V C", @"VAS", @"VOI",
    @"WGS", @"WRT",
    @"YID", @"YOR"
};

NSString *const IGNORE_ROOMS[] = { @"UTCS", @"AI", @"Alumni", @"Ambassador", @"Holiday", @"Party", @"Tailgate", @"Colloquia", @"Colloquium" };
int const IGNORE_ROOMS_LENGTH = 9;

NSString *const MONTHS_LONG[] = {
    @"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"
};

NSString *const MONTHS_SHORT[] = {
    @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"
};

/*
 * Ignored rooms (room num, room type, capacity)
 * 	1.210	Telepresence Room	10
 * 	2.100	Atrium (Main)	?
 * 	3.100	Atrium Bridge	18
 * 	4.100	Atrium Bridge	18
 * 	4.202	Lounge (Graduate)	?
 * 	4.314	?	?
 * 	5.100	Atrium Bridge	12
 * 	6.100	Atrium Bridge	12
 * 	6.302	Lounge (Faculty)	70
 */
NSString *const VALID_GDC_ROOMS[] = {
    @"1.304", @"1.406",
    @"2.104", @"2.21", @"2.216", @"2.402", @"2.41", @"2.502", @"2.506", @"2.712", @"2.902",
    @"3.416", @"3.516", @"3.816", @"3.828",
    @"4.202", @"4.302", @"4.304", @"4.314", @"4.416", @"4.516", @"4.816", @"4.828",
    @"5.302", @"5.304", @"5.416", @"5.516", @"5.816", @"5.828",
    @"6.202", @"6.302", @"6.416", @"6.516", @"6.816", @"6.828",
    @"7.514", @"7.808", @"7.820"
};

//NSString *const VALID_GDC_ROOMS_TYPES[] = {
//    CLASS, CLASS,
//	CONFERENCE, CLASS, LECTURE_HALL, LAB, CLASS, CLASS, LAB, CONFERENCE, CONFERENCE,
//	CONFERENCE, SEMINAR, SEMINAR, CONFERENCE,
//	LOUNGE, CLASS, SEMINAR, CONFERENCE, CONFERENCE, SEMINAR, SEMINAR, LOBBY,
//	CLASS, LAB, CONFERENCE, SEMINAR, SEMINAR, LOBBY,
//	SEMINAR, LOUNGE, CONFERENCE, SEMINAR, SEMINAR, LOBBY,
//	CONFERENCE, CONFERENCE, LOBBY
//};

NSString *const VALID_GDC_ROOMS_TYPES[] = {
    @"class", @"class",
    @"conference", @"class", @"lecture_hall", @"lab", @"class", @"class", @"lab", @"conference", @"conference",
    @"conference", @"seminar", @"seminar", @"conference",
    @"lounge", @"class", @"seminar", @"conference", @"conference", @"seminar", @"seminar", @"lobby",
    @"class", @"lab", @"conference", @"seminar", @"seminar", @"lobby",
    @"seminar", @"lounge", @"conference", @"seminar", @"seminar", @"lobby",
    @"conference", @"conference", @"lobby"
};

/* UNKNOWN:
 * 	- 4.202
 * 	- 4.314
 * 	- 7.514
 * 	- 7.808 */
int const VALID_GDC_ROOMS_CAPACITIES[] = {
    81, 34,
    20, 34, 198, 20, 28, 24, 27, 10, 12,
    8, 18, 14, 8,
    35, 48, 48, 8, 8, 18, 14, 8,
    62, 24, 8, 18, 14, 8,
    35, 70, 8, 18, 18, 8,
    8, 8, 8
};

bool const VALID_GDC_ROOMS_POWERS[] = {
    false, false,
    false, false, false, true, true, true, true, false, false,
    false, false, false, false,
    false, false, false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false
};

int const NUM_VALID_GDC_ROOMS = 38;


@end





