/*
 * YLProgressBar.m
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

#import "YLProgressBar.h"

#import "ARCMacro.h"

// Sizes
#define YLProgressBarSizeInset              1

@interface YLProgressBar ()
@property (nonatomic, assign)               double      progressOffset;
@property (nonatomic, assign)               CGFloat     cornerRadius;
@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSTimer     *animationTimer;
@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSArray     *colors;

/** Init the progress bar. */
- (void)initializeProgressBar;

/** Build the stripes. */
- (UIBezierPath *)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame;

/** Draw the background (track) of the slider. */
- (void)drawTrackWithRect:(CGRect)rect;
/** Draw the progress bar. */
- (void)drawProgressBarWithRect:(CGRect)rect;
/** Draw the gloss into the given rect. */
- (void)drawGlossWithRect:(CGRect)rect;
/** Draw the stipes into the given rect. */
- (void)drawStripesWithRect:(CGRect)rect;

@end

@implementation YLProgressBar

- (void)dealloc
{
    if (_animationTimer && [_animationTimer isValid])
    {
        [_animationTimer invalidate];
    }
    
    SAFE_ARC_RELEASE (_animationTimer);
    SAFE_ARC_RELEASE(_progressTintColors);
    
    SAFE_ARC_SUPER_DEALLOC ();
}

-(id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        [self initializeProgressBar];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initializeProgressBar];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    [self setAnimated:(_animated && !hidden)];
}

- (void)drawRect:(CGRect)rect
{
    // Refresh the corner radius value
    self.cornerRadius   = rect.size.height / 2;
    
    // Compute the progressOffset for the stripe's animation
    self.progressOffset = (!_animated || self.progressOffset > 2 * _progressStripeWidth - 1) ? 0 : ++self.progressOffset;
    
    // Draw the background track
    [self drawTrackWithRect:rect];
    
    if (self.progress > 0)
    {
        CGRect innerRect = CGRectMake(YLProgressBarSizeInset,
                                      YLProgressBarSizeInset,
                                      rect.size.width * self.progress - 2 * YLProgressBarSizeInset,
                                      rect.size.height - 2 * YLProgressBarSizeInset);
        
        [self drawProgressBarWithRect:innerRect];
        
        if (_progressStripeWidth > 0)
        {
            [self drawStripesWithRect:innerRect];
        }
        
        [self drawGlossWithRect:innerRect];
    }
}

#pragma mark - Properties

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    progressTintColor  = (progressTintColor) ? progressTintColor : [UIColor blueColor];
    
    [super setProgressTintColor:progressTintColor];
    
    const CGFloat *c    = CGColorGetComponents(progressTintColor.CGColor);
    UIColor *leftColor  = [UIColor colorWithRed:(c[0] / 3.0f) green:(c[1] / 3.0f) blue:(c[2] / 3.0f) alpha:(c[3])];
    UIColor *rightColor = progressTintColor;
    NSArray *colors     = [NSArray arrayWithObjects:(id)leftColor, (id)rightColor, nil];
    
    [self setProgressTintColors:colors];
}

- (void)setProgressTintColors:(NSArray *)progressTintColors
{
    if (_progressTintColors)
    {
        SAFE_ARC_RELEASE(self.progressTintColors);
    }
    _progressTintColors = SAFE_ARC_RETAIN(progressTintColors);
    
    NSMutableArray *colors  = [NSMutableArray arrayWithCapacity:[progressTintColors count]];
    for (UIColor *color in progressTintColors)
    {
        [colors addObject:(id)color.CGColor];
    }
    self.colors             = colors;
}

#pragma mark - Public Methods

- (void)setAnimated:(BOOL)animated
{
    _animated   = animated;
    
    if (animated)
    {
        if (self.animationTimer == nil)
        {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f / 30.0f)
                                                                   target:self
                                                                 selector:@selector(setNeedsDisplay)
                                                                 userInfo:nil
                                                                  repeats:YES];
        }
    } else
    {
        if (_animationTimer && [_animationTimer isValid])
        {
            [_animationTimer invalidate];
        }
        
        self.animationTimer = nil;
    }
}

#pragma mark - Private Methods

- (void)initializeProgressBar
{
    self.progressTintColor  = self.progressTintColor;
    self.progressOffset     = 0;
    self.animationTimer     = nil;
    self.animated           = YES;
    self.progressStripeWidth        = YLProgressBarDefaultStripeWidth;
}

- (UIBezierPath *)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame
{
    float height        = frame.size.height;
    UIBezierPath *rect  = [UIBezierPath bezierPath];
    
    [rect moveToPoint:origin];
    [rect addLineToPoint:CGPointMake(origin.x + _progressStripeWidth, origin.y)];
    [rect addLineToPoint:CGPointMake(origin.x + _progressStripeWidth - 8, origin.y + height)];
    [rect addLineToPoint:CGPointMake(origin.x - 8, origin.y + height)];
    [rect addLineToPoint:origin];
    [rect closePath];
    
    return rect;
}

- (void)drawTrackWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Define the progress bar pattern to clip all the content inside
    UIBezierPath *roundedRect   = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rect.size.width, rect.size.height)
                                                             cornerRadius:_cornerRadius];
    [roundedRect addClip];
    
    CGContextSaveGState(context);
    {
        // Draw the track
        [self.trackTintColor set];
        UIBezierPath* roundedRect   = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rect.size.width, rect.size.height-1) cornerRadius:_cornerRadius];
        [roundedRect fill];
        
        // Draw the white shadow
        [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2] set];
        
        UIBezierPath *shadow        = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5f, 0, rect.size.width - 1, rect.size.height - 1)
                                                                 cornerRadius:_cornerRadius];
        [shadow stroke];
        
        // Draw the inner glow
        [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f] set];
        
        UIBezierPath *glow          = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_cornerRadius, 0, rect.size.width - _cornerRadius * 2, 1)
                                                                 cornerRadius:0];
        [glow stroke];
    }
    CGContextRestoreGState(context);
}

- (void)drawProgressBarWithRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    {
        UIBezierPath *progressBounds    = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_cornerRadius];
        CGContextAddPath(context, [progressBounds CGPath]);
        CGContextClip(context);
        
        CFArrayRef colorRefs = (CFArrayRef)_colors;
        
        float delta          = 1.0f / [_colors count];
        float semi_delta     = delta / 2.0f;
        CGFloat locations[[_colors count]];
        for (int i = 0; i < [_colors count]; i++)
        {
            locations[i] = delta * i + semi_delta;
        }
        
        CGGradientRef gradient  = CGGradientCreateWithColors (colorSpace, colorRefs, locations);
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x, rect.origin.y), CGPointMake(rect.origin.x + rect.size.width, rect.origin.y), (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
        
        CGGradientRelease(gradient);
    }
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
}

- (void)drawGlossWithRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    {
        // Draw the gloss
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        CGContextBeginTransparencyLayerWithRect(context, CGRectMake(rect.origin.x, rect.origin.y + floorf(rect.size.height) / 2, rect.size.width, floorf(rect.size.height) / 2), NULL);
        {
            const CGFloat glossGradientComponents[] = {1.0f, 1.0f, 1.0f, 0.47f, 0.0f, 0.0f, 0.0f, 0.0f};
            const CGFloat glossGradientLocations[]  = {1.0, 0.0};
            CGGradientRef glossGradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
            CGContextDrawLinearGradient(context, glossGradient, CGPointMake(0, 0), CGPointMake(0, rect.size.width), 0);
            CGGradientRelease(glossGradient);
        }
        CGContextEndTransparencyLayer(context);
        
        // Draw the gloss's drop shadow
        CGContextSetBlendMode(context, kCGBlendModeSoftLight);
        CGContextBeginTransparencyLayer(context, NULL);
        {
            CGRect fillRect = CGRectMake(rect.origin.x, rect.origin.y + floorf(rect.size.height / 2), rect.size.width, floorf(rect.size.height / 2));
            
            const CGFloat glossDropShadowComponents[] = {0.0f, 0.0f, 0.0f, 0.56f, 0.0f, 0.0f, 0.0f, 0.0f};
            CGColorRef glossDropShadowColor = CGColorCreate(colorSpace, glossDropShadowComponents);
            
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
    
    UIBezierPath *progressBounds    = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_cornerRadius];
    
    // Draw progress bar glow
    CGContextSaveGState(context);
    {
        CGContextAddPath(context, [progressBounds CGPath]);
        const CGFloat progressBarGlowComponents[]   = {1.0f, 1.0f, 1.0f, 0.12f};
        CGColorRef progressBarGlowColor             = CGColorCreate(colorSpace, progressBarGlowComponents);
        
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        CGContextSetStrokeColorWithColor(context, progressBarGlowColor);
        CGContextSetLineWidth(context, 2.0f);
        CGContextStrokePath(context);
        CGColorRelease(progressBarGlowColor);
    }
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
}

- (void)drawStripesWithRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB ();
    
    CGContextSaveGState(context);
    {
        UIBezierPath *allStripes = [UIBezierPath bezierPath];
        
        for (int i = -_progressStripeWidth; i <= rect.size.width / (2 * _progressStripeWidth) + (2 * _progressStripeWidth); i++)
        {
            UIBezierPath *stripe    = [self stripeWithOrigin:CGPointMake(i * 2 * _progressStripeWidth + self.progressOffset, YLProgressBarSizeInset)
                                                      bounds:rect];
            [allStripes appendPath:stripe];
        }
        
        // Clip the progress frame
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_cornerRadius];
        
        CGContextAddPath(context, [clipPath CGPath]);
        CGContextClip(context);
        
        CGContextSaveGState(context);
        {
            // Clip the stripes
            CGContextAddPath(context, [allStripes CGPath]);
            CGContextClip(context);
            
            const CGFloat stripesColorComponents[]  = { 0.0f, 0.0f, 0.0f, 0.28f };
            CGColorRef stripesColor                 = CGColorCreate(colorSpace, stripesColorComponents);
            
            CGContextSetFillColorWithColor(context, stripesColor);
            CGContextFillRect(context, rect);
            
            CGColorRelease(stripesColor);
        }
        CGContextRestoreGState(context);
    }
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
}

@end
