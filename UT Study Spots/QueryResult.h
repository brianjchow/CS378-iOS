//
//  QueryResult.h
//  UT Study Spots
//
//  Created by Fatass on 3/29/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Query.h"
#import "Constants.h"

@interface QueryResult : NSObject

- (instancetype) init : (SearchType) search_type
        search_status : (SearchStatus) search_status
         building_name : (NSString *) building_name
              results : (NSArray *) results;

- (NSString *) get_building_name;
- (NSUInteger) get_num_results;
- (NSString *) get_random_room;
- (NSArray *) get_results;
- (SearchStatus) get_search_status;
- (NSString *) get_search_status_string;
- (SearchType) get_search_type;

@end










