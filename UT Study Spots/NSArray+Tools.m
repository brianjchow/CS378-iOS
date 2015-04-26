//
//  NSArray+Tools.m
//  UT Study Spots
//
//  Created by Fatass on 4/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "NSArray+Tools.h"

#import "Constants.h"
#import "Utilities.h"

@implementation NSArray (Tools)

- (NSArray *) sort_ascending {
    if ([Utilities is_null : self]) {
        // TODO - throw ISException
    }
    
    return ([self sortedArrayUsingSelector : @selector(localizedCaseInsensitiveCompare : )]);
}

@end
