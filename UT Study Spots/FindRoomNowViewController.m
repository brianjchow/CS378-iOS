//
//  FindRoomNowViewController.m
//  UT Study Spots
//
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "FindRoomNowViewController.h"
#import "AppDelegate.h"
#import "SearchResultsViewController.h"

#import "QueryRandomRoom.h"
#import "Utilities.h"

@interface FindRoomNowViewController ()

@property (strong, nonatomic) QueryRandomRoom *query;

@end

@implementation FindRoomNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.query = [[QueryRandomRoom alloc] initWithStartDate:[Utilities get_date]];
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"toSearchResults"]) {
        
        SearchResultsViewController *dest = [segue destinationViewController];
        
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)actionToggleRightDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
}


@end
