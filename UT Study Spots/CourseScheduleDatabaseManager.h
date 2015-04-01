//
//  CourseScheduleDatabaseManager.h
//  UT Study Spots
//
//  Created by Fatass on 3/31/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseScheduleDatabaseManager : NSObject

+ (NSDictionary *) get_courses : (NSString *) building_name
                   db_filename : (NSString *) db_filename;

@end










