//
//  FindRoomNowViewController.h
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainTableViewController.h"

@interface FindRoomNowViewController : MainTableViewController

@property (weak, nonatomic) IBOutlet UIButton *buildingButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *durationButton;
@property (weak, nonatomic) IBOutlet UIButton *capacityButton;
@property (weak, nonatomic) IBOutlet UIButton *powerButton;

@property (weak, nonatomic) IBOutlet UIButton *execSearchButton;

- (IBAction)selectBuilding:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)selectTime:(id)sender;
- (IBAction)selectDuration:(id)sender;
- (IBAction)selectCapacity:(id)sender;
- (IBAction)selectPower:(id)sender;

@end
