//
//  Pacman.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "Pacman.h"


@implementation Pacman


@synthesize currentTile;

@synthesize direction;

@synthesize nomAction;


- (id)initWithCurrentTile:(MapTile *)tile direction:(PacmanDirection)dir {
	
	if ((self = [self initWithSpriteFrameName:[Pacman openImageForDirection:dir]])) {

		direction = dir;
		[self setCurrentTile:tile];
		[self setPosition:[tile position]];
	}
	
	return self;
}
		 
- (void)setDirection:(PacmanDirection)value {
	
	if (direction != value) {
		
		direction = value;
		
		[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
			spriteFrameByName:[Pacman openImageForDirection:direction]]];
	}
}


- (void)nom {

	NSArray *frames = [NSArray arrayWithObjects:
					   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tile-pacman-closed.png"],
					   NULL];
	
	CCAnimation *animation = [CCAnimation animationWithName:@"nom" 
													  delay:0.1f 
													 frames:frames];
	
	[self setNomAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES] 
											times:1]];
	
	[self runAction:nomAction];
}


+ (NSString *)openImageForDirection:(PacmanDirection)dir {
	
	switch (dir) {
		
		case PacmanDirectionUp:
			return @"tile-pacman-open-up.png";
		case PacmanDirectionRight:
			return @"tile-pacman-open-right.png";
		case PacmanDirectionDown:
			return @"tile-pacman-open-down.png";
		case PacmanDirectionLeft:
			return @"tile-pacman-open-left.png";
	}
	
	return nil;
}

@end
