//
//  MapTile.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "MapTile.h"


@implementation MapTile


@synthesize index;

@synthesize g;

@synthesize h;

@synthesize parentMap;

@synthesize overlay;


- (id)initWithType:(MapTileType)aType index:(int)num {
	
	NSString *imageFile = [MapTile imageForType:aType];
	
	if ((self = [self initWithSpriteFrameName:imageFile])) {
		type = aType;
		[self setIndex:num];
		[self setPosition:[MapTile positionForIndex:index]];
		[self setParentMap:[NSMutableDictionary dictionary]];
		[self setG:0];
		[self setH:0];
		
		[self setOverlay:[CCSprite spriteWithSpriteFrameName:@"tile-select.png"]];
		[overlay setPosition:ccp([self width] / 2, [self height] / 2)];
		[overlay setOpacity:0];
		[self addChild:overlay];
	}
	
	return self;
}
 
- (void)dealloc {
	 
	[parentMap release];
	[super dealloc];
}


- (MapTileType)type {
	
	return type;
}

- (int)f {
	
	return (g + h);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSLog(@"Touches, %@", touches);
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:[touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
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
	
	if (type == MapTileSmallDot) {
		
		[self setType:MapTileHighlightSmallDot];
	}
	else if (type == MapTileBigDot) {
		
		[self setType:MapTileHighlightBigDot];
	}
}

- (void)unHighlight {
	
	if (type == MapTileHighlightSmallDot) {
		
		[self setType:MapTileSmallDot];
	}
	else if (type == MapTileHighlightBigDot) {
		
		[self setType:MapTileBigDot];
	}
}


- (NSArray *)getWalkableNeighbors:(NSArray *)nodes {

	NSMutableArray *walkable = [NSMutableArray array];
	int topIndex = [self getTopTileIndex], rightIndex = [self getRightTileIndex];
	int bottomIndex = [self getBottomTileIndex], leftIndex = [self getLeftTileIndex];
	
	if ([nodes count] > topIndex && [[nodes objectAtIndex:topIndex] isWalkable]) {

		[walkable addObject:[nodes objectAtIndex:topIndex]];
	}
	if ([nodes count] > rightIndex && [[nodes objectAtIndex:rightIndex] isWalkable]) {
	
		[walkable addObject:[nodes objectAtIndex:rightIndex]];
	}
	if ([nodes count] > bottomIndex && [[nodes objectAtIndex:bottomIndex] isWalkable]) {
		
		[walkable addObject:[nodes objectAtIndex:bottomIndex]];
	}
	if ([nodes count] > leftIndex && [[nodes objectAtIndex:leftIndex] isWalkable]) {
		
		[walkable addObject:[nodes objectAtIndex:leftIndex]];
	}

	return [NSArray arrayWithArray:walkable];
}


- (int)getTopTileIndex {
	
	return (index - TILE_COLUMNS);
}


- (int)getBottomTileIndex {
	
	return (index + TILE_COLUMNS);
}


- (int)getLeftTileIndex {
	
	return (index - 1);
}


- (int)getRightTileIndex {
	
	return (index + 1);
}


- (BOOL)isWalkable {
	
	return (type == MapTileEmptySpace ||
			type == MapTileSmallDot ||
			type == MapTileBigDot ||
			type == MapTileHighlightBigDot ||
			type == MapTileHighlightSmallDot);
}


- (int)weight {
	
	if (type == MapTileSmallDot) 
		return 0;
	
	if (type == MapTileBigDot)	
		return 0;
	
	return 0;
}


- (BOOL)isEdible {
	
	return (type == MapTileSmallDot || type == MapTileBigDot);
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
			
		case MapTileHighlightBigDot:
		case MapTileHighlightSmallDot:
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


- (NSString *)description {

	return [NSString stringWithFormat:@"<MapTile type=%d, (%d, %d)>", type, [self row], [self column]];
}


- (void)setParentNode:(id <AStarNode>)value forId:(int)i {

	NSString *key = [NSString stringWithFormat:@"%d", i];	
	[parentMap setObject:value forKey:key];
}


- (id <AStarNode>)getParentNodeForId:(int)i {
	
	NSString *key = [NSString stringWithFormat:@"%d", i];
	if ([parentMap objectForKey:key]) {
	
		return [parentMap objectForKey:key];
	}
	return nil;
}


- (void)deleteParentNodeForId:(int)i {

	NSString *key = [NSString stringWithFormat:@"%d", i];
	if ([parentMap objectForKey:key]) {
		
		[parentMap setValue:nil forKey:key];
	}
}


- (void)select {
	
	[overlay setScale:1.0];
	
	id fadeIn = [CCFadeIn actionWithDuration:.1];
	id growOut = [CCScaleBy actionWithDuration:.1 scale:1.4];
	id fadeOut = [CCFadeOut actionWithDuration:.5];

	[overlay runAction:[CCSequence actions: fadeIn, growOut, fadeOut, nil]];
}


@end
