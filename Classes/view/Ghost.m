//
//  Ghost.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "Ghost.h"


@implementation Ghost


- (NSString *)imageForDirection:(PlayerDirection)dir {
	
	switch (dir) {
			
		case PlayerDirectionUp:
		case PlayerDirectionRight:
		case PlayerDirectionDown:
		case PlayerDirectionLeft:
			return @"tile-ghost-pink-right.png";
	}
	
	return nil;
}


@end
