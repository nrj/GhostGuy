//
//  CircleGesture.m
//
//  Created by Aaron Klick on 10/10/09.
//  Copyright 2009 Vantage Technic. All rights reserved.
//

#import "CircleGesture.h"


@implementation CircleGesture

@synthesize circleClosureDistanceVariance, maximumCircleTime;
@synthesize radiusVariancePercent, overlapTolerance;

-(void)dealloc
{
	[_allPoints release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if(self != nil)
	{
		_firstTouch = CGPointMake(0,0);
		_firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
		_lastTouch = CGPointMake(0,0);
		_lastTouchTime = [NSDate timeIntervalSinceReferenceDate];
		
		//Default Circle Parameters
		self.circleClosureDistanceVariance = 80.0f;
		self.maximumCircleTime             = 20.0f;
		self.radiusVariancePercent         = 45.0f;
		self.overlapTolerance              = 30.0f;
		
		_completeCircle = CGMakeCircle(CGPointMake(0, 0), 0);
	}
	
	return self;
}

-(void) configure:(float) closure time:(float) time radiusVariance:(float) radiusVariance overlap:(float) overlap
{
	self.circleClosureDistanceVariance = closure;
	self.maximumCircleTime = time;
	self.radiusVariancePercent = radiusVariance;
	self.overlapTolerance = overlap;
}

-(BOOL) isCompleteCircle:(NSMutableArray *) currentPoints first:(CGPoint) first last:(CGPoint) last firstTime:(NSTimeInterval) firstTime lastTime:(NSTimeInterval) lastTime
{
	int totalPoints = [_allPoints count];
	
	_allPoints = currentPoints;
	_firstTouch = first;
	_lastTouch = last;
	_firstTouchTime = firstTime;
	_lastTouchTime = lastTime;
	
	// Didn't finish close enough to starting point
    if (distanceBetweenPoints(_firstTouch, _lastTouch) > self.circleClosureDistanceVariance) {
        return NO;
    }
    // Took too long to draw
    if ([NSDate timeIntervalSinceReferenceDate] - _firstTouchTime > self.maximumCircleTime){
        return NO;
    }
    // Not enough _allPoints
    if (totalPoints < 5) {
        return NO;
    }

	_completeCircle = [self createCircle];
	
	CGFloat currentAngle = 0.0; 
    BOOL    hasSwitched = NO;
    
    // Start Circle Check=========================================================
    // Make sure all _allPoints on circle are within a certain percentage of the radius from the center
    // Make sure that the angle switches direction only once. As we go around the circle,
    //    the angle between the line from the start point to the end point and the line from  the
    //    current point and the end point should go from 0 up to about 180.0, and then come 
    //    back down to 0 (the function returns the smaller of the angles formed by the lines, so
    //    180° is the highest it will return, 0 the lowest. If it switches direction more than once, 
    //    then it's not a circle
    CGFloat minRadius = _completeCircle.radius - (_completeCircle.radius * self.radiusVariancePercent);
    CGFloat maxRadius = _completeCircle.radius + (_completeCircle.radius * self.radiusVariancePercent);
    int index = 0;
    for (NSString *onePointString in _allPoints) {
        CGPoint onePoint = CGPointFromString(onePointString);
        CGFloat distanceFromRadius = fabsf(distanceBetweenPoints(_completeCircle.center, onePoint));
        if (distanceFromRadius < minRadius || distanceFromRadius > maxRadius) {
            return NO;
        }
		
		CGLine line1 = CGMakeLine(_firstTouch, _completeCircle.center);
		CGLine line2 = CGMakeLine(onePoint, _completeCircle.center);

        CGFloat pointAngle = angleBetweenLines(line1, line2);
        
        if ((pointAngle > currentAngle && hasSwitched) && (index < totalPoints - self.overlapTolerance) ) {
            return NO;
        }
		
        if (pointAngle < currentAngle){
            if (!hasSwitched)
                hasSwitched = YES;
        }
        
        currentAngle = pointAngle;
		index++;
    }
    // End Circle Check=========================================================
	
	NSLog(@"Gestures: Successful Circle Gesture");
	
	return YES;
}

-(CGCircle) getCircle
{
	return _completeCircle;
}

-(CGCircle) createCircle
{
	CGPoint leftMost = _firstTouch;
    NSUInteger leftMostIndex = NSUIntegerMax;
    CGPoint topMost = _firstTouch;
    NSUInteger topMostIndex = NSUIntegerMax;
    CGPoint rightMost = _firstTouch;
    NSUInteger  rightMostIndex = NSUIntegerMax;
    CGPoint bottomMost = _firstTouch;
    NSUInteger bottomMostIndex = NSUIntegerMax;
    
    // Loop through touches and find out if outer limits of the circle
    int index = 0;
    for (NSString *onePointString in _allPoints){
        CGPoint onePoint = CGPointFromString(onePointString);
        if (onePoint.x > rightMost.x) {
            rightMost = onePoint;
            rightMostIndex = index;
        }
        if (onePoint.x < leftMost.x) {
            leftMost = onePoint;
            leftMostIndex = index;
        }
        if (onePoint.y > topMost.y) {
            topMost = onePoint;
            topMostIndex = index;
        }
        if (onePoint.y < bottomMost.y) {
            bottomMost = onePoint;
            bottomMostIndex = index;
        }
        index++;
    }
    
    // If startPoint is one of the extreme _allPoints, take set it
    if (rightMostIndex == NSUIntegerMax)
        rightMost = _firstTouch;
    if (leftMostIndex == NSUIntegerMax)
        leftMost = _firstTouch;
    if (topMostIndex == NSUIntegerMax)
        topMost = _firstTouch;
    if (bottomMostIndex == NSUIntegerMax)
        bottomMost = _firstTouch;
    
    // Figure out the approx middle of the circle
    CGPoint center = CGPointMake(leftMost.x + (rightMost.x - leftMost.x) / 2.0, bottomMost.y + (topMost.y - bottomMost.y) / 2.0);
	
	// Calculate the radius by looking at the first point and the center
    CGFloat radius = fabsf(distanceBetweenPoints(center, _firstTouch));
	
	return CGMakeCircle(center, radius);
}

@end
