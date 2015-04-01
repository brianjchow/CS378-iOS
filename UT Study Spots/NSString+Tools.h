//
//  NSString+Tools.h
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Tools)

/* Java-equivalent methods */

- (bool) containsIgnoreCase : (NSString *) what;

- (bool) equalsIgnoreCase : (NSString *) what;

- (NSString *) substring : (NSUInteger) start stop : (NSUInteger) stop;

- (NSString *) reverse;

/* Project-specific methods */

- (NSString *) regex_replace : (NSString *) regex replace_with : (NSString *) replace_with;

- (bool) is_gdc;

- (bool) is_campus_building;

- (bool) is_ignored_room;

- (NSString *) strip_filename_ext : (NSString **) ext;

- (int) last_index_of : (char) what;

- (bool) is_valid_db_filename;

- (bool) is_date_string;

- (NSArray *) to_array;

@end










