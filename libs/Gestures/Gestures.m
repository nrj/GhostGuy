//
//  Gestures.m
//
//  Created by Aaron Klick on 10/15/09.
//  Copyright 2009 Vantage Technic. All rights reserved.
//

#import "Gestures.h"


@implementation Gestures

@synthesize circle=_circle, points=_allPoints, firstTouch=_firstTouch, lastTouch=_lastTouch, pointResetLimit=_pointResetLimit;
@synthesize firstTouchTime=_firstTouchTime, lastTouchTime=_lastTouchTime, x=_x, square=_square, delegate=_delegate, swipeTolerance=_swipeTolerance;
@synthesize useX=_useX, useCircle=_useCircle, useSquare=_useSquare, useSwipes=_useSwipes;

static Gestures *sharedGestures;

-(void) dealloc
{
	[_circle release];
	[_x release];
	[_allPoints release];
	[_square release];
	
	[super dealloc];
}

//Init
+ (Gestures *) sharedGestures
{	
	@synchronized(self)
	{
		if(sharedGestures == nil)
		{
			sharedGestures = [[Gestures alloc] init];
		}
	}
	
	return sharedGestures;
}

+(id) allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if(sharedGestures == nil)
		{
			sharedGestures = [super  allocWithZone:zone];
			return sharedGestures;
		}
	}
	
	return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
	return self;
}

-(id)retain {
	return self;
}

-(unsigned)retainCount
{
	return UINT_MAX;
}

-(void)release
{
	//do nothing
}

-(id)autorelease
{
	return self;
}

-(id) init
{
	self = [super init];
	
	if(self != nil)
	{
		NSLog(@"Gestures: Initializing Singleton");
		_circle = [[CircleGesture alloc] init];
		_x = [[XGesture alloc] init];
		_square = [[SquareGesture alloc] init];
		_allPoints = [[NSMutableArray alloc] initWithCapacity:10];
		_firstTouch = CGPointZero;
		_firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
		_lastTouch = CGPointZero;
		_lastTouchTime = [NSDate timeIntervalSinceReferenceDate];
		_swipeTolerance = 10;
		_pointResetLimit = 10;
	}
	
	return self;
}

// Adds a point to the _allPoints array
- (void) addPoint:(CGPoint) point
{
		BOOL isComplete = NO;
		int pointCount = [_allPoints count];
	
		NSLog(@"Gestures: Adding Point");
	
		if(pointCount >= _pointResetLimit)
		{
			NSLog(@"Gestures: Point Limit Reached - Resetting Points");
			[_allPoints removeAllObjects];
		}
	
		if(pointCount == 0)
		{
			_firstTouch = point;
			_firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
			NSLog(@"Gestures: First Touch Set");
		}
		
		[_allPoints addObject:NSStringFromCGPoint(point)];
		_lastTouch = point;
		_lastTouchTime = [NSDate timeIntervalSinceReferenceDate];
		
		if(_useX)
		{
			if([_x isX:_firstTouch last:_lastTouch])
			{
				if([_delegate respondsToSelector:@selector(xComplete:)])
				{
					isComplete = YES;
					
					[_delegate xComplete:[_x getX]];
				}
			}
		}
		
		if(_useSquare)
		{
			if([_square isCompleteSquare:_allPoints first:_firstTouch last:_lastTouch firstTime:_firstTouchTime lastTime:_lastTouchTime])
			{
				if([_delegate respondsToSelector:@selector(squareComplete:)])
				{
					isComplete = YES;
					[_delegate squareComplete:[_square getSquare]];
				}
			}
		}
		
		if(_useCircle)
		{
			if([_circle isCompleteCircle:_allPoints first:_firstTouch last:_lastTouch firstTime:_firstTouchTime lastTime:_lastTouchTime])
			{
				if([_delegate respondsToSelector:@selector(circleComplete:)])
				{
					isComplete = YES;
					NSLog(@"Gestures: Calling Circle Complete Delegate");
					[_delegate circleComplete:[_circle getCircle]];
				}
			}
		}
		
		if(_useSwipes)
		{
			if([self isSwipeLeft])
			{
				if([_delegate respondsToSelector:@selector(swipeLeftComplete)])
				{
					isComplete = YES;
					[_delegate swipeLeftComplete];
				}
			}
			else if([self isSwipeRight])
			{
				if([_delegate respondsToSelector:@selector(swipeRightComplete)])
				{
					isComplete = YES;
					[_delegate swipeRightComplete];
				}
			}
			else if([self isSwipeUp])
			{
				if([_delegate respondsToSelector:@selector(swipeUpComplete)])
				{
					isComplete = YES;
					[_delegate swipeUpComplete];
				}
			}
			else if([self isSwipeDown])
			{
				if([_delegate respondsToSelector:@selector(swipeDownComplete)])
				{
					isComplete = YES;
					[_delegate swipeDownComplete];
				}
			}
		}
		
		if(isComplete)
		{
			[self reset];
		}
}

- (void) reset
{
		_firstTouch = CGPointZero;
		_firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
		_lastTouch = CGPointZero;
		_lastTouchTime = [NSDate timeIntervalSinceReferenceDate];
		[_allPoints removeAllObjects];
}

- (void) configure:(BOOL) checkCircle checkSquare:(BOOL) checkSquare checkX:(BOOL) checkX checkSwipes:(BOOL) checkSwipes resetLimit:(int) number;
{
	_useX = checkX;
	_useSquare = checkSquare;
	_useCircle = checkCircle;
	_useSwipes = checkSwipes;
	_pointResetLimit = number;
}

/**
 * Tests to see if the user has swiped to the left
 * Tolerance is the distance the user has to travel to
 * signal a complete swipe.
 *
 * @param tolerance
 */
- (BOOL) isSwipeLeft
{
	CGPoint left;
	left = [self getLeft];

	if((left.x - _firstTouch.x) < 0)
	{
		int distance = abs((left.x - _firstTouch.x));
		int distanceY = abs((left.y - _firstTouch.y));
		
		if(distanceY > _swipeTolerance)
		{
			return NO;
		}
		
		
		if(distance >= _swipeTolerance)
		{
			return YES;
		}
	}
		
	return NO;
}

/**
 * Tests to see if the user has swiped to the right
 * Tolerance is the distance the user has to travel to
 * signal a complete swipe.
 *
 * @param tolerance
 */
- (BOOL) isSwipeRight
{
		CGPoint right;
		right = [self getRight];
	
		if((_firstTouch.x - right.x) < 0)
		{
			int distance = abs((_firstTouch.x - right.x));
			int distanceY = abs((_firstTouch.y - right.y));
			
			if(distanceY > _swipeTolerance)
			{
				return NO;
			}
			
			if(distance >= _swipeTolerance)
			{
				return YES;
			}
		}
	
	return NO;
}

/**
 * Tests to see if the user has swiped up
 * Tolerance is the distance the user has to travel to
 * signal a complete swipe.
 *
 * @param tolerance
 */
- (BOOL) isSwipeUp
{
		CGPoint up;
		up = [self getUp];
	
		if((_firstTouch.y - up.y) < 0)
		{
			int distance = abs((_firstTouch.y - up.y));
			//int distanceX = abs((_firstTouch.x - up.x));
			
			//if(distanceX > _swipeTolerance)
			//{
			//	return NO;
			//}
			
			
			if(distance >= _swipeTolerance)
			{
				return YES;
			}
		}
	
	return NO;	
}

/**
 * Tests to see if the user has swiped down
 * Tolerance is the distance the user has to travel to
 * signal a complete swipe.
 *
 * @param tolerance
 */
- (BOOL) isSwipeDown
{
		CGPoint down;
		down = [self getDown];
	
		if((down.y - _firstTouch.y) < 0)
		{
			int distance = abs((down.y - _firstTouch.y));
			//int distanceX = abs((down.x - _firstTouch.x));
			
			//if(distanceX > _swipeTolerance)
			//{
			//	return NO;
			//}
			
			if(distance >= _swipeTolerance)
			{
				return YES;
			}
		}
	
	return NO;	
}

/**
 * Calculates the velocity based on given duration and points
 * @return CGPoint
 */
-(CGPoint) calculateVelocity:(CGPoint) point1 point2:(CGPoint) point2 duration:(CGFloat) duration
{
	CGFloat accelerationY;
	CGFloat accelerationX;
	float distanceX;
	float distanceY;
	
	if (duration <= 0) duration = 0.1;
	
	
	distanceY = point2.y - point1.y;
	distanceX = point2.x - point1.x;
	accelerationX = (distanceX / (duration * duration));
	accelerationY = (distanceY / (duration * duration));
	
	return CGPointMake(accelerationX, accelerationY);
}


/**
 * Calculates a simple acceleration speed based on distance and time
 * from the first touch point to the last touch point
 */
- (CGPoint) accelerationSpeed
{
	CGFloat totalTime;
	float distanceX;
	float distanceY;
	CGFloat accelerationX;
	CGFloat accelerationY;

	totalTime = _lastTouchTime - _firstTouchTime;
	distanceX = _lastTouch.x - _firstTouch.x;
	distanceY = _lastTouch.y - _firstTouch.y;
	
	accelerationX = (distanceX / (totalTime*totalTime));
	accelerationY = (distanceY / (totalTime*totalTime));
	
	return CGPointMake(accelerationX, accelerationY);
}

// Gets the left most point of the touchs
- (CGPoint) getLeft
{
		CGPoint leftMost;
		leftMost = _firstTouch;
	
		for (NSString *onePointString in _allPoints){
			CGPoint onePoint = CGPointFromString(onePointString);
			if (onePoint.x < leftMost.x) {
				leftMost = onePoint;
			}
		}	
	
		return leftMost;
}

// Gets the right most point of the touchs
- (CGPoint) getRight
{
		CGPoint rightMost;
		rightMost = _firstTouch;
	
		for (NSString *onePointString in _allPoints){
			CGPoint onePoint = CGPointFromString(onePointString);
			if (onePoint.x > rightMost.x) {
				rightMost = onePoint;
			}
		}	
	
		return rightMost;
}

// Gets the down most point of the touchs
- (CGPoint) getDown
{
		CGPoint downMost;
		downMost = _firstTouch;
	
		for (NSString *onePointString in _allPoints){
			CGPoint onePoint = CGPointFromString(onePointString);
			if (onePoint.y < downMost.y) {
				downMost = onePoint;
			}
		}	
	
		return downMost;
}

// Gets the up most point of the touchs
- (CGPoint) getUp
{
		CGPoint upMost;
		upMost = _firstTouch;
	
		for (NSString *onePointString in _allPoints){
			CGPoint onePoint = CGPointFromString(onePointString);
			if (onePoint.y > upMost.y) {
				upMost = onePoint;
			}
		}	
	
		return upMost;	
}

@end
