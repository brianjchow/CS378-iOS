//
//  QueryRandomRoom.h
//  UT Study Spots
//
//  Created by Fatass on 3/30/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Query.h"
#import "QueryResult.h"

@interface QueryRandomRoom : Query

- (int) get_option_capacity;
- (bool) get_option_power;
- (bool) set_option_capacity : (int) capacity;
- (bool) set_option_power : (bool) power;

@property (nonatomic, readonly, getter = get_option_capacity) int capacity;
@property (nonatomic, readonly, getter = get_option_power) bool has_power;

@end
