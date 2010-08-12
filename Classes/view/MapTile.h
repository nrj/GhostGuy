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
	int f, g, h;
	NSMutableDictionary *parentMap; // TODO - find something else that uses weak keys
}

@property(readwrite, assign) int index;
@property(readwrite, assign) int f;
@property(readwrite, assign) int g;
@property(readwrite, assign) int h;
@property(readwrite, retain) NSMutableDictionary *parentMap;

- (NSString *)description;

- (id)initWithType:(MapTileType)aType index:(int)num;

- (MapTileType)type;
- (void)setType:(MapTileType)value;
- (BOOL)isWalkable;
- (BOOL)isEdible;

- (int)row;
- (int)column;

- (NSArray *)getWalkableNeighbors:(NSArray *)nodes;

- (int)getTopTileIndex;
- (int)getBottomTileIndex;
- (int)getLeftTileIndex;
- (int)getRightTileIndex;

- (void)highlight;

+ (NSString *)imageForType:(MapTileType)aType;

+ (CGPoint)positionForIndex:(int)num;

- (int)weight;

@end
