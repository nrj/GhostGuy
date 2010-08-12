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
		
		tiles = [[NSMutableArray alloc] init];
		
		[self setLevelNumber:level];
		
		BitmapImage *image = [[BitmapImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] 
									pathForResource:[NSString stringWithFormat:@"Level-%d", level] 
								    ofType:@"png"]];
		
		[self setLevelImage:image];
	}
	
	return self;
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
