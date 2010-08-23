//
//  Gestures.h
// 
//  Containment for all Gesture Motions
//
//  Created by Aaron Klick on 10/15/09.
//  Copyright 2009 Vantage Technic. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CGPointUtils.h"
#import "CircleGesture.h"
#import "XGesture.h"
#import "SquareGesture.h"

//Protocol for Gesture Delegate
@protocol GestureComplete <NSObject>

@optional
-(void) circleComplete:(CGCircle) circle;
-(void) xComplete:(CGX) x;
-(void) squareComplete:(CGSquare) square;
-(void) swipeLeftComplete;
-(void) swipeRightComplete;
-(void) swipeUpComplete;
-(void) swipeDownComplete;

@end

@interface Gestures : NSObject {
	CircleGesture *_circle;
	XGesture *_x;
	SquareGesture *_square;
	
	NSMutableArray *_allPoints;
	
	CGPoint _firstTouch;
	CGPoint _lastTouch;
	
	NSTimeInterval _firstTouchTime;
	NSTimeInterval _lastTouchTime;
	
	id <GestureComplete> _delegate;
	
	int _swipeTolerance;
	
	int _pointResetLimit;
	
	BOOL _useSwipes;
	BOOL _useSquare;
	BOOL _useCircle;
	BOOL _useX;
}

+ (Gestures *) sharedGestures;
- (id) init;

@property (readonly) CircleGesture *circle;
@property (readonly) NSMutableArray *points;
@property (readonly) XGesture *x;
@property (readonly) SquareGesture *square;
@property (assign) id <GestureComplete> delegate;
@property (readwrite) int pointResetLimit;

@property (readwrite) BOOL useSwipes;
@property (readwrite) BOOL useSquare;
@property (readwrite) BOOL useCircle;
@property (readwrite) BOOL useX;

@property (readwrite) int swipeTolerance;
@property (readonly) CGPoint firstTouch;
@property (readonly) CGPoint lastTouch;

@property (readonly) NSTimeInterval firstTouchTime;
@property (readonly) NSTimeInterval lastTouchTime;

-(BOOL) isSwipeLeft;
-(BOOL) isSwipeRight;
-(BOOL) isSwipeUp;
-(BOOL) isSwipeDown;

-(void) addPoint:(CGPoint) point;
-(void) configure:(BOOL) checkCircle checkSquare:(BOOL) checkSquare checkX:(BOOL) checkX checkSwipes:(BOOL) checkSwipes resetLimit:(int) number;

-(CGPoint) getLeft;
-(CGPoint) getRight;
-(CGPoint) getDown;
-(CGPoint) getUp;

-(CGPoint) accelerationSpeed;

-(void) reset;

-(CGPoint) calculateVelocity:(CGPoint) point1 point2:(CGPoint) point2 duration:(CGFloat) duration; 

@end

