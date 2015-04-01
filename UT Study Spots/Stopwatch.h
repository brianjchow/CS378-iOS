//
//  Stopwatch.h
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

static double const NANOS_PER_SEC = 1000000000.0;
static double const MICROS_PER_SEC = 1000000;
static double const MILLIS_PER_SEC = 1000;

@interface Stopwatch : NSObject

- (instancetype) init;

+ (instancetype) new;

- (void) start;
- (void) stop;

- (double) time;
- (double) time_ms;
- (double) time_us;
- (double) time_ns;

- (double) time_elapsed;
- (double) time_elapsed_ms;
- (double) time_elapsed_us;
- (double) time_elapsed_ns;

@end










