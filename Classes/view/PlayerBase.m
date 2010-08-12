//
//  PlayerBase.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "PlayerBase.h"


@implementation PlayerBase


@synthesize currentTile;

@synthesize direction;


- (id)initWithCurrentTile:(MapTile *)tile direction:(PlayerDirection)dir {
	
	if ((self = [self initWithSpriteFrameName:[self imageForDirection:dir]])) {
		
		direction = dir;
		[self setCurrentTile:tile];
		[self setPosition:[tile position]];
	}
	
	return self;
}

- (void)setDirection:(PlayerDirection)value {
	
	if (direction != value) {
		
		direction = value;
		
		[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
							   spriteFrameByName:[self imageForDirection:direction]]];
	}
}


- (NSString *)imageForDirection:(PlayerDirection)dir {
	
	// Abstract
	@throw [NSException exceptionWithName:NSGenericException 
								   reason:@"No implementation found for 'imageForDirection:'." 
								 userInfo:nil];
}


@end
