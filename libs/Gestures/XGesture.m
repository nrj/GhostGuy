//
//  XGesture.m
//
//  Created by Aaron Klick on 10/15/09.
//  Copyright 2009 Vantage Technic. All rights reserved.
//

#import "XGesture.h"


@implementation XGesture

@synthesize centerTolerance, timeTolerance;

-(void) dealloc
{
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if(self != nil)
	{
		_count = 1;
		self.centerTolerance = 8.0f;
		self.timeTolerance = 10.0f;
	}
	
	return self;
}

/**
 * Checks to see if the gesture drawn is an X
 */
-(BOOL) isX:(CGPoint) first last:(CGPoint) last
{
	_firstTouch = first;
	_lastTouch = last;
	
	[self createLine];
	
	if(_count != 3) return NO;
	
	// Checks to see if the distance between the two lines are close enough.
	CGFloat centerDistance = distanceBetweenLines(_line1, _line2);
	
	if (centerDistance > self.centerTolerance)
	{
		return NO;
	}
	
	// Checks to see that too much time has not passed between the gestures
	if (([NSDate timeIntervalSinceReferenceDate] - (_firstLineTime + _secondLineTime) > self.timeTolerance)) 
	{
		return NO;
	}
	
	// Checks to make sure the lines are either 90 degrees from each other or 180 degrees from each other
	// otherwise if they are not then it is not an X shape
	CGFloat angle = fabs(angleBetweenLines(_line1, _line2));
	
	if (angle < 90 && angle > 180)
	{
		return NO;
	}
	
	// Gets the center location between each point for both X and Y directions
	CGFloat centerX1 = (_line1.point1.x + _line1.point2.x) / 2;
	CGFloat centerY1 = (_line1.point1.y + _line1.point2.y) / 2;
	CGFloat centerX2 = (_line2.point1.x + _line2.point2.x) / 2;
	CGFloat centerY2 = (_line2.point1.y + _line2.point2.y) / 2;
	
	// Verifies that the center points are close to each other
	// If not then it is not an X
	if (abs(centerX1 - centerX2) > self.centerTolerance)
	{
		return NO;
	}
	
	if (abs(centerY1 - centerY2) > self.centerTolerance)
	{
		return NO;
	}
	
	// We get the Average center X and Y positions
	// so that we can store in our CGX struct
	CGFloat centerAvgX = (centerX1 + centerX2) / 2;
	CGFloat centerAvgY = (centerY1 + centerY2) / 2;
	
	_gestureX = CGMakeX(_line1, _line2, CGPointMake(centerAvgX, centerAvgY));	
	return YES;
}

/**
 * Gets the actual X data.
 */
-(CGX) getX
{
	return _gestureX;
}

/**
 * Edits the XGesture settings
 */
-(void) configure:(float) tolerance time:(float) time
{
	self.centerTolerance = tolerance;
	self.timeTolerance = time;
}

/**
 * The method automatically determines which line we are on.
 */
-(void) createLine
{	
	switch (_count) {
		case 1:
			_firstLineTime = [NSDate timeIntervalSinceReferenceDate];
			
			if ((_lastTouch.x > _firstTouch.x) && (_lastTouch.y < _firstTouch.y)) 
			{
				_line1 = CGMakeLine(_lastTouch, _firstTouch);
				_count++;
			}
			else if ((_lastTouch.x < _firstTouch.x) && (_lastTouch.y > _firstTouch.y))
			{
				_line1 = CGMakeLine(_lastTouch, _firstTouch);
				_count++;
			}
			else 
			{
				_count = 1;
			}

			break;
		case 2:
			_secondLineTime = [NSDate timeIntervalSinceReferenceDate];
			
			if ((_lastTouch.x < _firstTouch.x) && (_lastTouch.y < _firstTouch.y))
			{
				_line2 = CGMakeLine(_firstTouch, _lastTouch);
				_count++;
			}
			else if ((_lastTouch.x > _firstTouch.x) && (_lastTouch.y > _firstTouch.y))
			{
				_line2 = CGMakeLine(_firstTouch, _lastTouch);
				_count++;
			}
			else 
			{
				_count = 1;
			}
			break;
		default:
			_count = 1;
			_firstLineTime = [NSDate timeIntervalSinceReferenceDate];
			
			if ((_lastTouch.x > _firstTouch.x) && (_lastTouch.y < _firstTouch.y)) 
			{
				_line1 = CGMakeLine(_lastTouch, _firstTouch);
				_count++;
			}
			else if ((_lastTouch.x < _firstTouch.x) && (_lastTouch.y > _firstTouch.y))
			{
				_line1 = CGMakeLine(_lastTouch, _firstTouch);
				_count++;
			}
			else 
			{
				_count = 1;
			}
			
			break;
	}
}

@end