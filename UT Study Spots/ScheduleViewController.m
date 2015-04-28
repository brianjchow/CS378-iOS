//
//  GetScheduleViewController.m
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "ScheduleViewController.h"

// http://stackoverflow.com/questions/12002905/ios-build-fails-with-cocoapods-cannot-find-header-files

@interface ScheduleViewController ()

@property (strong, nonatomic) QueryRoomSchedule *query;
@property (strong, nonatomic) NSArray *rooms;

@property (strong, nonatomic) NSArray *campus_buildings;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([Utilities is_null : self.query]) {
        self.query = [[QueryRoomSchedule alloc] init];
        [self update_rooms_arr];
    }
    
    //Set up ui
    [self setUpButtonUI:self.buildingButton];
    [self setUpButtonUI:self.roomButton];
    [self setUpButtonUI:self.dateButton];
    
    [self setUpButtonUI : self.execSearchButton];
    
    [self didSelectButton : self.buildingButton
                withTitle : [NSString stringWithFormat : @"Building:\t%@", [self.query get_option_search_building]]];
    
    [self didSelectButton : self.dateButton
                withTitle : [NSString stringWithFormat : @"Start date:\t%@", [Utilities get_time_with_format : [self.query get_start_date] format : @"EEE, MMM dd, yyyy"]]];
    
    if ([[self.query get_option_search_room] equals : RANDOM]) {
        [self didSelectButton : self.roomButton
                    withTitle : [NSString stringWithFormat : @"Room:\t\t%@", self.rooms[0]]];
        [self.query set_option_search_room : self.rooms[0]];
    }
    else {
        [self didSelectButton : self.roomButton
                    withTitle : [NSString stringWithFormat : @"Room:\t\t%@", [self.query get_option_search_room]]];
    }
    
    if ([Utilities is_null : self.campus_buildings]) {
        self.campus_buildings = [CAMPUS_BUILDINGS_FULLY_QUALIFIED sort_ascending];
    }
    
//    NSLog(@"\n\n%@\n\n", self.campus_buildings);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    //    //Locality for Desired Format of Date
    //    NSLocale *localityForTimeFormat = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //
    //    //Determines what dates should be formatted as
    //    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMMYYY" options:0 locale:localityForTimeFormat];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:formatString];
    //
    //    NSString *selected_date = [dateFormatter stringFromDate : selectedDate];
    
    NSString *selected_date = [Utilities get_time_with_format : selectedDate format : @"EEE, MMM dd, yyyy"];
    [self.query set_start_date : selectedDate];
    
    
    //    NSString *selected_month = [Utilities get_time_with_format : selectedDate format : @"MMM"];
    //    NSString *selected_day = [Utilities get_time_with_format : selectedDate format : @"dd"];
    //    NSString *selected_year = [Utilities get_time_with_format : selectedDate format : @"YYYY"];
    
    NSLog(@"In ScheduleViewController, selected date %@", selected_date);
    
    [self didSelectButton:self.dateButton withTitle : [NSString stringWithFormat : @"Start date:\t%@", selected_date]];
}

- (void) update_rooms_arr {
    NSString *no_rooms_found = NO_ROOMS_FOUND;
    
    NSString *search_building_str = [self.query get_option_search_building];
    
    NSString *curr_course_schedule = [Utilities get_current_course_schedule : [self.query get_start_date]];
    if (!curr_course_schedule) {
        self.rooms = @[ no_rooms_found ];
    }
    else {
        Building *search_building = [Building get_instance : search_building_str db_filename : curr_course_schedule];
        NSOrderedSet *roomset = [search_building get_keyset];
        
        if ([roomset count] <= 0) {
            self.rooms = @[ no_rooms_found];
        }
        else {
            self.rooms = [[roomset array] sort_ascending];
            
            if ([search_building_str is_gdc]) {
                
                NSMutableArray *temp = [self.rooms mutableCopy];
                
                int counter = 0;
                for (NSString *room_num in self.rooms) {
                    if ([room_num isEqualToString : @"2.21"]) {
                        temp[counter] = @"2.210";
                    }
                    
                    if ([room_num isEqualToString : @"2.41"]) {
                        temp[counter] = @"2.410";
                    }
                    
                    counter++;
                }
                
                self.rooms = temp;
            }
        }
    }
    
    [self didSelectButton : self.roomButton withTitle : [NSString stringWithFormat : @"Room:\t\t%@", self.rooms[0]]];
    [self.query set_option_search_room : self.rooms[0]];
}


#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)actionToggleRightDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
}


- (IBAction)selectBuilding:(UIControl *)sender {
    ActionStringDoneBlock doneBlock = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        NSLog(@"Picked building %@", self.campus_buildings[selectedIndex]);
        
        [self didSelectButton:self.buildingButton withTitle: [NSString stringWithFormat : @"Building:\t%@", self.campus_buildings[selectedIndex]]];
        
        [self.query set_option_search_building : self.campus_buildings[selectedIndex]];
        [self update_rooms_arr];
    };
    ActionStringCancelBlock cancelBlock = ^(ActionSheetStringPicker *picker) {
        
    };
    
    NSString *search_building = [self.query get_option_search_building];
    
    NSUInteger index = 0;
    for (int i = 0; i < [self.campus_buildings count]; i++) {
        if ([self.campus_buildings[i] containsIgnoreCase : search_building]) {
            index = i;
            break;
        }
    }
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Building"
                                                                                rows : self.campus_buildings
                                                                    initialSelection : index
                                                                           doneBlock : doneBlock
                                                                         cancelBlock : cancelBlock
                                                                              origin : sender];
    
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
}

- (IBAction)selectRoom:(UIControl *)sender {
    ActionStringDoneBlock doneBlock = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSLog(@"Picked room %@", self.rooms[selectedIndex]);
        
        [self didSelectButton:self.roomButton withTitle:[NSString stringWithFormat : @"Room:\t\t%@", self.rooms[selectedIndex]]];
        
        NSLog(@"Picked room %@", selectedValue);
        
        [self.query set_option_search_room : self.rooms[selectedIndex]];
    };
    ActionStringCancelBlock cancelBlock = ^(ActionSheetStringPicker *picker) {
        
    };
    
    NSString *curr_room = [self.query get_option_search_room];
    
    NSInteger start_index = 0;
    for (NSInteger i = 0; i < [self.rooms count]; i++) {
        if ([self.rooms[i] equals : curr_room]) {
            start_index = i;
            break;
        }
    }
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Room"
                                                                                rows : self.rooms
                                                                    initialSelection : start_index
                                                                           doneBlock : doneBlock
                                                                         cancelBlock : cancelBlock
                                                                              origin : sender];
    
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
};

- (IBAction)selectDate:(UIControl *)sender {
    NSArray *currentMaxMinDateArray = [self getSemesterBoundsBasedOnCurrentDate];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Date"
                                                                      datePickerMode:UIDatePickerModeDate
                                                                        selectedDate:currentMaxMinDateArray[0]
                                                                         minimumDate:currentMaxMinDateArray[1]
                                                                         maximumDate:currentMaxMinDateArray[2]
                                                                              target:self
                                                                              action:@selector(dateWasSelected:element:)
                                                                              origin:sender];
    
    datePicker.tapDismissAction = TapActionCancel;
    [datePicker showActionSheetPicker];
}

- (void) prepareForSegue : (UIStoryboardSegue *) segue sender : (id) sender {
    
    NSLog(@"Entered prepareForSegue, ScheduleViewController.m");
    
    if ([segue.identifier isEqualToString : GET_ROOM_SCHEDULE_SEGUE_ID] &&
        [segue.destinationViewController isKindOfClass : [SearchResultsViewController class]]) {
        
        QueryResult *query_result = [self.query search];
        
//        NSLog(@"Results\n%@", [query_result toString]);
        
        SearchResultsViewController *search_results_vc = (SearchResultsViewController *) segue.destinationViewController;
        [search_results_vc set_query_result : self.query query_result : query_result];
        search_results_vc.curr_room_in_focus = [self.query get_option_search_room];
        
        UIBarButtonItem *back_button = [[UIBarButtonItem alloc] initWithTitle : @"Back"
                                                                        style : UIBarButtonItemStylePlain
                                                                       target : nil
                                                                       action : nil];
        
        self.navigationItem.backBarButtonItem = back_button;
    }
    
}

@end
