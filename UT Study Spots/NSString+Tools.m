//
//  NSString+Tools.m
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "NSString+Tools.h"

#import "Constants.h"
#import "Utilities.h"

/*
 THIS CLASS ASSUMES UTF8-ENCODED STRINGS
 */

@implementation NSString (Tools)

// http://behindtechlines.com/2012/05/ios-cocoa-regular-expressions-to-find-replace-strings-matching-patterns/
- (NSString *) replaceAll : (NSString *) regex replace_with : (NSString *) replace_with {
    if ([Utilities is_null : self] || [Utilities is_null : regex] || [Utilities is_null : replace_with]) {
        // TODO - throw exception
    }
    else if (regex.length == 0) {
        return self;
    }
    
    NSError *error = nil;
    NSRegularExpression *nsre_regex = [NSRegularExpression regularExpressionWithPattern : regex options : NSRegularExpressionCaseInsensitive error : &error];
    
    if ([Utilities is_null : nsre_regex]) {
        // TODO - throw exception
    }
    
    NSString *out = [nsre_regex stringByReplacingMatchesInString : self options : 0 range : NSMakeRange(0, self.length) withTemplate : replace_with];
    
    return out;
}

// http://stackoverflow.com/questions/15890823/how-to-convert-nsstring-to-nsarray-with-characters-one-by-one-in-objective-c
- (NSArray *) toCharArray {
    if ([Utilities is_null : self]) {
        // TODO - throw IAException
    }
    
    NSMutableArray *out = [NSMutableArray new];
    
    NSString *temp;
    for (int i = 0; i < self.length; i++) {
        temp = [self substringWithRange : NSMakeRange(i, 1)];
        [out addObject : [temp stringByReplacingPercentEscapesUsingEncoding : DEFAULT_STRING_ENCODING]];
    }
    
    return out;
}

- (NSArray *) split : (NSString *) regex {
    if ([Utilities is_null : regex]) {
        // TODO - throw IAException
    }
    return ([self componentsSeparatedByString : regex]);
}

- (bool) containsIgnoreCase : (NSString *) what {
    if ([Utilities is_null : self] || [Utilities is_null : what]) {
        // TODO - throw exception
    }
    
    if ([self rangeOfString : what options : NSCaseInsensitiveSearch].location == NSNotFound) {
        return false;
    }
    return true;
}

// http://stackoverflow.com/questions/2582306/case-insensitive-comparison-nsstring
- (bool) equalsIgnoreCase : (NSString *) what {
    if ([Utilities is_null : self] || [Utilities is_null : what]) {
        // TODO - throw exception
    }
    
    if ([self caseInsensitiveCompare : what] != NSOrderedSame) {
        return false;
    }
    return true;
}

// http://stackoverflow.com/questions/5676106/how-to-get-substring-of-nsstring
- (NSString *) substring : (NSUInteger) start stop : (NSUInteger) stop {
    if ([Utilities is_null : self] || stop < start || start >= self.length || stop > self.length) {
        // TODO - throw IAException
    }
    
    NSRange range = NSMakeRange(start, stop - start);
    NSString *out = [self substringWithRange : range];
    
    //    NSLog(@"Src: %@ start: %lu stop: %lu retval: %@", src, start, stop, out);
    
    return out;
}

// http://stackoverflow.com/questions/6720191/reverse-nsstring-text
- (NSString *) reverse {
    if ([Utilities is_null : self]) {
        // TODO - throw IAException
    }
    else if (self.length <= 1) {
        return self;
    }
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0,[self length])
                             options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [reversedString appendString:substring];
                          }];
    
    return reversedString;
}

- (NSString *) append : (NSString *) what {
    if ([Utilities is_null : self] || [Utilities is_null : what]) {
        // TODO - throw IAException
    }
    
    return ([NSString stringWithFormat : @"%@%@", self, what]);
}

- (NSString *) concat : (NSString *) what {
    return ([self append : what]);
}

// http://www.objc.io/issue-9/unicode.html
- (int) charAt : (int) index {
    if (index < 0 || index >= self.length) {
        // TODO - throw IAException
    }
    
    return ([self characterAtIndex : (NSUInteger) index]);
}

- (int) indexOf : (int) ch {
    for (int i = 0; i < self.length; i++) {
        if ([self charAt : i] == ch ) {
            return i;
        }
    }
    
    return -1;
}

- (bool) isEmpty {
    return (self.length == 0);
}

- (int) lastIndexOf : (int) ch {
    for (int i = (int) self.length - 1; i >= 0; i--) {
        if ([self charAt : i] == ch) {
            return i;
        }
    }
    
    return -1;
}

//- (NSUInteger) hash {
//    if (!self || [self isEqual : [NSNull class]]) {
//        // TODO - throw exception
//    }
//
//    NSUInteger hash = 0;
//    NSUInteger h = hash;
////    char *str_arr = [string getCString:c_buffer maxLength:c_buffer_length encoding:NSUTF8StringEncoding];
//    const char *str_arr = [self UTF8String];
//
//    if (h == 0 && self.length > 0) {
//        const char *val = str_arr;
//
//        for (int i = 0; i < self.length; i++) {
//            h = 31 * h + val[i];
//        }
//        hash = h;
//    }
//
//    return h;
//}

// because i'm lazy
- (bool) equals : (NSString *) what {
    if ([Utilities is_null : what]) {
        // TODO - throw iAException
    }
    
    return ([self isEqualToString : what]);
}

// **************

- (bool) is_gdc {
    if ([Utilities is_null : self]) {
        // TODO - throw exception
    }
    
    return ([self caseInsensitiveCompare : GDC] == NSOrderedSame);
}

- (bool) is_campus_building {
    if ([Utilities is_null : self] || self.length <= 2 || [self is_ignored_room]) {
        return false;
    }
    
    NSString *compare = [[self substring : 0 stop : 3] uppercaseString];
    
    //    NSArray *campus_buildings_keyset = [CAMPUS_BUILDINGS allKeys];
    //    for (NSString *building in campus_buildings_keyset) {
    //        if ([compare isEqualToString : building] && ![self is_ignored_room : str]) {
    //            return true;
    //        }
    //    }
    
    NSNumber *val = [CAMPUS_BUILDINGS objectForKey : compare];
    if (![Utilities is_null : val]) {
        return true;
    }
    
    return false;
}

- (bool) is_ignored_room {
    if ([Utilities is_null : self] || self.length <= 0) {
        return false;
    }
    
    for (int i = 0; i < IGNORE_ROOMS_LENGTH; i++) {
        if ([self containsIgnoreCase : IGNORE_ROOMS[i]]) {
            return true;
        }
    }
    
    return false;
}

- (NSString *) strip_filename_ext : (NSString **) ext {
    if ([Utilities is_null : self]) {
        // TODO - throw IAException
    }
    
    NSString *out = [self copy];
    
    int subfolder_index = [self last_index_of :  '/'];
    int file_ext_dot_index = [self last_index_of : '.'];
    if (file_ext_dot_index >= 0 && file_ext_dot_index < self.length) {
        if (subfolder_index == -1) {
            out = [self substring : 0 stop : file_ext_dot_index];
        }
        else {
            out = [self substring : subfolder_index + 1 stop : file_ext_dot_index];
        }
        
        if (ext != nil) {
            if (file_ext_dot_index == self.length - 1) {
                *ext = @"";
            }
            else {
                *ext = [NSString stringWithFormat : @"%@", [self substring : file_ext_dot_index + 1 stop : self.length]];
            }
        }
    }
    
    return out;
}

- (int) last_index_of : (int) what {
    for (int i = (int) self.length - 1; i >= 0; i--) {
        if ([self characterAtIndex : i] == what) {
            return i;
        }
    }
    
    return -1;
}

- (bool) is_valid_db_filename {
    if ([Utilities is_null : self] || self.length <= 0) {
        // TODO - throw IAException
    }
    
    bool is_valid = false;
    
    if ([self isEqualToString : COURSE_SCHEDULE_THIS_SEMESTER]) {
        is_valid = true;
    }
    else if (!DISABLE_SEARCHES_NEXT_SEMESTER &&
             [self isEqualToString : COURSE_SCHEDULE_NEXT_SEMESTER]) {
        is_valid = true;
    }
    
    return is_valid;
}

- (bool) is_date_string {
    if ([Utilities is_null : self] || self.length <= 0) {
        return false;
    }
    
    NSArray *split = [self componentsSeparatedByString : @" "];
    
    for (int i = 0; i < [split count]; i++) {
        for (int j = 1; j < DAYS_OF_WEEK_ARR_LENGTH; j++) {
            if ([split[i] equalsIgnoreCase : DAYS_OF_WEEK_SHORT[j]]) {
                return true;
            }
        }
    }
    
    return false;
}

- (NSString *) url_encode {
    if ([Utilities is_null : self]) {
        // TODO - throw IAException
    }
    
    NSString *out = [self stringByAddingPercentEscapesUsingEncoding : DEFAULT_STRING_ENCODING];       // NSUTF8StringEncoding
    
    return out;
}

- (NSURL *) to_url {
    if ([Utilities is_null : self]) {
        // TODO - throw IAException
    }
    
    NSURL *out = [[NSURL alloc] initWithString : [self url_encode]];
    return out;
}

@end










