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

@property (nonatomic, strong) IBOutlet YLProgressBar      *progressBarFlatRainbow;
@property (nonatomic, strong) IBOutlet YLProgressBar      *progressBarFlatWithIndicator;
@property (nonatomic, strong) IBOutlet YLProgressBar      *progressBarFlatAnimated;
@property (nonatomic, strong) IBOutlet YLProgressBar      *progressBarRoundedSlim;
@property (nonatomic, strong) IBOutlet YLProgressBar      *progressBarRoundedFat;
@property (nonatomic, strong) IBOutlet UISegmentedControl *colorsSegmented;
@property (nonatomic, strong) IBOutlet UISegmentedControl *gradientSegmented;

#pragma mark Constructors - Initializers

#pragma mark Public Methods

- (IBAction)percentageButtonTapped:(id)sender;
- (IBAction)gradientButtonTapped:(id)sender;

@end
