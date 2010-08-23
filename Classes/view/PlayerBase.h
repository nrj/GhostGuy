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

@class GGTile;

@interface PlayerBase : SpriteBase {
	
	GGTile *currentTile;
	PlayerDirection direction;
}

@property(readwrite, assign) GGTile *currentTile;
@property(readwrite, assign) PlayerDirection direction;

- (id)initWithCurrentTile:(GGTile *)tile direction:(PlayerDirection)dir;

- (NSString *)imageForDirection:(PlayerDirection)dir;

@end
