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

#import "Constants.h"

// http://stackoverflow.com/questions/12002905/ios-build-fails-with-cocoapods-cannot-find-header-files

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    NSArray *buildings = [CAMPUS_BUILDINGS allKeys];
    buildings = [buildings sortedArrayUsingSelector : @selector(localizedCaseInsensitiveCompare : )];
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle : @"Select a building"
                                                                                rows : buildings
                                                                    initialSelection : 1
                                                                           doneBlock : nil
                                                                         cancelBlock : nil
                                                                              origin : sender];
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
}

- (IBAction)selectRoom:(UIControl *)sender {
}

- (IBAction)selectDate:(UIControl *)sender {
}
@end
