//
//  TPCardViewButton.m
//  instagram-photo-browser
//
//  Created by Tyler Powers on 11/7/13.
//  Copyright (c) 2013 Tyler Powers. All rights reserved.
//

// I used PaintCode to aid in getting some of the code used in the Core Graphics drawing methods right
// http://www.paintcodeapp.com/
// I'm drawing off-screen and making a UIImage from the graphics context to be used for the UIButton background images


#import "TPCardViewButton.h"
#import "TPConstants.h"

@interface TPCardViewButton ()

@property (nonatomic, assign) TPCardViewButtonSide side;
@property (nonatomic, assign) UIRectCorner corners;

- (UIImage *)imageForUnselectedBackground;
- (UIImage *)imageForSelectedBackground;
- (void)drawVerticalSpacer;

@end

static const CGRect       rectForBackgroundImagesGraphicsContext  = {0, 0, 148, 42};  // We provide this rect in the call to retreive a new bitmap-based graphics context for rendering bg images
static const UIEdgeInsets resizableBackgroundImageCapInsets       = {21, 22, 20, 22}; // Insets for resizing behavior of UIImage

@implementation TPCardViewButton

- (id)initWithSide:(TPCardViewButtonSide)side title:(NSString *)title
{
    self = [super init];
    if (self) {
        
        self.side = side;
        
        switch (side) {
            case TPCardViewButtonSideAll: {
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                self.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }
                break;
            case TPCardViewButtonSideLeft: {
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                self.corners = UIRectCornerBottomLeft;
            }
                break;
            case TPCardViewButtonSideRight: {
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                self.corners = UIRectCornerBottomRight;
            }
            case TPCardViewButtonSideMiddle: {
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            }
                break;
            default:
                break;
        }
        
        UIImage *unselectedBackgroundImage = [self imageForUnselectedBackground];
        UIImage *selectedBackgroundImage = [self imageForSelectedBackground];
        
        [self setBackgroundImage:unselectedBackgroundImage forState:UIControlStateNormal];
        [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
        [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateHighlighted];
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:kTextColorSecondary forState:UIControlStateNormal];
        [self setTitleColor:kTextColorPrimary forState:UIControlStateSelected];
        [self setTitleColor:kTextColorPrimary forState:UIControlStateHighlighted];
        
        self.titleLabel.font = kFontButtonTitle;
        
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];

        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}


- (UIImage *)imageForUnselectedBackground
{
    UIGraphicsBeginImageContextWithOptions(rectForBackgroundImagesGraphicsContext.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// Color Declarations
    
    UIColor* fillColor = [UIColor colorWithRed: 0.818 green: 0.818 blue: 0.818 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.958 green: 0.958 blue: 0.958 alpha: 1];
    UIColor* strokeColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.772 green: 0.772 blue: 0.772 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)strokeColor.CGColor,
                               (id)[UIColor colorWithRed: 0.888 green: 0.888 blue: 0.888 alpha: 1].CGColor,
                               (id)fillColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.48, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* shadow = strokeColor2;
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 0.5;
    
    UIBezierPath* roundedRectanglePath = nil;
    
    if (self.side != TPCardViewButtonSideMiddle) {
        roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, rectForBackgroundImagesGraphicsContext.size.width, rectForBackgroundImagesGraphicsContext.size.height) byRoundingCorners: self.corners cornerRadii: CGSizeMake(6, 6)];
    } else {
        roundedRectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, rectForBackgroundImagesGraphicsContext.size.width, rectForBackgroundImagesGraphicsContext.size.height)];
    }

    [roundedRectanglePath closePath];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(50, 0), CGPointMake(50, rectForBackgroundImagesGraphicsContext.size.height), 0);
    CGContextRestoreGState(context);
    
    // Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, rectForBackgroundImagesGraphicsContext.size.width, 1)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [color2 setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
    
    [self drawVerticalSpacer];
    
    UIImage *unselectedBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *resizableUnselectedBackgroundImage = [unselectedBackgroundImage resizableImageWithCapInsets:resizableBackgroundImageCapInsets];
    
    UIGraphicsEndImageContext();
    
    return resizableUnselectedBackgroundImage;
}



- (UIImage *)imageForSelectedBackground
{
    UIGraphicsBeginImageContextWithOptions(rectForBackgroundImagesGraphicsContext.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.91 green: 0.91 blue: 0.91 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.815 green: 0.815 blue: 0.815 alpha: 1];
    UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.253];
    UIColor* color4 = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 0.483];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)strokeColor.CGColor,
                               (id)[UIColor colorWithRed: 0.863 green: 0.863 blue: 0.863 alpha: 1].CGColor,
                               (id)fillColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.32, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* shadow2 = shadowColor2;
    CGSize shadow2Offset = CGSizeMake(0, 2);
    CGFloat shadow2BlurRadius = 2;
    
    //// Rounded Rectangle Drawing
    
    UIBezierPath* roundedRectanglePath = nil;
    
    if (self.side != TPCardViewButtonSideMiddle) {
        roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, rectForBackgroundImagesGraphicsContext.size.width, rectForBackgroundImagesGraphicsContext.size.height) byRoundingCorners: self.corners cornerRadii: CGSizeMake(6, 6)];
    } else {
        roundedRectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, rectForBackgroundImagesGraphicsContext.size.width, rectForBackgroundImagesGraphicsContext.size.height)];
    }
    
    [roundedRectanglePath closePath];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];

    CGContextDrawLinearGradient(context, gradient, CGPointMake(50, 0), CGPointMake(50, rectForBackgroundImagesGraphicsContext.size.height), 0);
    CGContextRestoreGState(context);
    
    ////// Rounded Rectangle Inner Shadow
    CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadow2BlurRadius, -shadow2BlurRadius);
    roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadow2Offset.width, -shadow2Offset.height);
    roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
    
    UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
    [roundedRectangleNegativePath appendPath: roundedRectanglePath];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadow2Offset.width + round(roundedRectangleBorderRect.size.width);
        CGFloat yOffset = shadow2Offset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadow2BlurRadius,
                                    shadow2.CGColor);
        
        [roundedRectanglePath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
        [roundedRectangleNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [roundedRectangleNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    [color4 setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    [self drawVerticalSpacer];
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *selectedBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *resizableSelectedBackgroundImage = [selectedBackgroundImage resizableImageWithCapInsets:resizableBackgroundImageCapInsets];
    
    UIGraphicsEndImageContext();
    
    return resizableSelectedBackgroundImage;
}


- (void)drawVerticalSpacer
{
    if (self.side != TPCardViewButtonSideLeft && self.side != TPCardViewButtonSideMiddle) return;
    
    UIColor* fillColor = [UIColor colorWithRed: 0.818 green: 0.818 blue: 0.818 alpha: 1];
    
    // Vertical spacer line
    UIBezierPath* spacerPath = [UIBezierPath bezierPath];
    CGFloat xOffsetForSpacer = rectForBackgroundImagesGraphicsContext.size.width;
    CGFloat spacerHeight = rectForBackgroundImagesGraphicsContext.size.height - 1;
    [spacerPath moveToPoint: CGPointMake(xOffsetForSpacer, 1.0)];
    [spacerPath addCurveToPoint: CGPointMake(xOffsetForSpacer, spacerHeight) controlPoint1: CGPointMake(xOffsetForSpacer, spacerHeight) controlPoint2: CGPointMake(xOffsetForSpacer, spacerHeight)];
    [fillColor setStroke];
    spacerPath.lineWidth = 1;
    [spacerPath stroke];

}

@end