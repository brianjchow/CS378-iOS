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

- (IBAction)selectBuilding:(id)sender;
- (IBAction)selectRoom:(id)sender;
- (IBAction)selectDate:(id)sender;

- (IBAction)execSearch:(id)sender;

@end
