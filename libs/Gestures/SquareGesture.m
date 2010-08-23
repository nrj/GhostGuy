//
//  SquareGesture.m
//
//  Created by Aaron Klick on 10/17/09.
//  Copyright 2009 Vantage Technic. All rights reserved.
//

#import "SquareGesture.h"


@implementation SquareGesture

@synthesize squareClosureTolerance, timeTolerance;
@synthesize straightnessTolerance, squarenessTolerance;

-(void) dealloc
{
	[_allPoints release];
	
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if(self != nil)
	{
		self.squareClosureTolerance = 20.0f;
		self.timeTolerance = 20.0f;
		self.straightnessTolerance = 80.0f;
		self.squarenessTolerance = 80.0f;
		
		_firstTouch = CGPointMake(0,0);
		_firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
		_lastTouch = CGPointMake(0, 0);
		_lastTouchTime = [NSDate timeIntervalSinceReferenceDate];
		
		_gestureSquare = CGMakeSquare(CGPointMake(0, 0), 0, 0);
	}
	
	return self;
}

/**
 * Returns the finished square
 */
-(CGSquare) getSquare
{
	return _gestureSquare;
}

/**
 * Allows the editing of the various gesture settings
 */
-(void) configure:(float) closure time:(float) time straightness:(float) straightness squareness:(float) squareness
{
	self.squarenessTolerance = squareness;
	self.timeTolerance = time;
	self.straightnessTolerance = straightness;
	self.squareClosureTolerance = closure;
}

/**
 * Checks to see if the gesture is a true square
 */
-(BOOL) isCompleteSquare: (NSMutableArray *) currentPoints first:(CGPoint) touchFirst last:(CGPoint) touchLast firstTime:(NSTimeInterval) firstTime lastTime:(NSTimeInterval) lastTime
{	
	_allPoints = currentPoints;
	_firstTouch = touchFirst;
	_lastTouch = touchLast;
	_firstTouchTime = firstTime;
	_lastTouchTime = lastTime;
	// Didn't finish close enough to starting point
    if (distanceBetweenPoints(_firstTouch, _lastTouch) > self.squareClosureTolerance) {
        return NO;
    }
    // Took too long to draw
    if (_lastTouchTime - _firstTouchTime > self.timeTolerance){
        return NO;
    }
    // Not enough _allPoints
    if ([_allPoints count] < 4) {
        return NO;
    }
	
	CGPoint topLeftMost = _firstTouch;
    NSUInteger topLeftMostIndex = NSUIntegerMax;
    CGPoint topRightMost = _firstTouch;
    NSUInteger topRightMostIndex = NSUIntegerMax;
    CGPoint bottomRightMost = _firstTouch;
    NSUInteger  bottomRightMostIndex = NSUIntegerMax;
    CGPoint bottomLeftMost = _firstTouch;
    NSUInteger bottomLeftMostIndex = NSUIntegerMax;
    
    // Loop through touches and find out if outer limits of the circle
    int index = 0;
    for (NSString *onePointString in _allPoints){
        CGPoint onePoint = CGPointFromString(onePointString);
        if ((onePoint.x > topRightMost.x) && (onePoint.y > topRightMost.y)) {
            topRightMost = onePoint;
            topRightMostIndex = index;
        }
        if ((onePoint.x < topLeftMost.x) && (onePoint.y > topLeftMost.y)) {
            topLeftMost = onePoint;
            topLeftMostIndex = index;
        }
        if ((onePoint.x < bottomLeftMost.x) && (onePoint.y < bottomLeftMost.y)) {
            bottomLeftMost = onePoint;
            bottomLeftMostIndex = index;
        }
        if ((onePoint.x > bottomRightMost.x) && (onePoint.y < bottomRightMost.y)) {
            bottomRightMost = onePoint;
            bottomRightMostIndex = index;
        }
        index++;
    }
    
    // If startPoint is one of the extreme _allPoints, take set it
    if (topRightMostIndex == NSUIntegerMax)
        topRightMost = _firstTouch;
    if (bottomLeftMostIndex == NSUIntegerMax)
        bottomLeftMost = _firstTouch;
    if (topLeftMostIndex == NSUIntegerMax)
        topLeftMost = _firstTouch;
    if (bottomRightMostIndex == NSUIntegerMax)
        bottomRightMost = _firstTouch;
	
	// Check to make sure each side of the square is straight enough
	if(fabs(topLeftMost.x - bottomLeftMost.x) > self.straightnessTolerance)
	{
		return NO;
	}
	
	if(fabs(topRightMost.x - bottomRightMost.x) > self.straightnessTolerance)
	{
		return NO;
	}
	
	if(fabs(topLeftMost.y - topRightMost.y) > self.straightnessTolerance)
	{
		return NO;
	}
	
	if(fabs(bottomLeftMost.y - bottomRightMost.y) > self.straightnessTolerance)
	{
		return NO;
	}
	
	if(topLeftMost.x >= topRightMost.x)
	{
		return NO;
	}
	
	if(bottomLeftMost.x >= bottomRightMost.x)
	{
		return NO;
	}
	
	if(topLeftMost.y <= bottomLeftMost.y)
	{
		return NO;
	}
	
	if(topRightMost.y <= bottomRightMost.y)
	{
		return NO;
	}
	
	CGFloat distX1 = distanceBetweenPoints(topLeftMost, topRightMost);
	CGFloat distY1 = distanceBetweenPoints(topLeftMost, bottomLeftMost);
	CGFloat distX2 = distanceBetweenPoints(bottomLeftMost, bottomRightMost);
	CGFloat distY2 = distanceBetweenPoints(topRightMost, bottomRightMost);
	
	// Check to make sure that each side close in length
	if(fabs(distX1 - distX2) > self.squarenessTolerance)
	{
		return NO;
	}
	
	if(fabs(distY1 - distY2) > self.squarenessTolerance)
	{
		return NO;
	}
	
	
	CGPoint center = CGPointMake((distX1 / 2), (distY1 / 2));
	
	_gestureSquare = CGMakeSquare(center, distX1, distY1);
	
	return YES;
}

@end
