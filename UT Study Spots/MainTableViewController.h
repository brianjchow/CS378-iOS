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
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

@interface MainTableViewController : UITableViewController

- (void) setUpButtonUI : (UIButton *) button;
- (void) didSelectButton : (UIButton *) button withTitle : (NSString *) title;
- (NSArray *) getSemesterBoundsBasedOnCurrentDate;

@end

#endif
