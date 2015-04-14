//
//  QueryRoomSchedule.h
//  UT Study Spots
//
//  Created by Fatass on 3/30/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Query.h"

@interface QueryRoomSchedule : Query

- (NSString *) get_option_search_room;
- (bool) set_option_search_room : (NSString *) room_num;

@property (strong, nonatomic, readonly) NSString *search_room;

@end
