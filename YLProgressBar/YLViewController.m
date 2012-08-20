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
@synthesize progressView;
@synthesize progressValueLabel;
@synthesize typeButton;
@synthesize stripeButton;
@synthesize progressTimer;

- (void)dealloc
{
    [stripeButton release];
    [typeButton release];
    if (progressTimer && [progressTimer isValid])
    {
        [progressTimer invalidate];
    }
    
    SAFE_ARC_RELEASE (progressTimer);
    SAFE_ARC_RELEASE (progressValueLabel);
    SAFE_ARC_RELEASE (progressView);
    
    SAFE_ARC_SUPER_DEALLOC ();
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self typeButtonTapped:typeButton];
    [self stripeButtonTapped:stripeButton];
}

- (void)viewDidUnload
{
    [self setProgressValueLabel:nil];
    [self setProgressView:nil];
    [self setTypeButton:nil];
    [self setStripeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    float progressValue = progressView.progress;
    
    progressValue       += 0.01f;
    if (progressValue > 1)
    {
        progressValue = 0;
    }
    
    
    [progressValueLabel setText:[NSString stringWithFormat:@"%.0f%%", (progressValue * 100)]];
    [progressView setProgress:progressValue];
}

- (IBAction)colorButtonTapped:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
            progressView.progressTintColor = [UIColor purpleColor];
            break;
        case 1:
            progressView.progressTintColor = [UIColor redColor];
            break;
        case 2:
            progressView.progressTintColor = [UIColor cyanColor];
            break;
        case 3:
            progressView.progressTintColor = [UIColor greenColor];
            break;
        case 4:
            progressView.progressTintColor = [UIColor yellowColor];
            break;
            
        default:
            break;
    }
}

- (IBAction)typeButtonTapped:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.progressTimer invalidate];
            self.progressTimer = nil;
            [progressView setIndeterminate:YES];
            progressValueLabel.text = @"Loading...";
            break;
        case 1:
            [progressView setIndeterminate:NO];
            if (self.progressTimer == nil) {
                self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f 
                                                                      target:self 
                                                                    selector:@selector(changeProgressValue)
                                                                    userInfo:nil
                                                                     repeats:YES];
            }
            break;
        case 2:
            [progressView setIndeterminate:NO];
            [self.progressTimer invalidate];
            self.progressTimer = nil;
            break;            
            
    }
}

- (IBAction)stripeButtonTapped:(UISegmentedControl *)sender {
    switch ([(UISegmentedControl*)sender selectedSegmentIndex]) {
        case 0:
            progressView.showsStripes = YES;
            progressView.animated = NO;
            break;
        case 1:
            progressView.showsStripes = YES;
            progressView.animated = YES;
            break;
        case 2:
            progressView.showsStripes = NO;
            progressView.animated = NO;
            break;
    }
}

- (IBAction)roundedChanged:(UISwitch *)sender {
    progressView.isRound = sender.on;
}

- (IBAction)gradientChanged:(UISwitch *)sender {
    progressView.usesGradient = sender.on;
}

#pragma mark YLViewController Private Methods

@end
