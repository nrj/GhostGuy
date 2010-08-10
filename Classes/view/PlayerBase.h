//
//  PlayerBase.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "SpriteBase.h"

typedef enum {
	
	PlayerDirectionUp,
	PlayerDirectionDown,
	PlayerDirectionLeft,
	PlayerDirectionRight
	
} PlayerDirection;


@class MapTile;

@interface PlayerBase : SpriteBase {
	
	MapTile *currentTile;
	PlayerDirection direction;
}

@property(readwrite, assign) MapTile *currentTile;
@property(readwrite, assign) PlayerDirection direction;

- (id)initWithCurrentTile:(MapTile *)tile direction:(PlayerDirection)dir;

- (NSString *)imageForDirection:(PlayerDirection)dir;

@end
