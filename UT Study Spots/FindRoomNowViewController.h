//
//  FindRoomNowViewController.h
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindRoomNowViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton *buildingButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *durationButton;
@property (weak, nonatomic) IBOutlet UIButton *powerButton;

- (IBAction)selectBuilding:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)selectTime:(id)sender;
- (IBAction)selectDuration:(id)sender;
- (IBAction)selectPower:(id)sender;

@end
