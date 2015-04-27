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

@end

@implementation FindRoomNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self setUpButtonUI : self.buildingButton];
    [self setUpButtonUI : self.dateButton];
    [self setUpButtonUI : self.timeButton];
    [self setUpButtonUI : self.durationButton];
    [self setUpButtonUI : self.powerButton];
    
    self.query = [[QueryRandomRoom alloc] initWithStartDate:[Utilities get_date]];
    
    self.campus_buildings = [CAMPUS_BUILDINGS_FULLY_QUALIFIED sort_ascending];
    
    [self setupDurationsArray];
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
        NSLog(@"Changing alignment to left alignment");
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [button sizeToFit];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    //Locality for Desired Format of Date
    NSLocale *localityForTimeFormat = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    //Determines what dates should be formatted as
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMMYYY" options:0 locale:localityForTimeFormat];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    [self didSelectButton:self.dateButton withTitle:[dateFormatter stringFromDate:selectedDate]];
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
        
        [self didSelectButton:self.buildingButton withTitle:self.campus_buildings[selectedIndex]];
        
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
}

- (IBAction)selectTime:(UIControl *)sender {
}

- (IBAction)selectDuration:(UIControl *)sender {
    ActionStringDoneBlock doneBlock = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
//        [self didSelectButton:self.durationButton withTitle:self.durations[selectedIndex]];
        
        NSLog(@"Selected duration %d", [self.durations[selectedIndex] intValue]);
        
        [self.query set_duration : [self.durations[selectedIndex] intValue]];
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

- (IBAction)selectPower:(UIControl *)sender {
    
}

- (IBAction)execSearch:(id)sender {
    
}

@end
