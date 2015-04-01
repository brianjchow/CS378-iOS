//
//  ConnectionManager.m
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

// http://code.tutsplus.com/tutorials/ios-sdk-detecting-network-changes-with-reachability--mobile-18299

#import "ConnectionManager.h"

#import "Reachability.h"

@interface ConnectionManager ()

@end

@implementation ConnectionManager

+ (ConnectionManager *) cxn_manager {
    static ConnectionManager *_cxn_manager = nil;
    static dispatch_once_t once_tok;
    
    dispatch_once(&once_tok, ^{
        _cxn_manager = [[self alloc] init];
    });
    
    return _cxn_manager;
}

- (void) dealloc {
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

+ (bool) is_reachable {
    return [[[ConnectionManager cxn_manager] reachability] isReachable];
}

+ (bool) is_unreachable {
    return (![self is_reachable]);
}

+ (bool) has_wifi {
    return [[[ConnectionManager cxn_manager] reachability] isReachableViaWiFi];
}

+ (bool) has_wwan {
    return [[[ConnectionManager cxn_manager] reachability] isReachableViaWWAN];
}

// ***********

- (id) init {
    self = [super init];
    
    if (self) {
        self.reachability = [Reachability reachabilityWithHostName : @"cs.utexas.edu"];
        
        [self.reachability startNotifier];
    }
    
    return self;
}

@end










