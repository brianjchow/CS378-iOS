//
//  BuildingList.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Building.h"
#import "Constants.h"

@interface BuildingList : NSObject

- (instancetype) init;

- (bool) contains_building : (NSString *) name;
- (Building *) get_building : (NSString *) name;
- (NSEnumerator *) get_enumerator;
- (int) get_size;
- (bool) put_building : (NSString *) name building : (Building *) building;

- (NSString *) toString;


@end
