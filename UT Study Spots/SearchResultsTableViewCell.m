//
//  SearchResultsTableViewCell.m
//  UT Study Spots
//
//  Created by Fatass on 4/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "SearchResultsTableViewCell.h"

#import "Constants.h"
#import "NSString+Tools.h"
#import "Utilities.h"

static const int TV_CELL_ROW_HEIGHT = 80;
static const int TV_CELL_ROW_WIDTH = 80;

@interface SearchResultsTableViewCell ()
@property (weak, nonatomic, readwrite) IBOutlet UIImageView *photo_thumb;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *detailsLabel;
@end

@implementation SearchResultsTableViewCell

@synthesize contents = _contents;

- (void) init_photo_thumb_contents : (UIImage *) image {
    self.photo_thumb.frame = CGRectMake(0, 0, TV_CELL_ROW_HEIGHT, TV_CELL_ROW_WIDTH);
    self.photo_thumb.contentMode = UIViewContentModeScaleAspectFit;
    self.photo_thumb.clipsToBounds = YES;
    self.photo_thumb.image = image;
}

- (void) setContents : (NSDictionary *) contents {
    _contents = contents;
    
    SearchType search_type = [[self.contents objectForKey : search_type_key] unsignedIntegerValue];
    SearchStatus search_status = [[self.contents objectForKey : search_status_key] unsignedIntegerValue];
    NSString *search_result = [self.contents objectForKey : search_result_key];
    
    if (search_type == RANDOM_ROOM) {
        NSString *search_building = [self.contents objectForKey : search_building_key];
        self.titleLabel.text = [NSString stringWithFormat : @"%@ %@", search_building, search_result];
        self.detailsLabel.text = @"";
        
        search_building = [search_building lowercaseString];

        if ([search_building is_gdc]) {
//        NSString *room_num_stripped = [search_result replaceAll : @"." replace_with : @""];
            NSString *room_num_stripped = [search_result stringByReplacingOccurrencesOfString : @"." withString : @""];
            NSString *image_name = [NSString stringWithFormat : @"%@_%@", search_building, room_num_stripped];
            
//        NSLog(@"image name is %@, room num is %@", image_name, search_result);
            
            UIImage *image = [UIImage imageNamed : image_name];
            if ([Utilities is_null : image]) {
                image = [UIImage imageNamed : @"campus_gdc"];
            }
            [self init_photo_thumb_contents : image];
        }
        else {
            NSString *image_name = [NSString stringWithFormat : @"campus_%@", search_building];
            
            UIImage *image = [UIImage imageNamed : image_name];
            if ([Utilities is_null : image]) {
                image = [UIImage imageNamed : @"campus_tower"];
            }
            [self init_photo_thumb_contents : image];
        }
    }
    else if (search_type == ROOM_SCHEDULE) {
        NSArray *comps = [search_result componentsSeparatedByString : @"\n"];
        self.titleLabel.text = comps[0];
        self.detailsLabel.text = [NSString stringWithFormat : @"%@\t%@", comps[1], comps[2]];
    }
    else {
        NSLog(@"crapples");
    }
    
}

- (NSString *) get_image_name {
    NSString *out = nil;
    
    SearchType search_type = [[self.contents objectForKey : search_type_key] unsignedIntegerValue];
    NSString *search_result = [self.contents objectForKey : search_result_key];
    
    if (search_type == RANDOM_ROOM) {
        NSString *search_building = [[self.contents objectForKey : search_building_key] lowercaseString];
        
        if ([search_building is_gdc]) {
            NSString *room_num_stripped = [search_result stringByReplacingOccurrencesOfString : @"." withString : @""];
            out = [NSString stringWithFormat : @"%@_%@", search_building, room_num_stripped];
            
            UIImage *test = [UIImage imageNamed : out];
            if ([Utilities is_null : test]) {
                out = @"campus_gdc";
            }
        }
        else {
            out = [NSString stringWithFormat : @"campus_%@", search_building];
            
            UIImage *test = [UIImage imageNamed : out];
            if ([Utilities is_null : test]) {
                out = @"campus_tower";
            }
        }
        
    }
    
    return out;
}

@end
