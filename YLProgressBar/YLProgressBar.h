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

// Global
#define YLProgressBarDefaultStripeWidth     7 //px

typedef enum
{
    YLProgressBarStripeOrientationLeft,
    YLProgressBarStripeOrientationRight
} YLProgressBarStripeOrientation;

/**
 * Custom UIProgressView for iOS (5.0 or over) with a customizable and animated
 * progress bar.
 */
@interface YLProgressBar : UIView

/**
 * @abstract The colors shown for the portion of the progress bar
 * that is filled.
 * @discussion All the colors in the array are drawn as a gradient
 * visual of equal size.
 */
@property (nonatomic, strong) NSArray   *progressTintColors;

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
 * @abstract The orientation of the stripes.
 * @discussion 
 * The default value for this property is YLProgressBarStripeOrientationRight.
 */
@property (nonatomic, assign) YLProgressBarStripeOrientation    progressStripeOrientation;

/**
 * @abstract The width of the progress stripes drawn over the progress
 * bar.
 * @discussion If the property is less or equal than 0 the sprites are
 * hidden.
 *
 * The default value for this property is equal to the YLProgressBarDefaultStripeWidth
 * value.
 */
@property (nonatomic, assign) NSInteger progressStripeWidth;

/**
 * @abstract A Boolean value that determines whether the stripes are hidden.
 * @discussion Setting the value of this property to YES hides the stripes and setting
 * it to NO shows the stripes. The default value is NO.
 */
@property (nonatomic, assign) BOOL hideStripes;

/**
 * @abstract The current progress shown by the receiver.
 * @discussion The current progress is represented by a floating-point 
 * value between 0.0 and 1.0, inclusive, where 1.0 indicates the 
 * completion of the task.
 *
 * The default value is 0.0. Values less than
 * 0.0 and greater than 1.0 are pinned to those limits.
 */
@property (atomic, assign) CGFloat  progress;

/**
 * @abstract The color shown for the portion of the progress bar that is filled.
 */
@property (nonatomic, strong) UIColor   *progressTintColor;

/**
 * @abstract The color shown for the portion of the progress bar that is not filled.
 */
@property (nonatomic, strong) UIColor   *trackTintColor;

#pragma mark Constructors - Initializers

#pragma mark Public Methods

/**
 * @abstract Adjusts the current progress shown by the receiver, optionally 
 * animating the change.
 * @param progress The new progress value.
 * @param animated YES if the change should be animated, NO if the change should
 * happen immediately.
 * @discussion The current progress is represented by a floating-point value 
 * between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task.
 * The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned 
 * to those limits.
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
