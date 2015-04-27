//
//  SearchResultsViewController.m
//  UT Study Spots
//
//  Created by Thien Vo on 4/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchResultsViewController ()

@property (strong, nonatomic, readwrite) Query *query;
@property (strong, nonatomic, readwrite) QueryResult *query_result;
//@property (strong, nonatomic, readwrite) NSString *curr_room_in_focus;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([Utilities is_null : self.query]) {
        // TODO - throw IAException ?????
    }
    if ([Utilities is_null : self.query_result]) {
        // TODO - throw IAException ?????
        
        self.query_result = [[QueryResult alloc] init : UNKNOWN
                                   search_status : SEARCH_ERROR
                                   building_name : @"Unknown"
                                         results : @[NO_ROOMS_FOUND]];
        
        self.curr_room_in_focus = [self.query_result get_random_room];
    }
    
    SearchType search_type = [self.query_result get_search_type];
    
    if (search_type == RANDOM_ROOM) {
        self.curr_room_in_focus = [self.query_result get_random_room];
        self.headerLabel.text = [NSString stringWithFormat : @"%@ %@", [self.query_result get_building_name], self.curr_room_in_focus];
    }
    else if (search_type == ROOM_SCHEDULE) {
        self.headerLabel.text = [NSString stringWithFormat : @"%@ %@", [self.query_result get_building_name], self.curr_room_in_focus];
    }
    else {
        self.headerLabel.text = @"crap";
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

// DO NOT CALL THIS METHOD ANYWHERE INSIDE THIS CLASS
- (void) set_query_result : (Query *) query query_result : (QueryResult *) query_result {
    if ([Utilities is_null : query]) {
        // TODO - throw iAException
    }
    if ([Utilities is_null : query_result]) {
        // TODO - throw IAException ?????
        
        query_result = [[QueryResult alloc] init : UNKNOWN
                                   search_status : SEARCH_ERROR
                                   building_name : @"Unknown"
                                         results : @[NO_ROOMS_FOUND]];
        
        self.curr_room_in_focus = [self.query_result get_random_room];
    }
    
//    NSLog(@"QueryResult is\n%@", [query_result toString]);
    
    self.query = query;
    self.query_result = query_result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.query_result get_results] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = SEARCH_RESULTS_CELL_ID;
    
    SearchResultsTableViewCell *out = [tableView dequeueReusableCellWithIdentifier : ident];
    if (!out) {
        out = [[SearchResultsTableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle reuseIdentifier : ident];
    }

    NSString *result = [[self.query_result get_results] objectAtIndex : indexPath.row];
    NSDictionary *cell_contents = @{
                                    search_type_key : [NSNumber numberWithUnsignedInteger : [self.query_result get_search_type]],
                                    search_status_key : [NSNumber numberWithUnsignedInteger : [self.query_result get_search_status]],
                                    search_building_key : [self.query_result get_building_name],
                                    search_result_key : result
                                    };
    
    out.contents = cell_contents;
    return out;
}




@end
