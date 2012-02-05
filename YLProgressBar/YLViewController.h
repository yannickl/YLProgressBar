//
//  YLViewController.h
//  YLProgressBar
//
//  Created by Yannick Loriot on 05/02/12.
//  Copyright (c) 2012 Yannick Loriot. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ARCMacro.h"

@class YLProgressBar;

@interface YLViewController : UIViewController
{
@protected
    NSTimer*    progressTimer;
}
@property (nonatomic, SAFE_ARC_PROP_RETAIN) IBOutlet YLProgressBar* progressView;
@property (nonatomic, SAFE_ARC_PROP_RETAIN) IBOutlet UILabel*       progressValueLabel;

#pragma mark Constructors - Initializers

#pragma mark Public Methods

@end
