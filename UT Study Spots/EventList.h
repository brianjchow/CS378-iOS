//
//  EventList.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Event.h"
#import "Constants.h"

@interface EventList : NSObject <NSCopying>

@property (strong, nonatomic, readonly) NSMutableArray *list;

- (instancetype) init;
- (instancetype) initWithSize : (NSUInteger) size;
- (instancetype) initWithHashMapList : (NSArray *) strings;     // List<HashMap<String, String>>

- (bool) add_event : (Event *) eo;
- (bool) add_hashmap_list : (NSArray *) strings;        // List<HashMap<String, String>>

- (NSEnumerator *) get_enumerator;
- (Event *) get_event : (unsigned int) index;

// protected Iterator<Event> get_iterator();

- (NSUInteger) get_size;

// protected void sort_by_end_date(boolean sort_ascending);
// protected void sort_by_event_name(boolean sort_ascending);
// protected void sort_by_location(boolean sort_ascending);
// protected void sort_by_start_date(boolean sort_ascending);
// protected int binary_search(Event search_for);

//- (id) copy;
- (id) copyWithZone : (NSZone *) zone;
//- (NSComparisonResult) compare : (Event *) otherObject;
// isEqual overridden; hash NOT overridden

- (NSString *) toString;


@end
