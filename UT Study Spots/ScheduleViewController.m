//
//  GetScheduleViewController.m
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "ScheduleViewController.h"

#import <ActionSheetDatePicker.h>
#import <ActionSheetStringPicker.h>
#import "AppDelegate.h"

#import "Building.h"
#import "Constants.h"
#import "NSString+Tools.h"
#import "Query.h"
#import "QueryRoomSchedule.h"
#import "QueryResult.h"
#import "Utilities.h"

// http://stackoverflow.com/questions/12002905/ios-build-fails-with-cocoapods-cannot-find-header-files

@interface ScheduleViewController ()

@property (strong, nonatomic) QueryRoomSchedule *query;
@property (strong, nonatomic) NSArray *rooms;

@property (strong, nonatomic) NSArray *campus_buildings;

@end

@implementation ScheduleViewController

- (NSArray *) sort : (NSArray *) array {
    return ([array sortedArrayUsingSelector : @selector(localizedCaseInsensitiveCompare : )]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.query = [[QueryRoomSchedule alloc] init];
    [self update_rooms_arr];
    
    self.campus_buildings = [self sort : CAMPUS_BUILDINGS_FULLY_QUALIFIED];
    
//    NSLog(@"\n\n%@\n\n", self.campus_buildings);
    
}

- (void) update_rooms_arr {
    NSString *no_rooms_found = @"No rooms found.";
    
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
            self.rooms = [self sort : [roomset array]];
            
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
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Select a Building"
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
        
        [self.query set_option_search_room : self.rooms[selectedIndex]];
    };
    ActionStringCancelBlock cancelBlock = ^(ActionSheetStringPicker *picker) {
        
    };
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Select a Room"
                                                                                rows : self.rooms
                                                                    initialSelection : 0
                                                                           doneBlock : doneBlock
                                                                         cancelBlock : cancelBlock
                                                                              origin : sender];
    
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
};

- (IBAction)selectDate:(UIControl *)sender {
}
@end
