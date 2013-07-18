/*
 * YLBackgroundView.m
 *
 * Copyright 2012 Yannick Loriot.
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

#import "YLBackgroundView.h"

#import "ARCMacro.h"

@interface YLBackgroundView ()
@property (nonatomic, SAFE_ARC_PROP_RETAIN) UIImage *noizeImage;

/** Loads the noize image. */
- (void)loadNoizeImage;

@end

@implementation YLBackgroundView
@synthesize noizeImage;

- (void)dealloc
{
    SAFE_ARC_RELEASE (noizeImage);
    
    SAFE_ARC_SUPER_DEALLOC ();
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self loadNoizeImage];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadNoizeImage];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    {
        size_t num_locations            = 2;
        CGFloat locations[2]            = {0.1, 0.9};
        CGFloat colorComponents[8]      = {32.0/255.0, 36.0/255.0, 41.0/255.0, 1.0,  
                                           68.0/255.0, 68.0/255.0, 68.0/255.0, 1.0};
        CGColorSpaceRef myColorspace    = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient          = CGGradientCreateWithColorComponents (myColorspace, colorComponents, locations, num_locations);
        
        CGPoint centerPoint             = CGPointMake(self.bounds.size.width / 2.0,
                                                      self.bounds.size.height / 2.0);
        
        // Draw the gradient
        CGContextDrawRadialGradient(context, gradient, centerPoint, rect.size.width / 2, centerPoint, 0, (kCGGradientDrawsBeforeStartLocation));
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(myColorspace);
    }
    CGContextRestoreGState(context);
    
    // Blend the noize texture to the background
    CGSize textureSize                  = [noizeImage size];
    CGContextDrawTiledImage(context, CGRectMake(0, 0, textureSize.width, textureSize.height), noizeImage.CGImage);
}

#pragma mark -
#pragma mark YLBackgroundView Public Methods

#pragma mark YLBackgroundView Private Methods

- (void)loadNoizeImage
{
    self.noizeImage = [UIImage imageNamed:@"noise.png"];
}

@end
