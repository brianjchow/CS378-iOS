//
//  NSMutableString+Stack.m
//  UT Study Spots
//
//  Created by Fatass on 3/29/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "NSMutableString+Stack.h"

#import "Utilities.h"

#import "NSString+Tools.h"

/*
        - for chars (primitives) ONLY
 */

@implementation NSMutableString (Stack)

NSMutableString *stack;

- (instancetype) init {
    self = [super init];
    
    if (self) {
        stack = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void) push : (int) c {
    [stack appendFormat : @"%c", c];
}

- (int) pop {
    NSUInteger length = stack.length;
    
    if (length <= 0) {
        // TODO - throw ISException
    }
    
    char out = [stack characterAtIndex : length - 1];
    stack = [[stack substring : 0 stop : (NSUInteger) length - 1] mutableCopy];
    
    return out;
}

- (int) peek {
    return ([stack characterAtIndex : stack.length - 1]);
}

- (bool) empty {
    return (stack.length == 0);
}

- (NSUInteger) size {
    return (stack.length);
}


@end
