/*
 * YLProgressBar.h
 *
 * Copyright 2012-2013 Yannick Loriot.
 * http://yannickloriot.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <UIKit/UIKit.h>

// Global
#define YLProgressBarDefaultStripeWidth     7

typedef enum
{
    YLProgressBarStripeOrientationLeft,
    YLProgressBarStripeOrientationRight
} YLProgressBarStripeOrientation;

/**
 * Custom UIProgressView for iOS (5.0 or over) with a customizable and animated
 * progress bar.
 */
@interface YLProgressBar : UIProgressView

/**
 * @abstract The colors shown for the portion of the progress bar
 * that is filled. All the colors available in the array are drawn
 * as a gradient of equal size.
 */
@property (nonatomic, retain) NSArray                           *progressTintColors;

/**
 * @abstract The animated vs. nonanimated stripes of the progress
 * bar.
 * @discussion If YES, the stripes over the progress bar is moving
 * from the left to the right side.
 *
 * The default value for this property is YES.
 */
@property (nonatomic, getter = isProgressStripeAnimated) BOOL   progressStripeAnimated;

/**
 * @abstract The width of the progress stripes drawn over the progress
 * bar.
 * @discussion If the property is less or equal than 0 the sprites are
 * hidden.
 *
 * The default value for this property is equal to the YLProgressBarDefaultStripeWidth
 * value.
 */
@property (nonatomic, assign) NSInteger                         progressStripeWidth;

#pragma mark Constructors - Initializers

#pragma mark Public Methods

@end
