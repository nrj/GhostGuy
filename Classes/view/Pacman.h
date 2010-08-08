//
//  Pacman.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "SpriteBase.h"


typedef enum {
	
	PacmanDirectionUp,
	PacmanDirectionDown,
	PacmanDirectionLeft,
	PacmanDirectionRight
	
} PacmanDirection;


@class MapTile;

@interface Pacman : SpriteBase {
	
	MapTile *currentTile;
	PacmanDirection direction;
	CCAction *nomAction;
}

@property(readwrite, assign) MapTile *currentTile;
@property(readwrite, assign) PacmanDirection direction;
@property(readwrite, retain) CCAction *nomAction;

- (id)initWithCurrentTile:(MapTile *)tile direction:(PacmanDirection)dir;

- (void)nom;

+ (NSString *)openImageForDirection:(PacmanDirection)dir;

@end
