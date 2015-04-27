//
//  GetScheduleViewController.h
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainTableViewController.h"

@interface ScheduleViewController : MainTableViewController

@property (weak, nonatomic) IBOutlet UIButton *buildingButton;
@property (weak, nonatomic) IBOutlet UIButton *roomButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (weak, nonatomic) IBOutlet UIButton *execSearchButton;

- (IBAction)selectBuilding:(id)sender;
- (IBAction)selectRoom:(id)sender;
- (IBAction)selectDate:(id)sender;

@end
