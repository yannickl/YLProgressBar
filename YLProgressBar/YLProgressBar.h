/*
 * YLProgressBar.h
 *
 * Copyright 2012 - present, Yannick Loriot.
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

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Global
#define YLProgressBarDefaultStripeWidth 7 //px
#define YLProgressBarDefaultStripeDelta 8 //px

/**
 * The progress bar appearance.
 */
typedef NS_ENUM (NSUInteger, YLProgressBarType)
{
  /**
   * The progress bar has rounded corners and the gloss effect by default.
   */
  YLProgressBarTypeRounded = 0,
  /**
   * The progress bar has squared corners and no gloss.
   */
  YLProgressBarTypeFlat    = 1,
};

/**
 * The stripes orientation.
 */
typedef NS_ENUM (NSUInteger, YLProgressBarStripesOrientation)
{
  /**
   * The stripes are obliques in the north-west direction.
   */
  YLProgressBarStripesOrientationRight    = 0,
  /**
   * The stripes are obliques in the south-west direction.
   */
  YLProgressBarStripesOrientationLeft     = 1,
  /**
   * The stripes are verticals.
   */
  YLProgressBarStripesOrientationVertical = 2,
};

/**
 * The stripes movement direction.
 */
typedef NS_ENUM (NSInteger, YLProgressBarStripesDirection)
{
  /**
   * The stripes go from right to left.
   */
  YLProgressBarStripesDirectionLeft  = -1,
  /**
   * The stripes go from left to right.
   */
  YLProgressBarStripesDirectionRight = 1
};

/**
 * The behavior of a progress bar.
 */
typedef NS_ENUM (NSUInteger, YLProgressBarBehavior)
{
  /**
   * The default behavior of a progress bar. This mode is identical to the
   * UIProgressView.
   */
  YLProgressBarBehaviorDefault       = 0,
  /**
   * The indeterminate behavior display the stripes when the progress value is
   * equal to 0 only. This mode is helpful when percentage is not yet known,
   * but will be known shortly.
   */
  YLProgressBarBehaviorIndeterminate = 1,
  /**
   * The waiting behavior display the stripes when the progress value is equal
   * to 1 only.
   */
  YLProgressBarBehaviorWaiting       = 2,
};

/**
 * The display mode of the indicator text.
 */
typedef NS_ENUM (NSUInteger, YLProgressBarIndicatorTextDisplayMode)
{
  /**
   * The indicator text is not displayed.
   */
  YLProgressBarIndicatorTextDisplayModeNone     = 0,
  /**
   * The indicator text is displayed over the track bar and below the progress
   * bar.
   */
  YLProgressBarIndicatorTextDisplayModeTrack    = 1,
  /**
   * The indicator text is diplayed over the progress bar.
   */
  YLProgressBarIndicatorTextDisplayModeProgress = 2,
  /**
   * The indicator text is displayed over the track bar and over the progress
   * bar in the right.
   */
  YLProgressBarIndicatorTextDisplayModeFixedRight = 3
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
 *
 * <em>Note: The YLProgressBar is conform to the UIAppearance protocol, however,
 * because of the current version of the appledoc project, the
 * UI_APPEARANCE_SELECTOR macros are not taken into account, that's why they
 * are commented.</em>
 */
IB_DESIGNABLE @interface YLProgressBar : UIView

#pragma mark Managing the Progress Bar
/** @name Managing the Progress Bar */

/**
 * @abstract The current progress shown by the receiver.
 * @discussion The current progress is represented by a floating-point value
 * between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the
 * task.
 *
 * The default value is 0.3. Values less than 0.0 and greater than 1.0 are
 * pinned to those limits.
 */
@property (atomic, assign) IBInspectable CGFloat progress;

/**
 * @abstract Adjusts the current progress shown by the receiver, optionally
 * animating the change.
 * @param progress The new progress value.
 * @param animated YES if the change should be animated, NO if the change should
 * happen immediately.
 * @discussion The current progress is represented by a floating-point value
 * between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the
 * task.
 * The default value is 0.0. Values less than 0.0 and greater than 1.0 are
 * pinned to those limits.
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
@property (nonatomic, assign) IBInspectable YLProgressBarBehavior behavior; //UI_APPEARANCE_SELECTOR;

#pragma mark Configuring the Progress Bar
/** @name Configuring the Progress Bar */

/**
 * @abstract A Boolean value that determines whether the gloss effet (outer and
 * inner one) is hidden.
 * @discussion Setting the value of this property to YES hides the gloss effect
 * and setting it to NO shows the gloss effect whatever the progress type
 * (`YLProgressBarTypeRounded` or `YLProgressBarTypeFlat`). The value is updated
 * each time the type change.
 */
@property (nonatomic, assign) IBInspectable BOOL hideGloss;

/**
 * @abstract A Boolean value that determines whether the progress bar needs 
 * stretch when the value change.
 * @discussion Setting the value of this property to YES means that the colors
 * of the `progressTintColors` is stretched.
 *
 * For example the `progressTintColors` is equal to `[blue, yellow, red]` and
 * the `value` is set to 50%.
 * If the progress bar is stretch the progress bar looks like that:
 * `|-blue.yellow.red-----------|`
 * Otherwise it should looks like that:
 * `|-blue.....yellow-----------|`
 *
 * The default value is set to YES.
 */
@property (nonatomic, assign) IBInspectable BOOL progressStretch;

/**
 * @abstract Set whether the color shown for the portion of the progress bar that is uniform.
 * @discussion The default value is NO.
 */
@property (nonatomic, assign) IBInspectable BOOL uniformTintColor; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The colors shown for the portion of the progress bar
 * that is filled.
 * @discussion All the colors in the array are drawn as a gradient
 * visual of equal size.
 */
@property (nonatomic, strong, nonnull) NSArray *progressTintColors; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The color shown for the portion of the progress bar that is filled.
 */
@property (nonatomic, strong, nonnull) IBInspectable UIColor *progressTintColor; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The color shown for the portion of the progress bar that is not
 * filled.
 */
@property (nonatomic, strong, nonnull) IBInspectable UIColor *trackTintColor; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract A CGFloat value that determines the inset between the track and the
 * progressBar for the rounded progress bar type.
 * @discussion The default value is 1px.
 */
@property (nonatomic, assign) IBInspectable CGFloat progressBarInset; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The type of the progress bar.
 * @discussion The default value is set to `YLProgressBarTypeRounded`. The corner 
 * radius can be configured through the `cornerRadius` property.
 */
@property (nonatomic, assign) IBInspectable YLProgressBarType type; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The corner radius of the progress bar.
 * @discussion The default value is 0. It means that the corner radius is equal
 * to the half of the height.
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius; //UI_APPEARANCE_SELECTOR;

#pragma mark Displaying Text
/** @name Displaying Text */

/**
 * @abstract A label to display some indications for the user.
 * When the label text is set to nil it shows the progress value as a percentage
 * You can configure its font color, the font size, the text alignement, etc. as
 * any other labels.
 * @discussion By default the label text is set to nil and its text color change
 * using the background color.
 */
@property (nonatomic, strong, nonnull) UILabel *indicatorTextLabel;

/**
 * @abstract The display indicator text mode. It defines where the indicator
 * text needs to display.
 * @discussion The default value is set to
 * `YLProgressBarIndicatorTextDisplayModeNone`.
 */
@property (nonatomic, assign) IBInspectable YLProgressBarIndicatorTextDisplayMode indicatorTextDisplayMode; //UI_APPEARANCE_SELECTOR;

#pragma mark Configuring the Stripes
/** @name Configuring the Stripes */

/**
 * @abstract The animated vs. nonanimated stripes of the progress bar.
 * @discussion If YES, the stripes over the progress bar is moving from the left
 * to the right side.
 *
 * The default value for this property is YES.
 */
@property (nonatomic, getter = isStripesAnimated) IBInspectable BOOL stripesAnimated;

/**
 * @abstract The direction of the movement during the animation.
 * @discussion The default value for this property is
 * `YLProgressBarStripesDirectionRight`.
 */
@property (nonatomic, assign) IBInspectable YLProgressBarStripesDirection stripesDirection; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The velocity of the stripes during the animation. Higher is the
 * value, greater the distance traveled by the stripes during a frame is.
 * @discussion The absolute value of the property is taken into account. By
 * default the velocity is `1`.
 */
@property (nonatomic, assign) IBInspectable double stripesAnimationVelocity; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The orientation of the stripes.
 * @discussion The default value for this property is
 * `YLProgressBarStripesOrientationRight`.
 */
@property (nonatomic, assign) IBInspectable YLProgressBarStripesOrientation stripesOrientation; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The width of the stripes drawn over the progress bar.
 * @discussion If the property is less or equal than 0 the sprites are hidden.
 *
 * The default value for this property is equal to the
 * `YLProgressBarDefaultStripeWidth` value.
 */
@property (nonatomic, assign) IBInspectable NSInteger stripesWidth; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The color show for the stripes over the progress bar.
 */
@property (nonatomic, strong, nonnull) IBInspectable UIColor *stripesColor; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract The x-coordinate distance in pixels between the top point and the
 * bottom point of a slanted stripe.
 * @discussion Default value is `YLProgressBarDefaultStripeDelta`. Positive
 * integers are expected for correct effect. Has no effect when
 * stripesOrientation property is `YLProgressBarStripesOrientationVertical`.
 */
@property (nonatomic, assign) IBInspectable NSInteger stripesDelta; //UI_APPEARANCE_SELECTOR;

/**
 * @abstract A Boolean value that determines whether the stripes are hidden.
 * @discussion Setting the value of this property to YES hides the stripes and
 * setting it to NO shows the stripes. The default value is NO.
 */
@property (nonatomic, assign) IBInspectable BOOL hideStripes;

/**
 * @abstract A Boolean value that determines whether the track is hidden.
 * @discussion Setting the value of this property to YES hides the track and
 * setting it to NO shows the track. The default value is NO.
 */
@property (nonatomic, assign) IBInspectable BOOL hideTrack;

@end

//! Project version number for YLProgressBar.
FOUNDATION_EXPORT double YLProgressBarVersionNumber;

//! Project version string for YLProgressBar.
FOUNDATION_EXPORT const unsigned char YLProgressBarVersionString[];