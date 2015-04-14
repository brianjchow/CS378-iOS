//
//  CSVReader.h
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventList.h"

@interface CSVReader : NSObject

+ (EventList *) read_csv;

@end
