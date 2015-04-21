//
//  GetScheduleViewController.h
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *buildingTextField;

@property (weak, nonatomic) IBOutlet UITextField *roomTextField;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

- (IBAction)selectBuilding:(id)sender;
- (IBAction)selectRoom:(id)sender;
- (IBAction)selectDate:(id)sender;

@end
