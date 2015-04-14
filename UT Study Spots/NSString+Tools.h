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

- (NSString *) replaceAll : (NSString *) regex replace_with : (NSString *) replace_with;

- (NSArray *) toCharArray;

- (NSArray *) split : (NSString *) regex;

- (bool) containsIgnoreCase : (NSString *) what;

- (bool) equalsIgnoreCase : (NSString *) what;

- (NSString *) substring : (NSUInteger) start stop : (NSUInteger) stop;

- (NSString *) reverse;

- (NSString *) append : (NSString *) what;

- (NSString *) concat : (NSString *) what;

- (int) charAt : (int) index;

- (int) indexOf : (int) ch;

- (bool) isEmpty;

- (int) lastIndexOf : (int) ch;

- (bool) equals : (NSString *) what;

/* Project-specific methods */

- (bool) is_gdc;

- (bool) is_campus_building;

- (bool) is_ignored_room;

- (NSString *) strip_filename_ext : (NSString **) ext;

- (int) last_index_of : (int) what;

- (bool) is_valid_db_filename;

- (bool) is_date_string;

- (NSString *) url_encode;

- (NSURL *) to_url;

// protected static String time_to_24h(String time);

// protected static String pad_to_len_leading_zeroes(String str, int final_len);

// protected static String time_to_12h(String time);

@end










