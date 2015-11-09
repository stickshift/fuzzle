//
//  BlockView.m
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import "BlockView.h"

// Constants

#define BACKGROUND_RED 247.0 / 256.0
#define BACKGROUND_GREEN 147.0 / 256.0
#define BACKGROUND_BLUE 30.0 / 256.0
#define STROKE 4.0
#define STROKE_RED 241.0 / 256.0
#define STROKE_GREEN 90.0 / 256.0
#define STROKE_BLUE 36.0 / 256.0

#define GRID_INSET 2.0

@interface BlockView()
{
    CGPoint _startingPoint;
    CGPoint _lastLocation;
    UIColor* _strokeColor;
}
@end

@implementation BlockView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:BACKGROUND_RED green:BACKGROUND_GREEN blue:BACKGROUND_BLUE alpha:1.0];
        _strokeColor = [UIColor colorWithRed:STROKE_RED green:STROKE_GREEN blue:STROKE_BLUE alpha:1.0];
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Stroke outline of view to draw a border
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, STROKE);
    CGContextSetStrokeColorWithColor(c, _strokeColor.CGColor);
    CGContextAddRect(c, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CGContextStrokePath(c);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Remember original location of touch
    _lastLocation = [[[event touchesForView:self] anyObject] locationInView:self.superview];
    
    // Remember initial location of block
    _startingPoint = self.frame.origin;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    CGPoint point = [[[event touchesForView:self] anyObject] locationInView:self.superview];
    self.center = CGPointMake(self.center.x + (point.x - _lastLocation.x),
                              self.center.y + (point.y - _lastLocation.y));
    
    _lastLocation = point;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    [self snapToGrid];
}

- (void) snapToGrid
{
    // Snap to grid by rounding self.center to nearest width,height point
    CGFloat xfactor = round((self.center.x - self.bounds.size.width / 2) / self.bounds.size.width);
    CGFloat yfactor = round((self.center.y - self.bounds.size.height / 2) / self.bounds.size.height);
    
    self.center = CGPointMake(xfactor * self.bounds.size.width + self.bounds.size.width / 2 + GRID_INSET,
                              yfactor * self.bounds.size.height + self.bounds.size.height / 2 + GRID_INSET);
    
    if (![self.delegate blockView:self snappedToGridPosition:self.frame.origin])
    {
        // Delegate cancelled move, revert to startingPoint
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.frame;
            frame.origin = _startingPoint;
            self.frame = frame;
        }];
    }
}

@end
