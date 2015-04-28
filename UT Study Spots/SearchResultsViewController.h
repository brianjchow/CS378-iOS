//
//  SearchResultsViewController.h
//  UT Study Spots
//
//  Created by Thien Vo on 4/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchResultsTableViewCell.h"

#import "Building.h"
#import "Constants.h"
#import "NSString+Tools.h"
#import "QueryResult.h"
#import "Room.h"
#import "Utilities.h"

static NSString *const SEARCH_RESULTS_CELL_ID = @"result_cell";

@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readonly) Query *query;
@property (strong, nonatomic, readonly) QueryResult *query_result;
@property (strong, nonatomic) NSString *curr_room_in_focus;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *queryDetailsLabel;
@property (strong, nonatomic) IBOutlet UITableView *results_table_view;

- (void) set_query_result : (Query *) query query_result : (QueryResult *) query_result;

@end
