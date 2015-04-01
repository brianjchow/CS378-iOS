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

+ (EventList *) read_csv_default;
+ (EventList *) read_csv : (bool) read_from_local_feeds;

+ (bool) file_delete : (NSString *) filename;
+ (bool) delete_all_feeds;

+ (bool) save_feed_write_pref : (NSString *) pref_name success : (BOOL) success;

@end
