//
//  PhotoScrollViewController.h
//  UT Study Spots
//
//  Created by Fatass on 4/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#ifndef UT_Study_Spots_PhotoScrollViewController_h
#define UT_Study_Spots_PhotoScrollViewController_h

#import <UIKit/UIKit.h>

@interface PhotoScrollViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photo_scroll_view;

@property (strong, nonatomic) NSString *image_title;
@property (strong, nonatomic) NSString *image_name;
@property (strong, nonatomic) UIImageView *imageview;

@end

#endif
