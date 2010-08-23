//
//  CircleGesture.h
//
//  Created by Aaron Klick on 10/10/09.
//  Copyright 2009 Vantage Technic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGPointUtils.h"

@interface CircleGesture : NSObject {
	NSMutableArray *_allPoints;
	CGPoint _firstTouch;
	NSTimeInterval _firstTouchTime;
	CGPoint _lastTouch;
	NSTimeInterval _lastTouchTime;
	
	float circleClosureDistanceVariance;
	float maximumCircleTime;
	float radiusVariancePercent;
	float overlapTolerance;
	
	CGCircle _completeCircle;
}

@property (readwrite) float circleClosureDistanceVariance;
@property (readwrite) float maximumCircleTime;
@property (readwrite) float radiusVariancePercent;
@property (readwrite) float overlapTolerance;

-(CGCircle) createCircle;
-(CGCircle) getCircle;

-(BOOL) isCompleteCircle:(NSMutableArray *) currentPoints first:(CGPoint) first last:(CGPoint) last firstTime:(NSTimeInterval) firstTime lastTime:(NSTimeInterval) lastTime;
-(void) configure:(float)closure time:(float)time radiusVariance:(float)radiusVariance overlap:(float)overlap;

@end
