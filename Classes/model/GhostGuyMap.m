//
//  GhostGuyMap.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "GhostGuyMap.h"
#import "BitmapImage.h"
#import "MapTile.h"

@implementation GhostGuyMap


@synthesize levelNumber;

@synthesize levelImage;

@synthesize tiles;


- (id)initWithLevelNumber:(int)level {
	
	if ((self = [super init])) {
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Tiles.plist"];
		
		[self setTiles:nil];
		
		[self setLevelNumber:level];
		
		BitmapImage *image = [[BitmapImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] 
									pathForResource:[NSString stringWithFormat:@"Level-%d", level] 
								    ofType:@"png"]];
		
		[self setLevelImage:image];
	}
	
	return self;
}


- (MapTile *)getWalkableTileForPoint:(CGPoint)p snapRect:(BOOL)snap {
	
//	NSLog(@"Getting tile at %0.f,%0.f", p.x, p.y);
	
	MapTile *tile = nil;
	for (MapTile *t in tiles) {
		
		if (![t isWalkable])
			continue;
		
		if ((snap && CGRectContainsPoint([t snapRect], p)) ||
			(!snap && CGRectContainsPoint([t rect], p))) {
			
			tile = t;
			
//			NSLog(@"Found Tile. Rect is %0.f,%0.f", [t rect].origin.x, [t rect].origin.y);			
		}
	}
	
//	if (tile && ![tile isWalkable]) {
//		
//		NSArray *neighbors = [tile getWalkableNeighbors:tiles];
//		
//		if ([neighbors count] > 0) {
//			
//			tile = [neighbors objectAtIndex:(arc4random() % [neighbors count])];
//		}
//	}
//	
//	return tile;

	return tile;
}


- (MapTile *)getSnapableTileForPoint:(CGPoint)p {
	
	MapTile *tile = nil;
	for (MapTile *t in tiles) {
		
		if (CGRectContainsPoint([t snapRect], p)) {
			
			tile = t;
		}
	}
	
	if (tile && ![tile isWalkable]) {
		
		NSArray *neighbors = [tile getWalkableNeighbors:tiles];
		
		if ([neighbors count] > 0) {
			
			tile = [neighbors objectAtIndex:(arc4random() % [neighbors count])];
		}
	}
	
	return tile;
}


- (NSArray *)edibleTilesInQuadrant:(int)q {
	
	NSMutableArray *quadrantTiles = [NSMutableArray array];
		
	int rowStart = -1, rowEnd = -1;
	int colStart = -1, colEnd = -1; 
	
	switch (q) {
				
		case 1:
			colEnd = (TILE_COLUMNS / 2);
			rowEnd = (TILE_ROWS / 2);
			break;
			
		case 2:
			colStart = (TILE_COLUMNS / 2);
			colEnd = TILE_COLUMNS;
			rowEnd = (TILE_ROWS / 2);
			break;
			
		case 3:
			rowStart = (TILE_ROWS / 2);
			rowEnd = TILE_ROWS;
			colEnd = (TILE_COLUMNS / 2);
			break;
			
		case 4:
			colStart = (TILE_COLUMNS / 2);
			colEnd = TILE_COLUMNS;
			rowStart = (TILE_ROWS / 2);
			rowEnd = TILE_ROWS;
			break;
	}
	
	for (MapTile *tile in tiles) {
		
		if ([tile row] > rowStart && 
			[tile row] < rowEnd &&
			[tile column] > colStart &&
			[tile column] < colEnd && 
			[tile isEdible]) {
				
			[quadrantTiles addObject:tile];
		}
	}
	
	return [NSArray arrayWithArray:quadrantTiles];
}


- (NSArray *)edibleTiles {
		
	NSMutableArray *quadrantTiles = [NSMutableArray array];
	
	for (MapTile *tile in tiles) {
		
		if ([tile isEdible]) {
			
			[quadrantTiles addObject:tile];
		}
	}
	
	return [NSArray arrayWithArray:quadrantTiles];
}


- (void)dealloc {

	[levelImage release]; levelImage = nil;
	[tiles release]; tiles = nil;
	[super dealloc];
}


@end
