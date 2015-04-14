//
//  LoadViewController.m
//  UT Study Spots
//
//  Created by Fatass on 4/1/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "LoadViewController.h"

@interface LoadViewController ()

@end

@implementation LoadViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UIImage *panda_cycle_loader = [UIImage animatedImageNamed : @"frame_" duration : 1.0f];
    UIImageView *panda_anim = [[UIImageView alloc] initWithImage : panda_cycle_loader];
    
    [self.view addSubview : panda_anim];
}

@end










