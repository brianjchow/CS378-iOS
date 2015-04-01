//
//  QueryResult.m
//  UT Study Spots
//
//  Created by Fatass on 3/29/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "QueryResult.h"

#import "Utilities.h"

@interface QueryResult ()

@property (nonatomic) SearchType search_type;
@property (nonatomic) SearchStatus search_status;   // //@property (strong, nonatomic) NSString *message_status;

@property (strong, nonatomic) NSString *building_name;
@property (strong, nonatomic) NSArray *results;  // List<String>

@end

@implementation QueryResult

//- (instancetype) init : (SearchType) search_type building_name : (NSString *) building_name {
//    if ([Utilities is_null : building_name] || building_name.length != BUILDING_CODE_LENGTH) {
//        // TODO - throw IAException
//    }
//    
//    self = [super init];
//    
//    if (self) {
//        self.search_type = search_type;
//        self.search_status = SEARCH_ERROR;
//        self.building_name = [NSString stringWithString : building_name];
//        self.results = [NSMutableArray new];
//    }
//    
//    return self;
//}

- (instancetype) init : (SearchType) search_type
        search_status : (SearchStatus) search_status
        building_name : (NSString *) building_name
              results : (NSArray *) results {
    
    if (search_type >= NUM_SEARCH_STATII || search_status >= NUM_SEARCH_TYPES || [Utilities is_null : building_name] || building_name.length != BUILDING_CODE_LENGTH || [Utilities is_null : results]) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        self.search_type = search_type;
        self.search_status = search_status;
        self.building_name = [NSString stringWithString : building_name];
        self.results = results;
    }
    
    return self;
}

- (NSString *) get_building_name {
    return self.building_name;
}

- (NSUInteger) get_num_results {
    return ([self.results count]);
}

- (NSString *) get_random_room {
    if ([self.results count] <= 0 || self.search_status == SEARCH_SUCCESS) {
        return (SEARCH_STATUS_STRINGS[self.search_status]);
    }
    
    int random_index = arc4random_uniform((unsigned int) [self.results count]);
    
    NSString *out = [self.results objectAtIndex : random_index];
    return out;
}

- (NSArray *) get_results {
    return self.results;
}

- (SearchStatus) get_search_status {
    return self.search_status;
}

- (NSString *) get_search_status_string {
    return (SEARCH_STATUS_STRINGS[self.search_status]);
}

- (SearchType) get_search_type {
    return self.search_type;
}

//- (bool) set_results : (NSArray *) results {
//    if ([Utilities is_null : results]) {
//        return false;
//    }
//    
//    self.results = [results mutableCopy];
//    return true;
//}
//
//- (bool) set_search_status : (SearchStatus) message_status {
//    
//}

@end

/*
 
 Original (nested in Query; only a Query object could create a QueryResult)
 
    - private QueryResult(SearchType search_type, final String building_name);
    - protected String get_building_name();
    - protected int get_num_results();
    - protected String get_random_room();
    - protected List<String> get_results();
    - protected String get_search_status();
    - protected int get_search_type();
    - private boolean set_results(List<String> results);
    - private boolean set_search_status(SearchStatus message_status);
 
 */









