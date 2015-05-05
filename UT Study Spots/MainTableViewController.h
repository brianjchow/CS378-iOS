//
//  MainTableViewController.h
//  UT Study Spots
//
//  Created by Fatass on 4/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#ifndef UT_Study_Spots_MainTableViewController_h
#define UT_Study_Spots_MainTableViewController_h

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import <ActionSheetDatePicker.h>
#import <ActionSheetStringPicker.h>

#import "Building.h"
#import "Constants.h"
#import "NSArray+Tools.h"
#import "NSString+Tools.h"
#import "Query.h"
#import "QueryRandomRoom.h"
#import "QueryRoomSchedule.h"
#import "QueryResult.h"
#import "SearchResultsViewController.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const FIND_ROOM_SEGUE_ID = @"findRoomViewSegue";
static NSString *const GET_ROOM_SCHEDULE_SEGUE_ID = @"getRoomScheduleViewSegue";

@interface MainTableViewController : UITableViewController

- (void) setUpButtonUI : (UIButton *) button;
- (void) didSelectButton : (UIButton *) button withTitle : (NSString *) title;
- (NSArray *) getSemesterBoundsBasedOnCurrentDate;

//- (void) selectBuildingButton : (NSString *) title;
//- (void) selectDateButton : (NSString *) title;
//- (void) selectTimeButton : (NSString *) title;
//- (void) selectRoomButton : (NSString *) title;
//- (void) selectDurationButton : (NSString *) title;
//- (void) selectCapacityButton : (NSString *) title;
//- (void) selectPowerButton : (NSString *) title;

@end

#endif
