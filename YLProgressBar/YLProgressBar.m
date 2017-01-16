/*
 * YLProgressBar.m
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

#import "YLProgressBar.h"

// Sizes
const NSInteger YLProgressBarDefaultSizeInset = 1; //px

// Animation times
const NSTimeInterval YLProgressBarStripesAnimationTime = 1.0f / 30.0f; // s
const NSTimeInterval YLProgressBarProgressTime         = 0.25f;        // s

// Font name
static NSString * YLProgressBarDefaultName = @"Arial-BoldMT";

// Default progress value
const CGFloat YLProgressBarDefaultProgress = 0.3f;

@interface YLProgressBar ()
@property (nonatomic, assign) double  stripesOffset;
@property (nonatomic, assign) CGFloat internalCornerRadius;
@property (nonatomic, strong) NSTimer *stripesTimer;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSTimer *progressTargetTimer;
@property (nonatomic, assign) CGFloat progressTargetValue;

/** Init the progress bar with the default values. */
- (void)initializeProgressBar;

/** Build the stripes using the given parameters. */
- (UIBezierPath *)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame orientation:(YLProgressBarStripesOrientation)orientation;

/** Draw the background (track) of the slider. */
- (void)drawTrack:(CGContextRef)context withRect:(CGRect)rect;
/** Draw the progress bar. */
- (void)drawProgressBar:(CGContextRef)context withInnerRect:(CGRect)innerRect outterRect:(CGRect)outterRect;
/** Draw the gloss into the given rect. */
- (void)drawGloss:(CGContextRef)context withRect:(CGRect)rect;
/** Draw the stipes into the given rect. */
- (void)drawStripes:(CGContextRef)context withRect:(CGRect)rect;
/** Draw the given text into the given location of the rect. */
- (void)drawText:(CGContextRef)context withRect:(CGRect)rect;

/** Callback for the setProgress:Animated: animation timer. */
- (void)updateProgressWithTimer:(NSTimer *)timer;

@end

@implementation YLProgressBar
@synthesize progress = _progress;

- (void)dealloc
{
  if (_stripesTimer && [_stripesTimer isValid])
  {
    [_stripesTimer invalidate];
  }
  if (_progressTargetTimer && [_progressTargetTimer isValid])
  {
    [_progressTargetTimer invalidate];
  }

  [self removeObserver:self forKeyPath:@"stripesAnimated"];
  [self removeObserver:self forKeyPath:@"hideStripes"];
}

- (id)initWithFrame:(CGRect)frameRect
{
  if ((self = [super initWithFrame:frameRect]))
  {
    [self initializeProgressBar];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
  {
    [self initializeProgressBar];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGFloat height           = CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bounds) / 3;
  _indicatorTextLabel.font = [UIFont fontWithName:YLProgressBarDefaultName size: height];
}

- (void)drawRect:(CGRect)rect
{
  if (self.isHidden)
  {
    return;
  }

  CGContextRef context = UIGraphicsGetCurrentContext();

  // Refresh the corner radius value
  self.internalCornerRadius = 0;

  if (_type == YLProgressBarTypeRounded) {
    if (_cornerRadius > 0) {
      self.internalCornerRadius = _cornerRadius;
    }
    else {
      self.internalCornerRadius = rect.size.height / 2;
    }
  }

  // Compute the progressOffset for the stripe's animation
  self.stripesOffset = (!_stripesAnimated || fabs(self.stripesOffset) > 2 * _stripesWidth - 1) ? 0 : self.stripesDirection * fabs(self.stripesAnimationVelocity) + self.stripesOffset;

  // Draw the background track
  if (!_hideTrack)
  {
    [self drawTrack:context withRect:rect];
  }

  // Draw the indicator text if necessary
  if (_indicatorTextDisplayMode == YLProgressBarIndicatorTextDisplayModeTrack)
  {
    [self drawText:context withRect:rect];
  }

  // Compute the inner rectangle
  CGRect innerRect;
  if (_type == YLProgressBarTypeRounded)
  {
    innerRect = CGRectMake(_progressBarInset,
                           _progressBarInset,
                           CGRectGetWidth(rect) * self.progress - 2 * _progressBarInset,
                           CGRectGetHeight(rect) - 2 * _progressBarInset);
  } else
  {
    innerRect = CGRectMake(0, 0, CGRectGetWidth(rect) * self.progress, CGRectGetHeight(rect));
  }

  if (self.progress == 0 && _behavior == YLProgressBarBehaviorIndeterminate)
  {
    [self drawStripes:context withRect:rect];
  } else if (self.progress > 0)
  {
    [self drawProgressBar:context withInnerRect:innerRect outterRect:rect];

    if (_stripesWidth > 0 && !_hideStripes)
    {
      if (_behavior == YLProgressBarBehaviorWaiting)
      {
        if (self.progress == 1.0f)
        {
          [self drawStripes:context withRect:innerRect];
        }
      } else if (_behavior != YLProgressBarBehaviorIndeterminate)
      {
        [self drawStripes:context withRect:innerRect];
      }
    }

    if (!_hideGloss)
    {
      [self drawGloss:context withRect:innerRect];
    }

    // Draw the indicator text if necessary
    if (_indicatorTextDisplayMode == YLProgressBarIndicatorTextDisplayModeProgress)
    {
      [self drawText:context withRect:innerRect];
    }
  }

  // Draw the indicator text if necessary
  if (_indicatorTextDisplayMode == YLProgressBarIndicatorTextDisplayModeFixedRight)
  {
    [self drawText:context withRect:rect];
  }
}

#pragma mark - Properties

- (void)setType:(YLProgressBarType)type {
  _type = type;

  switch (type) {
    case YLProgressBarTypeRounded:
      _hideGloss = NO;
      break;
    default:
      _hideGloss = YES;
      break;
  }
}

- (CGFloat)progress
{
  @synchronized (self)
  {
    return _progress;
  }
}

- (void)setProgress:(CGFloat)progress
{
  [self setProgress:progress animated:NO];
}

- (void)setBehavior:(YLProgressBarBehavior)behavior
{
  _behavior = behavior;

  [self setNeedsDisplay];
}

- (void)setUniformTintColor:(BOOL)isUniformTintColor
{
  _uniformTintColor = isUniformTintColor;

  [self setProgressTintColor:_progressTintColor];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
  progressTintColor  = (progressTintColor) ? progressTintColor : [UIColor blueColor];
  _progressTintColor = progressTintColor;

  if (_uniformTintColor)
  {
    [self setProgressTintColors:@[_progressTintColor, _progressTintColor]];
  }
  else
  {
    const CGFloat *c    = CGColorGetComponents(progressTintColor.CGColor);
    UIColor *leftColor  = [UIColor colorWithRed:(c[0] / 2.0f) green:(c[1] / 2.0f) blue:(c[2] / 2.0f) alpha:(c[3])];
    UIColor *rightColor = progressTintColor;
    NSArray *colors     = @[leftColor, rightColor];

    [self setProgressTintColors:colors];
  }
}

- (void)setProgressTintColors:(NSArray *)progressTintColors
{
  NSAssert(progressTintColors, @"progressTintColors must not be null");
  NSAssert([progressTintColors count], @"progressTintColors must contain at least one element");

  if (_progressTintColors != progressTintColors)
  {
    _progressTintColors = progressTintColors;
  }

  NSMutableArray *colors  = [NSMutableArray arrayWithCapacity:[progressTintColors count]];
  for (UIColor *color in progressTintColors)
  {
    [colors addObject:(id)color.CGColor];
  }
  self.colors = colors;
}

#pragma mark - Public Methods

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
  @synchronized (self)
  {
    if (_progressTargetTimer && [_progressTargetTimer isValid])
    {
      [_progressTargetTimer invalidate];
    }

    CGFloat newProgress = progress;
    if (newProgress > 1.0f)
    {
      newProgress = 1.0f;
    } else if (newProgress < 0.0f)
    {
      newProgress = 0.0f;
    }

    if (animated)
    {
      _progressTargetValue     = newProgress;
      CGFloat incrementValue   = ((_progressTargetValue - _progress) * YLProgressBarStripesAnimationTime) / YLProgressBarProgressTime;
      self.progressTargetTimer = [NSTimer timerWithTimeInterval:YLProgressBarStripesAnimationTime
                                                         target:self
                                                       selector:@selector(updateProgressWithTimer:)
                                                       userInfo:[NSNumber numberWithFloat:incrementValue]
                                                        repeats:YES];
      [[NSRunLoop currentRunLoop] addTimer:_progressTargetTimer forMode:NSRunLoopCommonModes];
    } else
    {
      _progress = newProgress;

      [self setNeedsDisplay];
    }
  }
}

#pragma mark - Private Methods

- (void)updateProgressWithTimer:(NSTimer *)timer
{
  CGFloat dt_progress = [timer.userInfo floatValue];

  _progress += dt_progress;

  if ((dt_progress < 0 && _progress <= _progressTargetValue)
      || (dt_progress > 0 && _progress >= _progressTargetValue))
  {
    [_progressTargetTimer invalidate];
    _progressTargetTimer = nil;

    _progress = _progressTargetValue;
  }

  [self setNeedsDisplay];
}

- (void)initializeProgressBar
{
  [self addObserver:self forKeyPath:@"hideStripes" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"stripesAnimated" options:NSKeyValueObservingOptionNew context:nil];

  _type            = YLProgressBarTypeRounded;
  _progressStretch = YES;
  _hideGloss       = NO;
  _progress        = YLProgressBarDefaultProgress;
  _hideStripes     = NO;
  _hideTrack       = NO;
  _behavior        = YLProgressBarBehaviorDefault;
  _stripesColor    = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.28f];
  _cornerRadius    = 0;

  _indicatorTextLabel                           = [[UILabel alloc] initWithFrame:self.frame];
  _indicatorTextLabel.adjustsFontSizeToFitWidth = YES;
  _indicatorTextLabel.backgroundColor           = [UIColor clearColor];
  _indicatorTextLabel.textAlignment             = NSTextAlignmentRight;
  _indicatorTextLabel.lineBreakMode             = NSLineBreakByTruncatingHead;
  _indicatorTextLabel.textColor                 = [UIColor clearColor];
  _indicatorTextLabel.minimumScaleFactor        = 3;

  _indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeNone;

  self.trackTintColor           = [UIColor blackColor];
  self.progressTintColor        = self.backgroundColor;
  self.stripesOffset            = 0;
  self.stripesTimer             = nil;
  self.stripesAnimated          = YES;
  self.stripesOrientation       = YLProgressBarStripesOrientationRight;
  self.stripesDirection         = YLProgressBarStripesDirectionRight;
  self.stripesAnimationVelocity = 1;
  self.stripesWidth             = YLProgressBarDefaultStripeWidth;
  self.stripesDelta             = YLProgressBarDefaultStripeDelta;
  self.progressBarInset         = YLProgressBarDefaultSizeInset;
  self.backgroundColor          = [UIColor clearColor];
}

- (UIBezierPath *)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame orientation:(YLProgressBarStripesOrientation)orientation
{
  CGFloat height     = CGRectGetHeight(frame);
  UIBezierPath *rect = [UIBezierPath bezierPath];

  [rect moveToPoint:origin];

  switch (orientation)
  {
    case YLProgressBarStripesOrientationRight:
      [rect addLineToPoint:CGPointMake(origin.x + _stripesWidth, origin.y)];
      [rect addLineToPoint:CGPointMake(origin.x + _stripesWidth - _stripesDelta, origin.y + height)];
      [rect addLineToPoint:CGPointMake(origin.x - _stripesDelta, origin.y + height)];
      break;
    case YLProgressBarStripesOrientationLeft:
      [rect addLineToPoint:CGPointMake(origin.x - _stripesWidth, origin.y)];
      [rect addLineToPoint:CGPointMake(origin.x - _stripesWidth + _stripesDelta, origin.y + height)];
      [rect addLineToPoint:CGPointMake(origin.x + _stripesDelta, origin.y + height)];
      break;
    default:
      [rect addLineToPoint:CGPointMake(origin.x - _stripesWidth, origin.y)];
      [rect addLineToPoint:CGPointMake(origin.x - _stripesWidth, origin.y + height)];
      [rect addLineToPoint:CGPointMake(origin.x, origin.y + height)];
      break;
  }

  [rect addLineToPoint:origin];
  [rect closePath];

  return rect;
}

- (void)drawTrack:(CGContextRef)context withRect:(CGRect)rect
{
  // Define the progress bar pattern to clip all the content inside
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))
                                                         cornerRadius:_internalCornerRadius];
  [roundedRect addClip];

  CGContextSaveGState(context);
  {
    CGFloat trackWidth  = CGRectGetWidth(rect);
    CGFloat trackHeight = CGRectGetHeight(rect);

    if (_type == YLProgressBarTypeRounded && !_hideGloss)
    {
      trackHeight -= 1;
      trackWidth  -= 1;
    }

    // Draw the track
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, trackWidth, trackHeight) cornerRadius:_internalCornerRadius];
    [_trackTintColor set];
    [roundedRect fill];

    if (_type == YLProgressBarTypeRounded)
    {
      // Draw the white shadow
      [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2] set];

      UIBezierPath *shadow = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5f, 0, trackWidth, trackHeight)
                                                        cornerRadius:_internalCornerRadius];
      [shadow stroke];

      if (!_hideGloss)
      {
        // Draw the inner glow
        [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f] set];

        UIBezierPath *glow = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_internalCornerRadius, 0, CGRectGetWidth(rect) - _internalCornerRadius * 2, 1)
                                                        cornerRadius:0];
        [glow stroke];
      }
    }
  }
  CGContextRestoreGState(context);
}

- (void)drawProgressBar:(CGContextRef)context withInnerRect:(CGRect)innerRect outterRect:(CGRect)outterRect
{
  CGRect gradientRect = _progressStretch ? innerRect : outterRect;

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

  CGContextSaveGState(context);
  {
    UIBezierPath *progressBounds = [UIBezierPath bezierPathWithRoundedRect:innerRect cornerRadius:_internalCornerRadius];
    CGContextAddPath(context, [progressBounds CGPath]);
    CGContextClip(context);

    CFArrayRef colorRefs  = (__bridge CFArrayRef)_colors;
    NSUInteger colorCount = [_colors count];

    CGFloat delta      = 1.0f / [_colors count];
    CGFloat semi_delta = delta / 2.0f;
    CGFloat locations[colorCount];

    for (NSInteger i = 0; i < colorCount; i++)
    {
      locations[i] = delta * i + semi_delta;
    }

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorRefs, locations);

    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMinX(gradientRect), CGRectGetMinY(gradientRect)), CGPointMake(CGRectGetMinX(gradientRect) + CGRectGetWidth(gradientRect), CGRectGetMinY(gradientRect)), (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));

    CGGradientRelease(gradient);
  }
  CGContextRestoreGState(context);

  CGColorSpaceRelease(colorSpace);
}

- (void)drawGloss:(CGContextRef)context withRect:(CGRect)rect
{
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

  CGContextSaveGState(context);
  {
    CGRect fillRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, floorf(rect.size.height / 3));

    // Draw the gloss
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextBeginTransparencyLayerWithRect(context, fillRect, NULL);
    {
      const CGFloat glossGradientComponents[] = {1.0f, 1.0f, 1.0f, 0.16f, 1.0f, 1.0f, 1.0f, 0.16f};
      const CGGradientRef glossGradient       = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, NULL, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
      CGPoint startPoint                      = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
      CGPoint endPoint                        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
      CGContextDrawLinearGradient(context, glossGradient, startPoint, endPoint, 0);
      CGGradientRelease(glossGradient);
    }
    CGContextEndTransparencyLayer(context);

    // Draw the gloss's drop shadow
    CGContextSetBlendMode(context, kCGBlendModeSoftLight);
    CGContextBeginTransparencyLayer(context, NULL);
    {
      const CGFloat glossDropShadowComponents[] = {0.0f, 0.0f, 0.0f, 0.16f, 0.0f, 0.0f, 0.0f, 0.0f};
      CGColorRef glossDropShadowColor           = CGColorCreate(colorSpace, glossDropShadowComponents);

      CGContextSaveGState(context);
      {
        CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 4, glossDropShadowColor);
        CGContextFillRect(context, fillRect);
        CGColorRelease(glossDropShadowColor);
      }
      CGContextRestoreGState(context);

      CGContextSetBlendMode(context, kCGBlendModeClear);
      CGContextFillRect(context, fillRect);
    }
    CGContextEndTransparencyLayer(context);
  }
  CGContextRestoreGState(context);

  // Draw progress bar glow
  CGContextSaveGState(context);
  {
    UIBezierPath *progressBounds = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_internalCornerRadius];
    CGContextAddPath(context, [progressBounds CGPath]);

    const CGFloat progressBarGlowComponents[] = {1.0f, 1.0f, 1.0f, 0.16f};
    CGColorRef progressBarGlowColor           = CGColorCreate(colorSpace, progressBarGlowComponents);

    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextSetStrokeColorWithColor(context, progressBarGlowColor);
    CGContextSetLineWidth(context, 2.0f);
    CGContextStrokePath(context);
    CGColorRelease(progressBarGlowColor);
  }
  CGContextRestoreGState(context);

  CGColorSpaceRelease(colorSpace);
}

- (void)drawStripes:(CGContextRef)context withRect:(CGRect)rect
{
  if (_stripesWidth == 0) {
    return;
  }

  CGContextSaveGState(context);
  {
    UIBezierPath *allStripes = [UIBezierPath bezierPath];

    NSInteger start = -_stripesWidth;
    NSInteger end   = rect.size.width / (2 * _stripesWidth) + (2 * _stripesWidth);
    CGFloat yOffset = (_type == YLProgressBarTypeRounded) ? _progressBarInset : 0;

    for (NSInteger i = start; i <= end; i++)
    {
      UIBezierPath *stripe = [self stripeWithOrigin:CGPointMake(i * 2 * _stripesWidth + _stripesOffset, yOffset)
                                             bounds:rect
                                        orientation:_stripesOrientation];
      [allStripes appendPath:stripe];
    }

    // Clip the progress frame
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_internalCornerRadius];

    CGContextAddPath(context, [clipPath CGPath]);
    CGContextClip(context);

    CGContextSaveGState(context);
    {
      // Clip the stripes
      CGContextAddPath(context, [allStripes CGPath]);
      CGContextClip(context);

      CGContextSetFillColorWithColor(context, [_stripesColor CGColor]);
      CGContextFillRect(context, rect);
    }
    CGContextRestoreGState(context);
  }
  CGContextRestoreGState(context);
}

- (void)drawText:(CGContextRef)context withRect:(CGRect)rect
{
  if (_indicatorTextLabel == nil)
  {
    return;
  }

  CGRect innerRect          = CGRectInset(rect, 4, 2);
  _indicatorTextLabel.frame = innerRect;

  NSString *indicatorText = _indicatorTextLabel.text;
  BOOL hasText            = (_indicatorTextLabel.text != nil);

  if (!hasText)
  {
    indicatorText = [NSString stringWithFormat:@"%.0f%%", (self.progress * 100)];
  }

  CGRect textRect = CGRectZero;
  if ([indicatorText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
  {
    textRect = [indicatorText boundingRectWithSize:CGRectInset(innerRect, 20, 0).size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName: _indicatorTextLabel.font }
                                           context:nil];
  }

  if (innerRect.size.width < textRect.size.width || innerRect.size.height + 4 < textRect.size.height)
  {
    return;
  }

  _indicatorTextLabel.text = indicatorText;

  BOOL hasTextColor = ![_indicatorTextLabel.textColor isEqual:[UIColor clearColor]];

  if (!hasTextColor)
  {
    CGColorRef backgroundColor = nil;

    if (_indicatorTextDisplayMode == YLProgressBarIndicatorTextDisplayModeTrack)
    {
      backgroundColor = _trackTintColor.CGColor ?: [UIColor blackColor].CGColor;
    } else
    {
      backgroundColor = (__bridge CGColorRef)[_colors lastObject];
    }

    const CGFloat *components = CGColorGetComponents(backgroundColor);
    BOOL isLightBackground    = (components[0] + components[1] + components[2]) / 3.0f >= 0.5f;

    _indicatorTextLabel.textColor = (isLightBackground) ? [UIColor blackColor] : [UIColor whiteColor];
  }

  [_indicatorTextLabel drawTextInRect:innerRect];

  if (!hasTextColor)
  {
    _indicatorTextLabel.textColor = [UIColor clearColor];
  }
  if (!hasText)
  {
    _indicatorTextLabel.text = nil;
  }
}

#pragma mark - KVO Delegate Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"hideStripes"] || [keyPath isEqualToString:@"stripesAnimated"])
  {
    if (!_hideStripes && _stripesAnimated)
    {
      if (_stripesTimer == nil)
      {
        _stripesTimer= [NSTimer timerWithTimeInterval:YLProgressBarStripesAnimationTime
                                               target:self
                                             selector:@selector(setNeedsDisplay)
                                             userInfo:nil
                                              repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_stripesTimer forMode:NSRunLoopCommonModes];
      }
    } else
    {
      if (_stripesTimer && [_stripesTimer isValid])
      {
        [_stripesTimer invalidate];
      }
      
      self.stripesTimer = nil;
    }
  }
}

@end
