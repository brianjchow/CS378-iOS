//
//  AppDelegate.h
//  UT Study Spots
//
//  Created by Fatass on 3/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JVFloatingDrawerViewController;
@class JVFloatingDrawerSpringAnimator;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//Root View Controller
@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;

//Drawers
@property (nonatomic, strong) UITableViewController *leftDrawerTableViewController;


//Centers
@property (nonatomic, strong) UIViewController *findRoomNowViewController;
//@property (nonatomic, strong) UIViewController *findRoomLaterViewController;
//@property (nonatomic, strong) UIViewController *findRoomRandomViewController;
@property (nonatomic, strong) UIViewController *scheduleViewController;


//Animation for Drawer
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

//Transition functions
+ (AppDelegate *)globalDelegate;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated;

@end

