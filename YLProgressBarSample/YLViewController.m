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
@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSTimer*    progressTimer;

@end

@implementation YLViewController

- (void)dealloc
{
    if (_progressTimer && [_progressTimer isValid])
    {
        [_progressTimer invalidate];
    }
    
    SAFE_ARC_RELEASE (_progressTimer);
    SAFE_ARC_RELEASE (_progressValueLabel);
    SAFE_ARC_RELEASE (_colorsSegmented);
    SAFE_ARC_RELEASE (_progressView);
    
    SAFE_ARC_SUPER_DEALLOC ();
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressTimer  = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                           target:self
                                                         selector:@selector(changeProgressValue)
                                                         userInfo:nil
                                                          repeats:YES];
    
}

- (void)viewDidUnload
{
    [self setProgressValueLabel:nil];
    [self setProgressView:nil];
    [self setColorsSegmented:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self colorButtonTapped:_colorsSegmented];
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

// For iOS6 and newer
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationPortrait|UIInterfaceOrientationMaskLandscape;
    } else
    {
        return UIInterfaceOrientationMaskAll;
    }
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

- (void)changeProgressValue
{
    float progressValue         = _progressView.progress;
    
    progressValue               += 0.01f;
    if (progressValue > 1)
    {
        progressValue = 0;
    }
    
    _progressValueLabel.text    = [NSString stringWithFormat:@"%.0f%%", (progressValue * 100)];
    _progressView.progress      = progressValue;
}

- (IBAction)colorButtonTapped:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex)
    {
        case 0:
        {
            // Use the progressTintColors to defines the colors of the progress bar
            NSArray *tintColors                 = [NSArray arrayWithObjects:[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:3/255.0f green:137/255.0f blue:166/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:91/255.0f green:63/255.0f blue:150/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:87/255.0f green:26/255.0f blue:70/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:126/255.0f green:26/255.0f blue:36/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:149/255.0f green:37/255.0f blue:36/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:228/255.0f green:69/255.0f blue:39/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:165/255.0f green:202/255.0f blue:60/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:202/255.0f green:217/255.0f blue:54/255.0f alpha:1.0f],
                                                   [UIColor colorWithRed:111/255.0f green:188/255.0f blue:84/255.0f alpha:1.0f],
                                                   nil];
            _progressView.progressTintColors    = tintColors;
            break;
        }
        case 1:
        {
            // Traditional progressTintColor to define the color
            _progressView.progressTintColor     = [UIColor redColor];
            break;
        }
        case 2:
        {
            _progressView.progressTintColor     = [UIColor cyanColor];
            break;
        }
        case 3:
        {
            _progressView.progressTintColor     = [UIColor greenColor];
            break;
        }
        case 4:
        {
            _progressView.progressTintColor     = [UIColor yellowColor];
            break;
        }
        default:
            break;
    }
}

#pragma mark YLViewController Private Methods

@end
