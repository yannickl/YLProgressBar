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
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) CGFloat progressValue;

@end

@implementation YLViewController

- (void)dealloc
{
    if (_progressTimer && [_progressTimer isValid])
    {
        [_progressTimer invalidate];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[YLProgressBar appearance] setStripesWidth:25];
    [[YLProgressBar appearance] setProgress:0.6f];

    self.progressValue  = 0;
    self.progressTimer  = [NSTimer timerWithTimeInterval:0.2f
                                                  target:self
                                                selector:@selector(changeProgressValue)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSDefaultRunLoopMode];
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

- (void)changeProgressValue
{
    CGFloat localProgress   = 0;
    
    _progressValue  += 0.01f;
    if (_progressValue > 1.0f)
    {
        _progressValue = 0;
    }
    
    switch (_progressView.behavior)
    {
        case YLProgressBarBehaviorIndeterminate:
            localProgress = _progressValue - 0.2f;
            localProgress = (localProgress < 0) ? 0 : localProgress;
            break;
        case YLProgressBarBehaviorWaiting:
            localProgress =_progressValue + 0.2f;
            localProgress = (localProgress > 1.0f) ? 1.0f : localProgress;
            break;
        default:
            localProgress = _progressValue;
            break;
    }

    _progressValueLabel.text    = [NSString stringWithFormat:@"%.0f%%", (localProgress * 100)];
    _progressView.progress      = localProgress;
}

- (IBAction)colorButtonTapped:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex)
    {
        case 0:
        {
            // Use the progressTintColors to defines the colors of the progress bar
            NSArray *tintColors                 = @[[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
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
            _progressView.progressTintColors    = tintColors;
            _progressView.stripesOrientation    = YLProgressBarStripesOrientationRight;
            _progressView.behavior              = YLProgressBarBehaviorDefault;
            _progressView.stripesColor          = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.28f];
            [[YLProgressBar appearance] setProgressTintColors:tintColors];
            break;
        }
        case 1:
        {
            _progressView.progressTintColor     = [UIColor redColor];
            _progressView.stripesOrientation    = YLProgressBarStripesOrientationRight;
            _progressView.behavior              = YLProgressBarBehaviorIndeterminate;
            _progressView.stripesColor          = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.28f];
            break;
        }
        case 2:
        {
            _progressView.progressTintColor     = [UIColor cyanColor];
            _progressView.stripesOrientation    = YLProgressBarStripesOrientationRight;
            _progressView.behavior              = YLProgressBarBehaviorWaiting;
            _progressView.stripesColor          = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.28f];
            break;
        }
        case 3:
        {
            _progressView.progressTintColor     = [UIColor greenColor];
            _progressView.stripesOrientation    = YLProgressBarStripesOrientationLeft;
            _progressView.behavior              = YLProgressBarBehaviorDefault;
            _progressView.stripesColor          = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.28f];
            break;
        }
        case 4:
        {
            _progressView.progressTintColor     = [UIColor yellowColor];
            _progressView.stripesOrientation    = YLProgressBarStripesOrientationRight;
            _progressView.stripesOrientation    = YLProgressBarStripesOrientationVertical;
            _progressView.behavior              = YLProgressBarBehaviorDefault;
            _progressView.stripesColor          = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.28f];
            break;
        }
        default:
            break;
    }
    
    [self changeProgressValue];
}

#pragma mark YLViewController Private Methods

@end
