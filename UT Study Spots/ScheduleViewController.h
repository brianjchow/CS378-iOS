//
//  GetScheduleViewController.h
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *buildingButton;

@property (weak, nonatomic) IBOutlet UIButton *roomButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;


@property (weak, nonatomic) IBOutlet UIButton *searchButton;



- (IBAction)selectBuilding:(id)sender;
- (IBAction)selectRoom:(id)sender;
- (IBAction)selectDate:(id)sender;

@end
