//
//  GGTile.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "AStarNode.h"

@class CCSprite;

typedef enum {
	
	GGTileEmptySpace = 0,
	GGTileSmallDot,
	GGTileBigDot,
	GGTileWall
	
} GGTileType;

@interface GGTile : NSObject <AStarNode> {

	GGTileType type;
	CGPoint position;
	int row, column;
	int g, h;
	NSMutableDictionary *parentMap;
}

@property(nonatomic, assign) int g;
@property(nonatomic, assign) int h;

- (id)initWithType:(GGTileType)t position:(CGPoint)p row:(int)r column:(int)c;

- (int)f;

- (CGPoint)position;
- (int)row;
- (int)column;

- (BOOL)isWalkable;
- (BOOL)isEdible;

- (void)setParentNode:(id <AStarNode>)value forId:(int)i;
- (id <AStarNode>)getParentNodeForId:(int)i;
- (void)removeParentNodeForId:(int)i;

@end
