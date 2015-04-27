//
//  MainTableViewController.m
//  UT Study Spots
//
//  Created by Fatass on 4/26/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void) setUpButtonUI:(UIButton *) button {
    
    [button.layer setCornerRadius:5.0f];
    button.layer.borderWidth = 1;
    [button.layer setBorderColor:[UIColor colorWithRed:34.0f/255.0f green:128.0f/255.0f blue:207.0f/255.0f alpha:1].CGColor];
}

- (void) didSelectButton:(UIButton *) button withTitle:(NSString *) title {
    [button setTitle:title forState:UIControlStateNormal];
    
    if(button.contentHorizontalAlignment != UIControlContentHorizontalAlignmentLeft){
        NSLog(@"Changing alignment to left alignment");
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [button sizeToFit];
}

- (NSArray *) getSemesterBoundsBasedOnCurrentDate {
    //By default max and min = current date
    NSDate *minimumDate = [Utilities get_date];
    NSDate *maximumDate = [Utilities get_date];
    NSDate *currentDate = [Utilities get_date];
    NSInteger year = currentDate.year;
    
    //Decide which semester we  currently are in
    if([Utilities date_is_during_spring:currentDate]) {
        minimumDate = [Utilities get_date : SPRING_START_MONTH
                                      day : SPRING_START_DAY
                                     year : year
                                     hour : 0
                                   minute : 0];
        
        maximumDate = [Utilities get_date : SPRING_END_MONTH
                                      day : SPRING_END_DAY
                                     year : year
                                     hour : 0
                                   minute : 0];
    } else if ([Utilities date_is_during_fall:currentDate]){
        minimumDate = [Utilities get_date : FALL_START_MONTH
                                      day : FALL_START_DAY
                                     year : year
                                     hour : 0
                                   minute : 0];
        
        maximumDate = [Utilities get_date : FALL_END_MONTH
                                      day : FALL_END_DAY
                                     year : year
                                     hour : 0
                                   minute : 0];
        
    } else if ([Utilities date_is_during_summer:currentDate]) {
        minimumDate = [Utilities get_date : SUMMER_START_MONTH
                                      day : SUMMER_START_DAY
                                     year : year
                                     hour : 0
                                   minute : 0];
        
        maximumDate = [Utilities get_date : SUMMER_END_MONTH
                                      day : SUMMER_END_DAY
                                     year : year
                                     hour : 0
                                   minute : 0];
        
    }
    
    return @[currentDate, minimumDate, maximumDate];
}

@end
