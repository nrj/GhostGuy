//
//  GameTile.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "SpriteBase.h"
#import "MapTileType.h"
#import "AStarNode.h"


#define TILE_WIDTH 20

#define TILE_HEIGHT 20

#define TILE_COLUMNS 24

#define TILE_ROWS 16


@interface MapTile : SpriteBase <AStarNode> {

	MapTileType type;
	int index;
	id <AStarNode>parentNode;
	int f, g, h;
}

@property(readwrite, assign) int index;
@property(readwrite, assign) id <AStarNode>parentNode;
@property(readwrite, assign) int f;
@property(readwrite, assign) int g;
@property(readwrite, assign) int h;

- (id)initWithType:(MapTileType)aType index:(int)num;

- (MapTileType)type;
- (void)setType:(MapTileType)value;
- (BOOL)isWalkable;

- (int)row;
- (int)column;

- (NSArray *)getWalkableNeighbors:(NSArray *)nodes;

- (int)getTopTileIndex;
- (int)getBottomTileIndex;
- (int)getLeftTileIndex;
- (int)getRightTileIndex;

- (BOOL)isOnLeftEdge;
- (BOOL)isOnTopEdge;
- (BOOL)isOnBottomEdge;
- (BOOL)isOnRightEdge;


- (void)highlight;

+ (NSString *)imageForType:(MapTileType)aType;

+ (CGPoint)positionForIndex:(int)num;

@end
