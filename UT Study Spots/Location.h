//
//  Location.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Location : NSObject <NSCopying>

- (instancetype) initFullyQualified : (NSString *) building_room;
- (instancetype) initSeparated : (NSString *) building room : (NSString *) room;

- (NSString *) get_building;
- (NSString *) get_room;

// http://stackoverflow.com/questions/1459598/how-to-copy-an-object-in-objective-c
- (id) copyWithZone : (NSZone *) zone;

// http://stackoverflow.com/questions/18381035/objective-c-compareto
- (NSComparisonResult) compare : (Location *) otherObject;

// https://mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html

- (NSString *) toString;

@end
