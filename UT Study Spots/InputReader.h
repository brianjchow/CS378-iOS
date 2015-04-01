//
//  InputReader.h
//  UT Study Spots
//
//  Created by Fatass on 3/29/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputReader : NSObject

- (instancetype) initWithFileNameAndExt : (NSString *) filename ext : (NSString *) ext;
- (instancetype) initWithFilePath : (NSString *) file_path;

- (int) read;
- (NSString *) read_line;

@end
