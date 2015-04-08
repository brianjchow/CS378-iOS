//
//  Building.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Room.h"
#import "Constants.h"

@interface Building : NSObject <NSCopying>

+ (Building *) get_instance : (NSString *) building_code db_filename : (NSString *) db_filename;

- (bool) contains_room : (NSString *) room_num;
- (NSOrderedSet *) get_keyset;      // of String
- (NSString *) get_name;
- (int) get_num_rooms;
- (Room *) get_random_room;
- (Room *) get_room : (NSString *) room_num;

- (id) copyWithZone : (NSZone *) zone;
- (NSComparisonResult) compare : (Building *) otherObject;

- (NSString *) toString;

@property (strong, nonatomic, readonly, getter = get_name) NSString *name;


@end
