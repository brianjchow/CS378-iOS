//
//  LoadViewController.m
//  UT Study Spots
//
//  Created by Fatass on 4/1/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "LoadViewController.h"

@interface LoadViewController ()

@property (nonatomic, strong) UIImageView *animationImageView;

@end

@implementation LoadViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundImage];
    [self setLoadingAnimation];
    [self.animationImageView startAnimating];
    

        

//    [self.animationImageView stopAnimating];
//    [self performSegueWithIdentifier:@"drawerView" sender:self];

        

    
    
    
}

//http://stackoverflow.com/questions/23739767/how-to-centre-the-background-image-in-a-uiview-without-streching-it
- (void)setBackgroundImage {
    UIImage *backgroundImage = [UIImage imageNamed:@"gdcBackground"];
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGRect imagePosition = CGRectMake((self.view.bounds.size.width / 2)  - (backgroundImage.size.width / 2),
                                      (self.view.bounds.size.height / 2) - (backgroundImage.size.height / 2),
                                      backgroundImage.size.width,
                                      backgroundImage.size.height);
    
    [backgroundImage drawInRect:imagePosition];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:image];
}

//http://www.appcoda.com/ios-programming-animation-uiimageview/
- (void)setLoadingAnimation {
    NSArray *imageNames = @[@"frame_000_200p_transparent", @"frame_001_200p_transparent", @"frame_002_200p_transparent", @"frame_003_200p_transparent"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    self.animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 95, 86, 193)];
    
    self.animationImageView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    self.animationImageView.animationImages = images;
    self.animationImageView.animationDuration = 0.5;
    [self.view addSubview:self.animationImageView];
}


@end










