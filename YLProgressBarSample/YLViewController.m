//
//  YLViewController.m
//  YLProgressBar
//
//  Created by Yannick Loriot on 05/02/12.
//  Copyright (c) 2012 Yannick Loriot. All rights reserved.
//

#import "YLViewController.h"

#import "YLProgressBar.h"

@interface YLViewController ()

// Manage progress bars
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

// Configure progress bars
- (void)initFlatRainbowProgressBar;
- (void)initFlatWithIndicatorProgressBar;
- (void)initFlatAnimatedProgressBar;
- (void)initRoundedSlimProgressBar;
- (void)initRoundedFatProgressBar;

@end

@implementation YLViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initFlatRainbowProgressBar];
    [self initFlatWithIndicatorProgressBar];
    [self initFlatAnimatedProgressBar];
    [self initRoundedSlimProgressBar];
    [self initRoundedFatProgressBar];
}

- (void)viewDidUnload
{
    self.progressBarFlatRainbow       = nil;
    self.progressBarFlatWithIndicator = nil;
    self.progressBarFlatAnimated      = nil;
    self.progressBarRoundedSlim       = nil;
    self.progressBarRoundedFat        = nil;
    self.colorsSegmented              = nil;
    self.gradientSegmented            = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self percentageButtonTapped:_colorsSegmented];
    [self gradientButtonTapped:_gradientSegmented];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// For iOS6 and newer
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

// For iOS5 and older
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else
    {
        return YES;
    }
}

#pragma mark -
#pragma mark YLViewController Public Methods

- (IBAction)percentageButtonTapped:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex)
    {
        case 0:
        {
            [self setProgress:0.0f animated:YES];
        } break;
        case 1:
        {
            [self setProgress:0.3f animated:YES];
        } break;
        case 2:
        {
            [self setProgress:0.5f animated:YES];
        } break;
        case 3:
        {
            [self setProgress:0.7f animated:YES];
        } break;
        case 4:
        {
            [self setProgress:1.0f animated:YES];
        } break;
        default:
            break;
    }
}

- (IBAction)gradientButtonTapped:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex)
    {
        case 0:
        {
            [self setGradientType:YLProgressBarWithGradient];
        } break;
        case 1:
        {
            [self setGradientType:YLProgressBarWithNoGradient];
        } break;
        default:
            break;
    }
}

#pragma mark YLViewController Private Methods

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [_progressBarFlatRainbow setProgress:progress animated:animated];
    [_progressBarFlatWithIndicator setProgress:progress animated:animated];
    [_progressBarFlatAnimated setProgress:progress animated:animated];
    [_progressBarRoundedSlim setProgress:progress animated:animated];
    [_progressBarRoundedFat setProgress:progress animated:animated];
}

- (void)setGradientType:(YLProgressGradientType)gradient
{
    _progressBarFlatRainbow.gradientType = gradient;
    _progressBarFlatWithIndicator.gradientType = gradient;
    _progressBarFlatAnimated.gradientType = gradient;
    _progressBarRoundedSlim.gradientType = gradient;
    _progressBarRoundedFat.gradientType = gradient;
    [self percentageButtonTapped:_colorsSegmented];
}

- (void)initFlatRainbowProgressBar
{
    NSArray *tintColors = @[[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
                            [UIColor colorWithRed:3/255.0f green:137/255.0f blue:166/255.0f alpha:1.0f],
                            [UIColor colorWithRed:91/255.0f green:63/255.0f blue:150/255.0f alpha:1.0f],
                            [UIColor colorWithRed:87/255.0f green:26/255.0f blue:70/255.0f alpha:1.0f],
                            [UIColor colorWithRed:126/255.0f green:26/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:149/255.0f green:37/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:228/255.0f green:69/255.0f blue:39/255.0f alpha:1.0f],
                            [UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f],
                            [UIColor colorWithRed:165/255.0f green:202/255.0f blue:60/255.0f alpha:1.0f],
                            [UIColor colorWithRed:202/255.0f green:217/255.0f blue:54/255.0f alpha:1.0f],
                            [UIColor colorWithRed:111/255.0f green:188/255.0f blue:84/255.0f alpha:1.0f]];
    
    _progressBarFlatRainbow.type               = YLProgressBarTypeFlat;
    _progressBarFlatRainbow.progressTintColors = tintColors;
    _progressBarFlatRainbow.hideStripes        = YES;
    _progressBarFlatRainbow.behavior           = YLProgressBarBehaviorDefault;
    _progressBarFlatRainbow.gradientType      = YLProgressBarWithNoGradient;
}

- (void)initFlatWithIndicatorProgressBar
{
    _progressBarFlatWithIndicator.type                     = YLProgressBarTypeFlat;
    _progressBarFlatWithIndicator.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
    _progressBarFlatWithIndicator.behavior                 = YLProgressBarBehaviorIndeterminate;
    _progressBarFlatWithIndicator.stripesOrientation       = YLProgressBarStripesOrientationVertical;
    _progressBarFlatWithIndicator.gradientType             = YLProgressBarWithNoGradient;
}

- (void)initFlatAnimatedProgressBar
{
    _progressBarFlatAnimated.progressTintColor  = [UIColor colorWithRed:232/255.0f green:132/255.0f blue:12/255.0f alpha:1.0f];
    _progressBarFlatAnimated.type               = YLProgressBarTypeFlat;
    _progressBarFlatAnimated.stripesOrientation = YLProgressBarStripesOrientationVertical;
    _progressBarFlatAnimated.gradientType       = YLProgressBarWithNoGradient;
}

- (void)initRoundedSlimProgressBar
{
    _progressBarRoundedSlim.progressTintColor        = [UIColor colorWithRed:239/255.0f green:225/255.0f blue:13/255.0f alpha:1.0f];
    _progressBarRoundedSlim.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeTrack;
    _progressBarRoundedSlim.stripesColor             = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.36f];
    _progressBarRoundedSlim.gradientType             = YLProgressBarWithNoGradient;
}

- (void)initRoundedFatProgressBar
{
    NSArray *tintColors = @[[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
                            [UIColor colorWithRed:3/255.0f green:137/255.0f blue:166/255.0f alpha:1.0f],
                            [UIColor colorWithRed:91/255.0f green:63/255.0f blue:150/255.0f alpha:1.0f],
                            [UIColor colorWithRed:87/255.0f green:26/255.0f blue:70/255.0f alpha:1.0f],
                            [UIColor colorWithRed:126/255.0f green:26/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:149/255.0f green:37/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:228/255.0f green:69/255.0f blue:39/255.0f alpha:1.0f],
                            [UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f],
                            [UIColor colorWithRed:165/255.0f green:202/255.0f blue:60/255.0f alpha:1.0f],
                            [UIColor colorWithRed:202/255.0f green:217/255.0f blue:54/255.0f alpha:1.0f],
                            [UIColor colorWithRed:111/255.0f green:188/255.0f blue:84/255.0f alpha:1.0f]];
    
    _progressBarRoundedFat.progressTintColors       = tintColors;
    _progressBarRoundedFat.stripesOrientation       = YLProgressBarStripesOrientationLeft;
    _progressBarRoundedFat.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
    _progressBarRoundedFat.indicatorTextLabel.font  = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    _progressBarRoundedFat.gradientType             = YLProgressBarWithNoGradient;
}

@end
