//
//  LeftDrawerTableViewController.m
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "LeftDrawerTableViewController.h"
#import "JVFloatingDrawerViewController.h"
#import "LeftDrawerTableViewCell.h"
#import "AppDelegate.h"

enum {
    FindRoomNowIndex    = 0,
    FindRoomLaterIndex  = 1,
    FindRoomRandomIndex = 2,
    ScheduleIndex       = 3
};

static NSString *const leftDrawerCellID = @"LeftDrawerReusableCellID";
static const CGFloat TableViewTopInset = 80.0;

@interface LeftDrawerTableViewController ()

@end

@implementation LeftDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(TableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:FindRoomNowIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftDrawerCellID forIndexPath:indexPath];
    

    switch(indexPath.row){
            
        case FindRoomNowIndex:
            cell.titleText = @"Find Room Now";
            cell.iconImage = [UIImage imageNamed:@"RoomNow"];
            break;
            
        case FindRoomLaterIndex:
            cell.titleText = @"Find Room Later";
            cell.iconImage = [UIImage imageNamed:@"RoomLater"];
            break;
            
        case FindRoomRandomIndex:
            cell.titleText = @"Find Random Room";
            cell.iconImage = [UIImage imageNamed:@"RoomRandom"];
            break;
            
        case ScheduleIndex:
            cell.titleText = @"Room Schedules";
            cell.iconImage = [UIImage imageNamed:@"RoomSchedule"];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationViewController = nil;
    
    if(indexPath.row == FindRoomNowIndex) {
        destinationViewController = [[AppDelegate globalDelegate] findRoomNowViewController];
    } else if(indexPath.row == FindRoomLaterIndex) {
        destinationViewController = [[AppDelegate globalDelegate] findRoomLaterViewController];
    } else if(indexPath.row == FindRoomRandomIndex) {
        destinationViewController = [[AppDelegate globalDelegate] findRoomRandomViewController];
    } else {
        destinationViewController = [[AppDelegate globalDelegate] scheduleViewController];
    }
    
    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
@end
