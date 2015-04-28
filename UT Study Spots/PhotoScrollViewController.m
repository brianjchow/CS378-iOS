//
//  PhotoScrollViewController.m
//  UT Study Spots
//
//  Created by Fatass on 4/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "PhotoScrollViewController.h"

@interface PhotoScrollViewController ()

@end

@implementation PhotoScrollViewController

- (void) viewDidLoad {
    
    self.title = self.image_title;
    
    UIImage *image = [UIImage imageNamed : self.image_name];
    [self setup_views : image];
}

- (void) setup_views : (UIImage *) image {
    
    self.photo_scroll_view.delegate = self;
    self.photo_scroll_view.minimumZoomScale = 1.0;
    self.photo_scroll_view.maximumZoomScale = 5.0;
    self.photo_scroll_view.bouncesZoom = YES;
    self.photo_scroll_view.bounces = YES;
    
    self.imageview = [[UIImageView alloc] initWithImage : image];
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;   // UIViewContentModeScaleAspectFill
    
    [self.photo_scroll_view addSubview : self.imageview];
    self.photo_scroll_view.contentSize = self.imageview.frame.size;
    
}

- (void) viewDidLayoutSubviews {
    self.imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
// self.imageview.contentMode = UIViewContentModeScaleAspectFit;    //  UIViewContentModeScaleToFill
    
    self.photo_scroll_view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.photo_scroll_view.contentSize = self.imageview.frame.size;
    self.photo_scroll_view.contentMode = UIViewContentModeScaleAspectFit;
}

- (UIView *) viewForZoomingInScrollView : (UIScrollView *) sender {
    return self.imageview;
}



@end
