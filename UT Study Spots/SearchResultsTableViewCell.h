//
//  SearchResultsTableViewCell.h
//  UT Study Spots
//
//  Created by Fatass on 4/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#ifndef UT_Study_Spots_SearchResultsTableViewCell_h
#define UT_Study_Spots_SearchResultsTableViewCell_h

#import <UIKit/UIKit.h>

static NSString *const search_type_key = @"search_type";
static NSString *const search_status_key = @"search_status";
static NSString *const search_building_key = @"search_building";
static NSString *const search_result_key = @"search_result";

@interface SearchResultsTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *contents;

@property (weak, nonatomic, readonly) IBOutlet UIImageView *photo_thumb;
@property (weak, nonatomic, readonly) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *detailsLabel;

/*
 @property (strong, nonatomic) NSDictionary *image;
 @property (strong, nonatomic) UIImage *image_data;
 @property (strong, nonatomic) UIImageView *imageview_data;
 */

@end

#endif
