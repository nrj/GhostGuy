//
//  MapTile.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "MapTile.h"


@implementation MapTile


@synthesize index;

@synthesize parentNode;

@synthesize f;

@synthesize g;

@synthesize h;


- (id)initWithType:(MapTileType)aType index:(int)num {
	
	NSString *imageFile = [MapTile imageForType:aType];
	
	if ((self = [self initWithSpriteFrameName:imageFile])) {
		type = aType;
		[self setIndex:num];
		[self setPosition:[MapTile positionForIndex:index]];
		[self setParentNode:nil];
		[self setF:0];
		[self setG:0];
		[self setH:0];
	}
	
	return self;
}


- (MapTileType)type {
	
	return type;
}


- (void)setType:(MapTileType)value {

	if (type != value) {
		type = value;
		[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
							   spriteFrameByName:[MapTile imageForType:type]]];
	}
	
}


- (int)row {
	
	return ceil((index + 1) / TILE_COLUMNS);
}


- (int)column {
	
	return (index % TILE_COLUMNS);	
}


- (void)highlight {
	
	[self setType:MapTileHighlight];
}


- (NSArray *)getWalkableNeighbors:(NSArray *)nodes {

	NSMutableArray *walkable = [NSMutableArray array];
	int topIndex = [self getTopTileIndex], rightIndex = [self getRightTileIndex];
	int bottomIndex = [self getBottomTileIndex], leftIndex = [self getLeftTileIndex];
	
	if (topIndex != -1 && [[nodes objectAtIndex:topIndex] isWalkable]) {

		[walkable addObject:[nodes objectAtIndex:topIndex]];
	}
	if (rightIndex != -1 && [[nodes objectAtIndex:rightIndex] isWalkable]) {
	
		[walkable addObject:[nodes objectAtIndex:rightIndex]];
	}
	if (bottomIndex != -1 && [[nodes objectAtIndex:bottomIndex] isWalkable]) {
		
		[walkable addObject:[nodes objectAtIndex:bottomIndex]];
	}
	if (leftIndex != -1 && [[nodes objectAtIndex:leftIndex] isWalkable]) {
		
		[walkable addObject:[nodes objectAtIndex:leftIndex]];
	}

	return [NSArray arrayWithArray:walkable];
}


- (int)getTopTileIndex {
	
	if ([self isOnTopEdge]) return -1;
	return (index - TILE_COLUMNS);
}


- (int)getBottomTileIndex {
	
	if ([self isOnBottomEdge]) return -1;
	return (index + TILE_COLUMNS);
}


- (int)getLeftTileIndex {
	
	if ([self isOnLeftEdge]) return -1;
	return (index - 1);
}


- (int)getRightTileIndex {
	
	if ([self isOnRightEdge]) return -1;
	return (index + 1);
}


- (BOOL)isOnTopEdge {
	
	return ((index + 1) <= TILE_COLUMNS);
}


- (BOOL)isOnBottomEdge {
	
	return ((index + 1) > (TILE_COLUMNS * (TILE_ROWS - 1)));
}


- (BOOL)isOnLeftEdge {

	return ((index - 1) % TILE_COLUMNS == 0);
}


- (BOOL)isOnRightEdge {
	
	return ((index + 1) % TILE_COLUMNS == 0);
}


- (BOOL)isWalkable {
	
	return (type == MapTileEmptySpace ||
			type == MapTileSmallDot ||
			type == MapTileBigDot ||
			type == MapTileHighlight);
}


+ (NSString *)imageForType:(MapTileType)aType {
	
	switch (aType) {
			
		case MapTileEmptySpace:
			return @"tile-empty-space.png";
		
		case MapTileSmallDot:
			return @"tile-small-dot.png";

		case MapTileBigDot:
			return @"tile-big-dot.png";
			
		case MapTileTopLeftWall:
			return @"tile-top-left-corner.png";
		
		case MapTileTopRightWall:
			return @"tile-top-right-corner.png";
			
		case MapTileBottomLeftWall:
			return @"tile-bottom-left-corner.png";

		case MapTileBottomRightWall:
			return @"tile-bottom-right-corner.png";

		case MapTileHorizontalWall:
			return @"tile-horizontal-wall.png";

		case MapTileHorizontalLeftWall:
			return @"tile-horizontal-left-end.png";

		case MapTileHorizontalRightWall:
			return @"tile-horizontal-right-end.png";
			
		case MapTileVerticalWall:
			return @"tile-vertical-wall.png";

		case MapTileVerticalTopWall:
			return @"tile-vertical-top-end.png";
		
		case MapTileVerticalBottomWall:
			return @"tile-vertical-bottom-end.png";
			
		case MapTileHighlight:
			return @"tile-small-dot-highlight.png";
			
		default:
			NSLog(@"Unknown MapTileType: %d", aType);
			return nil;
			
	}
}

+ (CGPoint)positionForIndex:(int)num {
	
	int colNumber = (num % TILE_COLUMNS), rowNumber = (TILE_ROWS - floor(num / TILE_COLUMNS)) - 1;
	
	return ccp((TILE_WIDTH * colNumber) + (TILE_WIDTH >> 1),
			   (TILE_HEIGHT * rowNumber) + (TILE_HEIGHT >> 1));
}


@end
