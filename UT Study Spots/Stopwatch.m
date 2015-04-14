//
//  Stopwatch.m
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

// http://stackoverflow.com/questions/2129794/how-to-log-a-methods-execution-time-exactly-in-milliseconds

#import "Stopwatch.h"

#include <mach/mach_time.h>
#include <stdint.h>

@interface Stopwatch ()

@property (nonatomic) double start_time;
@property (nonatomic) double stop_time;

@end

@implementation Stopwatch

- (double) _start {
    return self.start_time;
}

- (double) _stop {
    return self.stop_time;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.start_time = 0;
        self.stop_time = 0;
    }
    
    return self;
}

+ (instancetype) new {
    return ([[Stopwatch alloc] init]);
}

- (void) start {
    self.start_time = mach_absolute_time();
}

- (void) stop {
    self.stop_time = mach_absolute_time();
}

- (double) time {
    return ([self time_ns] / NANOS_PER_SEC);
}

- (double) time_ms {
    return ([self time_ns] / MILLIS_PER_SEC);
}

- (double) time_us {
    return ([self time_ns] / MICROS_PER_SEC);
}

- (double) time_ns {
    double time = self.stop_time - self.start_time;
    
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info)) {
        // ? error
        
        return time;
    }
    
    double out = time * (double) info.numer / (double) info.denom;
    return out;
}

- (double) time_elapsed {
    return ([self time_elapsed_ns] / NANOS_PER_SEC);
}

- (double) time_elapsed_ms {
    return ([self time_elapsed_ns] / MILLIS_PER_SEC);
}

- (double) time_elapsed_us {
    return ([self time_elapsed_us] / MICROS_PER_SEC);
}

- (double) time_elapsed_ns {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info)) {
        // ? error
        
        return (mach_absolute_time() - self.start_time);
    }
    
    double out = (mach_absolute_time() - self.start_time) * (double) info.numer / (double) info.denom;
    return out;
}

@end










