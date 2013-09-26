//
//  YLViewController.h
//  YLProgressBar
//
//  Created by Yannick Loriot on 05/02/12.
//  Copyright (c) 2012 Yannick Loriot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLProgressBar;

@interface YLViewController : UIViewController

@property (nonatomic, strong) IBOutlet YLProgressBar      *progressView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *colorsSegmented;
@property (nonatomic, strong) IBOutlet UILabel            *progressValueLabel;

#pragma mark Constructors - Initializers

#pragma mark Public Methods

- (IBAction)colorButtonTapped:(id)sender;

@end
