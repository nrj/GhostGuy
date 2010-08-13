//
//  SpriteBase.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "SpriteBase.h"


@implementation SpriteBase


- (int)width {
	
	return [self contentSize].width;
}

- (int)height {
	
	return [self contentSize].height;
}

- (int)x {
	
	return [self position].x;
}

- (int)y {
	
	return [self position].y;
}

- (double)centerX {
	
	return (double)[self contentSize].width / 2;
}

- (double)centerY {
	
	return (double)[self contentSize].height / 2;
}

- (CGRect)rect {
	
	CGRect r = CGRectMake([self x], 
						   [self y], 
						   [self width], 
						   [self height]);
	
	return r;
}


@end
