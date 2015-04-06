//
//  NSMutableString+Stack.h
//  UT Study Spots
//
//  Created by Fatass on 3/29/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableString (Stack)

- (void) push : (char) c;
- (int) pop;
- (int) peek;
- (bool) empty;
- (NSUInteger) size;

@end
