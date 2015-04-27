//
//  SearchResultsTableViewCell.m
//  UT Study Spots
//
//  Created by Fatass on 4/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "SearchResultsTableViewCell.h"

#import "Constants.h"

@interface SearchResultsTableViewCell ()
@property (weak, nonatomic, readwrite) IBOutlet UIImageView *photo_thumb;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *detailsLabel;
@end

@implementation SearchResultsTableViewCell

@synthesize contents = _contents;

- (void) setContents : (NSDictionary *) contents {
    _contents = contents;
    
    SearchType search_type = [[self.contents objectForKey : search_type_key] unsignedIntegerValue];
    SearchStatus search_status = [[self.contents objectForKey : search_status_key] unsignedIntegerValue];
    NSString *search_result = [self.contents objectForKey : search_result_key];
    
    if (search_type == RANDOM_ROOM) {
        
    }
    else if (search_type == ROOM_SCHEDULE) {
        
    }
    else {
        
    }
    
}

@end
