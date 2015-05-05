//
//  AppDelegate.m
//  UT Study Spots
//
//  Created by Fatass on 3/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"

#import "Constants.h"

static NSString* const storyboardMainID = @"Main";

//Drawers
static NSString* const leftDrawerStoryboardID = @"LeftDrawerTableViewControllerStoryboardID";

//Centers
static NSString* const findRoomNowStoryboardID = @"FindRoomNowViewControllerStoryboardID";
//static NSString* const findRoomLaterStoryboardID = @"FindRoomLaterViewControllerStoryboardID";
//static NSString* const findRoomRandomStoryboardID = @"FindRoomRandomViewControllerStoryboardID";
static NSString* const scheduleStoryboardID = @"ScheduleViewControllerStoryboardID";
static NSString* const loadViewStoryBoardID = @"LoadViewControllerStoryboardID";

@interface AppDelegate ()

@property (nonatomic, strong, readonly) UIStoryboard *mainStoryboard;


@end


@implementation AppDelegate

@synthesize mainStoryboard = _mainStoryboard;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [Constants init];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerViewController;
//    self.window.rootViewController = self.loadViewController;
    [self configureDrawerViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configureDrawerViewController{
    self.drawerViewController.leftViewController = self.leftDrawerTableViewController;
    self.drawerViewController.centerViewController = self.findRoomNowViewController;
    
    
    self.drawerViewController.animator = self.drawerAnimator;

    [self.drawerViewController setBackgroundImage:[UIImage imageNamed:@"drawerBackgroundImage"]];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Storyboard
- (UIStoryboard *)mainStoryboard{
    
    if(!_mainStoryboard){
        _mainStoryboard = [UIStoryboard storyboardWithName:storyboardMainID bundle: nil];
    }
    return _mainStoryboard;
}


#pragma mark Drawer View Controller
- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];

    }
    
    return _drawerViewController;
}

#pragma mark LoadView
- (UIViewController *)loadViewController {
    if (!_loadViewController) {
        _loadViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:loadViewStoryBoardID];
    }
    return _loadViewController;
}

#pragma mark Sides

- (UITableViewController *)leftDrawerTableViewController {
    if (!_leftDrawerTableViewController) {
        _leftDrawerTableViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:leftDrawerStoryboardID];
    }
    return _leftDrawerTableViewController;
}

#pragma mark Centers

- (UIViewController *)findRoomNowViewController{
    if (!_findRoomNowViewController){
        _findRoomNowViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:findRoomNowStoryboardID];
    }
    return _findRoomNowViewController;
}

//- (UIViewController *)findRoomLaterViewController{
//    if (!_findRoomLaterViewController){
//        _findRoomLaterViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:findRoomLaterStoryboardID];
//    }
//    return _findRoomLaterViewController;
//}
//
//- (UIViewController *)findRoomRandomViewController{
//    if (!_findRoomRandomViewController){
//        _findRoomRandomViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:findRoomRandomStoryboardID];
//    }
//    return _findRoomRandomViewController;
//}

- (UIViewController *)scheduleViewController{
    if (!_scheduleViewController){
        _scheduleViewController = [self.mainStoryboard instantiateViewControllerWithIdentifier:scheduleStoryboardID];
    }
    return _scheduleViewController;
}


#pragma mark Animator
- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    return _drawerAnimator;
}


#pragma mark Global AppDelegates
+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideRight animated:animated completion:nil];
}

@end
