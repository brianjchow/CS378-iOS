//
//  SearchResultsViewController.h
//  UT Study Spots
//
//  Created by Thien Vo on 4/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) NSDictionary *sentData;

@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

@end
