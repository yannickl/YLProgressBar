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

typedef NS_ENUM(NSUInteger, YLProgressBarStripesOrientation)
{
    YLProgressBarStripesOrientationLeft  = 0,
    YLProgressBarStripesOrientationRight = 1,
};

typedef NS_ENUM(NSUInteger, YLProgressBarBehavior)
{
    YLProgressBarBehaviorDefault       = 0,
    YLProgressBarBehaviorIndeterminate = 1,
    YLProgressBarBehaviorWaiting       = 2,
};

/**
 * The YLProgressBar is an UIProgressView replacement with an highly and fully 
 * customizable animated progress bar.
 *
 * The YLProgressBar class provides properties for managing the style of the
 * track and the progress bar, managun its behavior and for getting and setting
 * values that are pinned to the progress of a task.
 *
 * Unlike the UIProgressView, the YLProgressBar can be used for as an
 * indeterminate progress indicator thanks to its pre-made behaviors.
 */
@interface YLProgressBar : UIView

#pragma mark Managing the Progress Bar
/** @name Managing the Progress Bar */

/**
 * @abstract The current progress shown by the receiver.
 * @discussion The current progress is represented by a floating-point value
 * between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the 
 * task.
 *
 * The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned 
 * to those limits.
 */
@property (atomic, assign) CGFloat  progress;

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

#pragma mark Modifying the Progress Bar’s Behavior
/** @name Modifying the Progress Bar’s Behavior */

/**
 * @abstract The behavior of the progress bar.
 * A behavior defines how the progress bar needs to react in certain cases.
 * For example the "default" behavior of the progress bar displays the stripes
 * everytime whereas the "waiting" behavior displays them only when the
 * progress value is nearby the max value.
 *
 * @discussion The default value is YLProgressBarBehaviorDefault.
 */
@property (nonatomic, assign) YLProgressBarBehavior behavior;

#pragma mark Configuring the Progress Bar
/** @name Configuring the Progress Bar */

/**
 * @abstract The animated vs. nonanimated stripes of the progress
 * bar.
 * @discussion If YES, the stripes over the progress bar is moving
 * from the left to the right side.
 *
 * The default value for this property is YES.
 */
@property (nonatomic, getter = isStripesAnimated) BOOL  stripesAnimated;

/**
 * @abstract The orientation of the stripes.
 * @discussion The default value for this property is 
 * YLProgressBarStripesOrientationRight.
 */
@property (nonatomic, assign) YLProgressBarStripesOrientation   stripesOrientation;

/**
 * @abstract The width of the stripes drawn over the progress bar.
 * @discussion If the property is less or equal than 0 the sprites are
 * hidden.
 *
 * The default value for this property is equal to the 
 * YLProgressBarDefaultStripeWidth value.
 */
@property (nonatomic, assign) NSInteger stripesWidth;

/**
 * @abstract A Boolean value that determines whether the stripes are hidden.
 * @discussion Setting the value of this property to YES hides the stripes and
 * setting it to NO shows the stripes. The default value is NO.
 */
@property (nonatomic, assign) BOOL hideStripes;

/**
 * @abstract The colors shown for the portion of the progress bar
 * that is filled.
 * @discussion All the colors in the array are drawn as a gradient
 * visual of equal size.
 */
@property (nonatomic, strong) NSArray   *progressTintColors;

/**
 * @abstract The color shown for the portion of the progress bar that is filled.
 */
@property (nonatomic, strong) UIColor   *progressTintColor;

/**
 * @abstract The color shown for the portion of the progress bar that is not filled.
 */
@property (nonatomic, strong) UIColor   *trackTintColor;

@end
