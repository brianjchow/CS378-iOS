//
//  FindRoomNowViewController.m
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "FindRoomNowViewController.h"

@interface FindRoomNowViewController ()

@property (strong, nonatomic) QueryRandomRoom *query;

@property (strong, nonatomic) NSArray *campus_buildings;
@property (strong, nonatomic) NSArray *durations;
@property (strong, nonatomic) NSArray *capacities;

@end

@implementation FindRoomNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    if ([Utilities is_null : self.query]) {
        self.query = [[QueryRandomRoom alloc] initWithStartDate : [Utilities get_date]];
    }
    
    [self setUpButtonUI : self.buildingButton];
    [self setUpButtonUI : self.dateButton];
    [self setUpButtonUI : self.timeButton];
    [self setUpButtonUI : self.durationButton];
    [self setUpButtonUI : self.capacityButton];
    [self setUpButtonUI : self.powerButton];
    
    [self setUpButtonUI : self.execSearchButton];
    
    [self didSelectButton : self.buildingButton
                withTitle : [NSString stringWithFormat : @"Building:\t%@", [self.query get_option_search_building]]];
    
    [self didSelectButton : self.dateButton
                withTitle : [NSString stringWithFormat : @"Start date:\t%@", [Utilities get_time_with_format : [self.query get_start_date] format : @"EEE, MMM dd, yyyy"]]];
    
    [self didSelectButton : self.timeButton
                withTitle : [NSString stringWithFormat : @"Start time:\t%@", [Utilities get_time_with_format : [self.query get_start_date] format : @"h:mm a"]]];
    
    [self didSelectButton : self.durationButton
                withTitle : [NSString stringWithFormat : @"Duration:\t%d minute(s)", [self.query get_duration]]];
    
    if ([self.query get_option_capacity] == 0) {
        [self didSelectButton : self.capacityButton
                    withTitle : @"Capacity:\t0 people (no preference)"];
    }
    else {
        [self didSelectButton : self.capacityButton
                    withTitle : [NSString stringWithFormat : @"Capacity:\t%d people", [self.query get_option_capacity]]];
    }
    
    if ([[self.query get_option_search_building] is_gdc]) {
        [self didSelectButton : self.powerButton
                    withTitle : [NSString stringWithFormat : @"Power:\t\t%@", BOOL_STRS[[self.query get_option_power]]]];
    }
    else {
        [self didSelectButton : self.powerButton
                    withTitle : @"Power:\tfalse"];
    }
    
    if ([Utilities is_null : self.campus_buildings]) {
        self.campus_buildings = [CAMPUS_BUILDINGS_FULLY_QUALIFIED sort_ascending];
    }
    if ([Utilities is_null : self.durations]) {
        [self setupDurationsArray];
    }
    if ([Utilities is_null : self.capacities]) {
        [self setupCapacitiesArray];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupDurationsArray {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity : MINUTES_IN_DAY];
    for (int i = 1; i < MINUTES_IN_DAY; i++) {
        temp[i - 1] = [NSNumber numberWithInt : i];
    }
    
    self.durations = temp;
}

- (void) setupCapacitiesArray {
    NSInteger max_capacity = 500;
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity : max_capacity];
    temp[0] = @"0 (no preference)";
    for (NSInteger i = 1; i < max_capacity; i++) {
        temp[i] = [NSNumber numberWithInteger : i];
    }
    
    self.capacities = temp;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setUpButtonUI:(UIButton *) button {
    
    [button.layer setCornerRadius:5.0f];
    button.layer.borderWidth = 1;
    [button.layer setBorderColor:[UIColor colorWithRed:34.0f/255.0f green:128.0f/255.0f blue:207.0f/255.0f alpha:1].CGColor];
}

- (void) didSelectButton:(UIButton *) button withTitle:(NSString *) title {
    [button setTitle:title forState:UIControlStateNormal];
    
    if(button.contentHorizontalAlignment != UIControlContentHorizontalAlignmentLeft){
//        NSLog(@"Changing alignment to left alignment");
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [button sizeToFit];
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
    
    //    NSLog(@"Picked date %@", selected_date);
    
    [self didSelectButton:self.dateButton withTitle : [NSString stringWithFormat : @"Start date:\t%@", selected_date]];
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
//        [self update_rooms_arr];
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

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    
//    NSString *selected_time_str = [dateFormatter stringFromDate : selectedTime];
//    NSLog(@"Selected time %@", selected_time_str);
    
    NSString *hour_str = [Utilities get_time_with_format : selectedTime format : @"HH"];
    NSString *min_str = [Utilities get_time_with_format : selectedTime format : @"mm"];
    
    NSInteger hour = [hour_str integerValue];
    NSInteger min = [min_str integerValue];
    
//    NSLog(@"Hour: %@\tMinute: %@", hour_str, min_str);
//    NSLog(@"Hour: %ld\tMinute: %ld", hour, min);
    
    [self.query set_start_time : hour minute : min];
    
    [self didSelectButton : self.timeButton
                withTitle : [NSString stringWithFormat : @"Start time:\t%@", [Utilities get_time_with_format : [self.query get_start_date] format : @"hh:mm a"]]];
    
    NSLog(@"Query is now\n%@", [self.query toString]);
}

- (IBAction)selectTime:(UIControl *)sender {
    NSInteger minute_interval = 1;  // 5;
    
    // clamp date
    NSDate *curr_start_date = [self.query get_start_date];
//    NSInteger reference_time_interval = (NSInteger) [curr_start_date timeIntervalSinceReferenceDate];
//    NSInteger remaining_seconds = reference_time_interval % (minute_interval * 60);
//    NSInteger time_rounded_to_5_minutes = reference_time_interval - remaining_seconds;
//    
//    // round up
//    if (remaining_seconds > ((minute_interval * 60) / 2)) {
//        time_rounded_to_5_minutes = reference_time_interval + ((minute_interval * 60) - remaining_seconds);
//    }
//    
//    NSDate *selected_time = [NSDate dateWithTimeIntervalSinceReferenceDate : (NSTimeInterval) time_rounded_to_5_minutes];
    
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle : @"Time"
                                                                  datePickerMode : UIDatePickerModeTime
                                                                    selectedDate : curr_start_date // selected_time
                                                                          target : self
                                                                          action : @selector(timeWasSelected : element : )
                                                                          origin : sender];
    
    picker.minuteInterval = minute_interval;
    [picker showActionSheetPicker];
}

- (IBAction)selectDuration:(UIControl *)sender {
    ActionStringDoneBlock doneBlock = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        int selected_value = [self.durations[selectedIndex] intValue];
        
        NSLog(@"Selected duration %d", selected_value);
        
        [self didSelectButton : self.durationButton withTitle : [NSString stringWithFormat : @"Duration:\t%d minute(s)", selected_value]];
        
        [self.query set_duration : selected_value];
    };
    ActionStringCancelBlock cancelBlock = ^(ActionSheetStringPicker *picker) {
        
    };
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Duration (minutes)"
                                                                                rows : self.durations
                                                                    initialSelection : [self.query get_duration] - 1
                                                                           doneBlock : doneBlock
                                                                         cancelBlock : cancelBlock
                                                                              origin : sender];
    
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
}

- (IBAction)selectCapacity:(UIControl *)sender {
    ActionStringDoneBlock doneBlock = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        int selected_capacity;
        
        if (selectedIndex == 0) {
            selected_capacity = 0;
            
            [self didSelectButton : self.capacityButton withTitle : @"Capacity:\t0 people (no preference)"];
        }
        else {
            selected_capacity = [self.capacities[selectedIndex] intValue];
            
            [self didSelectButton : self.capacityButton withTitle : [NSString stringWithFormat : @"Capacity:\t%d people", selected_capacity]];
        }
        
        NSLog(@"Selected capacity %d", selected_capacity);
        
        [self.query set_option_capacity : selected_capacity];
    };
    ActionStringCancelBlock cancelBlock = ^(ActionSheetStringPicker *picker) {
        
    };
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Capacity"
                                                                                rows : self.capacities
                                                                    initialSelection : [self.query get_option_power]
                                                                           doneBlock : doneBlock
                                                                         cancelBlock : cancelBlock
                                                                              origin : sender];
    
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
}

- (IBAction)selectPower:(UIControl *)sender {
    bool is_gdc = [[self.query get_option_search_building] is_gdc];
    NSArray *vals;
    
    if (is_gdc) {
        vals = @[@"No", @"Yes"];
    }
    else {
        vals = @[@"No"];
        
        [self.query set_option_power : false];      // no data for non-GDC buildings
    }
    
    ActionStringDoneBlock doneBlock = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        bool selected_val = [vals[selectedIndex] boolValue];
        NSLog(@"Selected power option %d", selected_val);
        
        [self didSelectButton : self.powerButton withTitle : [NSString stringWithFormat : @"Power:\t\t%@", BOOL_STRS[selected_val]]];
        
        [self.query set_option_power : selected_val];
    };
    ActionStringCancelBlock cancelBlock = ^(ActionSheetStringPicker *picker) {
        
    };
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Power"
                                                                                rows : vals
                                                                    initialSelection : [self.query get_option_power]
                                                                           doneBlock : doneBlock
                                                                         cancelBlock : cancelBlock
                                                                              origin : sender];
    
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
}

- (void) prepareForSegue : (UIStoryboardSegue *) segue sender : (id) sender {
    
    NSLog(@"Entered prepareForSegue, FindRoomNowViewController.m");
    
    if ([segue.identifier isEqualToString : FIND_ROOM_SEGUE_ID] &&
        [segue.destinationViewController isKindOfClass : [SearchResultsViewController class]]) {
        
        QueryResult *query_result = [self.query search];
        
        NSLog(@"Results\n%@", [query_result toString]);
        
        SearchResultsViewController *search_results_vc = (SearchResultsViewController *) segue.destinationViewController;
        [search_results_vc set_query_result : self.query query_result : query_result];
        
        UIBarButtonItem *back_button = [[UIBarButtonItem alloc] initWithTitle : @"Back"
                                                                    style : UIBarButtonItemStylePlain
                                                                   target : nil
                                                                   action : nil];
        
        self.navigationItem.backBarButtonItem = back_button;
    }

}

@end
