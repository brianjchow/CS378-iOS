//
//  SearchResultsViewController.m
//  UT Study Spots
//
//  Created by Thien Vo on 4/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "PhotoScrollViewController.h"

static NSString *const PHOTO_SV_SEGUE_ID = @"photoScrollViewSegue";

@interface SearchResultsViewController ()

@property (strong, nonatomic, readwrite) Query *query;
@property (strong, nonatomic, readwrite) QueryResult *query_result;
//@property (strong, nonatomic, readwrite) NSString *curr_room_in_focus;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.queryDetailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.queryDetailsLabel.numberOfLines = 0;
    
    if ([Utilities is_null : self.query]) {
        // TODO - throw IAException ?????
    }
    if ([Utilities is_null : self.query_result]) {
        // TODO - throw IAException ?????
        
        self.query_result = [[QueryResult alloc] init : UNKNOWN
                                   search_status : SEARCH_ERROR
                                   building_name : @"Unknown"
                                         results : @[NO_ROOMS_FOUND]];
        
        self.curr_room_in_focus = [self.query_result get_random_room];
    }
    
    SearchType search_type = [self.query_result get_search_type];
    
    if (search_type == RANDOM_ROOM) {
        [self handle_search_find_room];
    }
    else if (search_type == ROOM_SCHEDULE) {
        NSLog(@"Entering room schedule handler");
        [self handle_search_get_room_schedule];
    }
    else {
        self.headerLabel.text = @"crap";
    }
}

- (void) handle_search_find_room {
    self.curr_room_in_focus = [self.query_result get_random_room];
    self.headerLabel.text = [NSString stringWithFormat : @"%@ %@", [self.query_result get_building_name], self.curr_room_in_focus];
    
    NSString *TAB = @"    ";
    NSMutableString *msg = [[NSMutableString alloc] init];
    
    SearchStatus search_status = [self.query_result get_search_status];
    
    if (search_status == SEARCH_ERROR) {
        [msg appendString : @"We're not sure why this is happening, but shoot us an email containing the information below and we'll get it fixed. Thanks!\n\n"];
    }
    else {
        NSArray *results = [self.query_result get_results];     // of String
        
        if ([results count] == 1) {
            [msg appendString : @"Search found one room available.\n\n"];
        }
        else {
            [msg appendFormat : @"Search found %lu rooms available.\n\n", [results count]];
        }
        
        if (search_status == HOLIDAY) {
            [msg appendFormat : @"%@\n\n", SEARCH_STATUS_STRINGS[HOLIDAY]];
        }
        else if (search_status == SUMMER) {
            [msg appendFormat : @"%@\n\n", SEARCH_STATUS_STRINGS[SUMMER]];
        }
        
        if (!SHORT_CIRCUIT_SEARCH_FOR_ROOM) {
            if ([Utilities date_is_during_weekend : [self.query get_start_date]]) {
                [msg appendString : @"NOTE: search occurs partly through or during the weekend; you may not be able to enter without appropriate authorization.\n\n"];
            }
            else if ([Utilities search_is_at_night : [self.query get_start_date] end : [self.query get_end_date]]) {
                [msg appendString : @"NOTE: search occurs partly through or during after-hours; you may not be able to enter without appropriate authorization.\n\n"];
            }
        }
        
        NSString *search_building = [self.query get_option_search_building];
        int capacity = [self.query get_option_capacity];
        
        [msg appendString : @"Search criteria:\n"];
        [msg appendFormat : @"%@Building: %@\n", TAB, search_building];
        [msg appendFormat : @"%@Start date: %@\n", TAB, [[self.query get_start_date] toString]];
        [msg appendFormat : @"%@Duration: at least %d minute(s)\n", TAB, [self.query get_duration]];
        
        if (capacity > 0) {
            [msg appendFormat : @"%@Capacity: at least %d people\n", TAB, capacity];
        }
        else {
            [msg appendFormat : @"%@Capacity: no preference\n", TAB];
        }
        
        if ([search_building is_gdc]) {
            bool must_have_power = [self.query get_option_power];
            NSString *choice = @"no";
            if (must_have_power) {
                choice = @"yes";
            }
            
            [msg appendFormat : @"%@Must have power plugs: %@\n", TAB, BOOL_STRS[must_have_power]];
        }
        
        [msg appendString : @"\n"];
        [msg appendString : @"All rooms available under identical search criteria below."];
    }
    
    self.queryDetailsLabel.text = msg;
}

- (void) handle_search_get_room_schedule {
    self.headerLabel.text = [NSString stringWithFormat : @"%@ %@", [self.query_result get_building_name], self.curr_room_in_focus];
    
    Room *search_room;
    
    NSString *search_building_str = [self.query get_option_search_building];
    NSString *curr_course_schedule = [Utilities get_current_course_schedule : [Utilities get_date]];
    
    Building *search_building = [Building get_instance : search_building_str db_filename : curr_course_schedule];
    search_room = [search_building get_room : [self.query get_option_search_room]];
    
    if ([Utilities is_null : search_room]) {
        // TODO - throw ISException
    }
    
    int capacity = [search_room get_capacity];
    NSArray *events = [self.query_result get_results];
    
    NSMutableString *msg = [NSMutableString new];
    
    if ([search_building_str is_gdc]) {
        [msg appendFormat : @"Room type: %@\n", [search_room get_type]];
        [msg appendFormat : @"Capacity: %d people\n", capacity];
        [msg appendFormat : @"Power plugs: %@\n", BOOL_STRS[[search_room get_has_power]]];
        [msg appendString : @"\n"];
    }
    else {
        if (capacity > 0) {
            [msg appendFormat : @"Capacity: %d people\n", capacity];
        }
        else {
            [msg appendString : @"Capacity: unknown\n"];
        }
        [msg appendString : @"\n"];
    }
    
    NSString *date_str = [Utilities get_time_with_format : [self.query get_start_date] format : @"EEE, MMM dd, yyyy"];
    if ([events count] <= 0) {
        [msg appendFormat : @"There are no events scheduled on %@.\n\n", date_str];
    }
    else if ([events count] == 1) {
        [msg appendFormat : @"There is one event scheduled on %@.\n\n", date_str];
    }
    else {
        [msg appendFormat : @"There are %lu events scheduled on %@.\n\n", [events count], date_str];
    }
    
    if ([curr_course_schedule equals : SEARCH_STATUS_STRINGS[HOLIDAY]]) {
        [msg appendFormat : @"%@\n\n", SEARCH_STATUS_STRINGS[HOLIDAY]];
    }
    else if ([curr_course_schedule equals : SEARCH_STATUS_STRINGS[SUMMER]]) {
        [msg appendFormat : @"%@\n\n", SEARCH_STATUS_STRINGS[SUMMER]];
    }
    
    self.queryDetailsLabel.text = msg;
    
    NSLog(@"Message for room schedule handler is\n%@", msg);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// DO NOT CALL THIS METHOD ANYWHERE INSIDE THIS CLASS
- (void) set_query_result : (Query *) query query_result : (QueryResult *) query_result {
    if ([Utilities is_null : query]) {
        // TODO - throw iAException
    }
    if ([Utilities is_null : query_result]) {
        // TODO - throw IAException ?????
        
        query_result = [[QueryResult alloc] init : UNKNOWN
                                   search_status : SEARCH_ERROR
                                   building_name : @"Unknown"
                                         results : @[NO_ROOMS_FOUND]];
        
        self.curr_room_in_focus = [self.query_result get_random_room];
    }
    
//    NSLog(@"QueryResult is\n%@", [query_result toString]);
    
    self.query = query;
    self.query_result = query_result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.query_result get_results] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = SEARCH_RESULTS_CELL_ID;
    
    SearchResultsTableViewCell *out = [tableView dequeueReusableCellWithIdentifier : ident];
    if (!out) {
        out = [[SearchResultsTableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle reuseIdentifier : ident];
    }

    NSString *result = [[self.query_result get_results] objectAtIndex : indexPath.row];
    NSDictionary *cell_contents = @{
                                    search_type_key : [NSNumber numberWithUnsignedInteger : [self.query_result get_search_type]],
                                    search_status_key : [NSNumber numberWithUnsignedInteger : [self.query_result get_search_status]],
                                    search_building_key : [self.query_result get_building_name],
                                    search_result_key : result
                                    };
    
    out.contents = cell_contents;
    return out;
}

- (void) prepareForSegue : (UIStoryboardSegue *) segue sender : (id) sender {
    NSLog(@"Entered prepareForSegue(), SearchResultsViewController.m");
    
    if ([self.query_result get_search_type] != RANDOM_ROOM) {
        return;
    }
    
    if ([segue.identifier isEqualToString : PHOTO_SV_SEGUE_ID] &&
        [segue.destinationViewController isKindOfClass : [PhotoScrollViewController class]] &&
        [self.query_result get_search_type] == RANDOM_ROOM) {
        
        SearchResultsTableViewCell *selected = sender;
        PhotoScrollViewController *psvc = (PhotoScrollViewController *) segue.destinationViewController;
        
        UIImage *image = selected.photo_thumb.image;
        if ([Utilities is_null : image]) {
            return;
        }
        
        psvc.image_title = [NSString stringWithFormat : @"%@ %@", selected.this_building_name, selected.this_room_num];
        psvc.image_name = [selected get_image_name];
        
        NSIndexPath *selected_row = [self.results_table_view indexPathForSelectedRow];
        [self.results_table_view deselectRowAtIndexPath : selected_row animated : YES];
        
        UIBarButtonItem *back_button = [[UIBarButtonItem alloc] initWithTitle : @"Back"
                                                                        style : UIBarButtonItemStylePlain
                                                                        target : nil
                                                                        action : nil];
        
        self.navigationItem.backBarButtonItem = back_button;
    }
}

//- (void) prepareForSegue : (UIStoryboardSegue *) segue sender : (id) sender {
//    
//    NSLog(@"Entered prepareForSegue, ScheduleViewController.m");
//    
//    if ([segue.identifier isEqualToString : GET_ROOM_SCHEDULE_SEGUE_ID] &&
//        [segue.destinationViewController isKindOfClass : [SearchResultsViewController class]]) {
//        
//        QueryResult *query_result = [self.query search];
//        
//        NSLog(@"Results\n%@", [query_result toString]);
//        
//        SearchResultsViewController *search_results_vc = (SearchResultsViewController *) segue.destinationViewController;
//        [search_results_vc set_query_result : self.query query_result : query_result];
//        search_results_vc.curr_room_in_focus = [self.query get_option_search_room];
//        
//        UIBarButtonItem *back_button = [[UIBarButtonItem alloc] initWithTitle : @"Back"
//                                                                        style : UIBarButtonItemStylePlain
//                                                                       target : nil
//                                                                       action : nil];
//        
//        self.navigationItem.backBarButtonItem = back_button;
//    }
//    
//}




@end
