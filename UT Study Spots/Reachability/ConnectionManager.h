//
//  ConnectionManager.h
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Reachability;

@interface ConnectionManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

+ (ConnectionManager *) cxn_manager;

+ (bool) is_reachable;
+ (bool) is_unreachable;

+ (bool) has_wifi;
+ (bool) has_wwan;

@end










