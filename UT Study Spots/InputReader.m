//
//  InputReader.m
//  UT Study Spots
//
//  Created by Fatass on 3/29/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

// http://stackoverflow.com/questions/3915742/nsfilehandle-filehandleforreadingfromurl-can-someone-explain-this-to-me-please

#import "InputReader.h"

#import "Utilities.h"

@interface InputReader ()

@property (strong, nonatomic) NSFileHandle *reader;
@property (strong, nonatomic) NSException *exception;
@property (strong, nonatomic) NSError *error;

@end

@implementation InputReader

//static NSString *const CHAR_ENCODING = @"UTF-8";
//static int const BUF_SIZE = 8192;

- (instancetype) initWithFileNameAndExt : (NSString *) filename ext : (NSString *) ext {
    if ([Utilities is_null : filename] || filename.length <= 0 ||
        [Utilities is_null : ext] || ext.length <= 0) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        NSString *file_path = [Utilities get_file_path : filename ext : ext];
        if ([Utilities is_null : file_path]) {
            return nil;
        }
        
        self = [self initWithFilePath : file_path];
    }
    
    return self;
}

- (instancetype) initWithFilePath : (NSString *) file_path {
    if ([Utilities is_null : file_path] || file_path.length <= 0) {
        // TODO - throw IAException
    }
    
    self = [super init];
    
    if (self) {
        self.reader = [NSFileHandle fileHandleForReadingAtPath : file_path];
        self.exception = nil;
        self.error = nil;
    }
    
    return self;
}

- (int) read {
    if ([Utilities is_null : self.reader]) {
        NSLog(@"WARNING: uninitialised reader, InputReader.read()");
        return -1;
    }
    
    NSData *data = nil;
    
    @try {
        data = [self.reader readDataOfLength : 1];
        
//        if ([Utilities is_null : data] || data.length <= 0) {
//            return -1;
//        }
//        
//        int out;
//        [data getBytes : &out length : sizeof(out)];
//        return out;
    }
    @catch (NSException *exception) {
        self.exception = exception;
//        return -1;
    }
    @finally {
        if (self.exception) {
            NSLog(@"Exception when reading byte, InputReader: %@", self.exception);
            self.exception = nil;
            return -1;
        }
        else if ([Utilities is_null : data] || data.length <= 0) {
            return -1;
        }
        
        int out;
        [data getBytes : &out length : sizeof(out)];
        return out;
    }
}

- (NSString *) read_line {
    if ([Utilities is_null : self.reader]) {
        NSLog(@"WARNING: uninitialised reader, InputReader.read_line()");
        return nil;
    }
    
//    NSMutableString *out = [NSMutableString new];
    NSMutableString *out = nil;
    
    @try {
        
        int curr_byte;
        while ((curr_byte = [self read]) != -1 && !self.exception) {
            if ((char) curr_byte == '\n') {
                break;
            }
            else {
                if (!out) {
                    out = [NSMutableString new];
                }
                
                [out appendFormat : @"%c", (char) curr_byte];
            }
        }

    }
    @catch (NSException *exception) {
        self.exception = exception;
    }
    @finally {
        if (self.exception) {
            NSLog(@"WARNING: Exception when reading line, InputReader.read_line():\n\t%@", self.exception);
            self.exception = nil;
            return nil;
        }
//        else if ([Utilities is_null : out] || out.length <= 0) {
//            return nil;
//        }
        
//        NSLog(@"Read line without error; returning... %@ (length %lu)", out, out.length);
        return out;
    }
    
}



@end
