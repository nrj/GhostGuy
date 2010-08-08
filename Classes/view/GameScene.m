//
//  GameScene.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "GameScene.h"
#import "GhostGuyMap.h"
#import "Pacman.h"
#import "MapTile.h"
#import "MapTileType.h"
#import "BitmapImage.h"
#import "AStarUtil.h"
#import "AStarNode.h"


@implementation GameScene


@synthesize currentMap;

@synthesize currentLevel;

@synthesize spriteSheet;

@synthesize pacman;


+ (id)scene {
	
	CCScene *scene = [CCScene node];

	GameScene *layer = [GameScene node];

	[scene addChild:layer];
	
	return scene;
}


- (id)init {
	
	if ((self = [super init])) {
		
		[self setCurrentLevel:0];
		
		[self drawMapForLevelNumber:currentLevel];
	}
	
	return self;
}


/* 
 * We render each level from a small png, each pixel in the image represents a different tile 
 * on the game board. We use the complex color information stored in each pixel to denote 
 * the different tile types.
 */ 
- (void)drawMapForLevelNumber:(int)level {

	GhostGuyMap *map = [[GhostGuyMap alloc] initWithLevelNumber:level];
		
	
	// Load the sprite sheet containing our map tiles and add it to the scene.
	
	[self setSpriteSheet:[CCSpriteSheet spriteSheetWithFile:@"Tiles.png"]];
	[self addChild:spriteSheet];
	
	
	// Initialize a struct with 4 byte pointers pointing to the color channels of 
	// the first pixel - red, green, blue and alpha respectively. 
	
	RGBAPixel *pixelData = [[map levelImage] bitmap];
	
	
	const int TOTAL_PIXELS = 16 * 24; int i = 0;

	
	// Now we inspect each pixel in the PNG moving our pixelData pointer over each set of 4 bytes.
	
	while (i < TOTAL_PIXELS) {
		
		MapTile *tile; MapTileType type;

		if (pixelData[i].red) { 
	
			// If the red byte is set this tile is a wall

			switch (pixelData[i].green) { 
			
					// We store the type of wall in the green byte
				
				case MAP_TILE_WALL_TOP_LEFT: 
					type = MapTileTopLeftWall;
					break;
					
				case MAP_TILE_WALL_TOP_RIGHT: 
					type = MapTileTopRightWall;
					break;
					
				case MAP_TILE_WALL_BTM_LEFT: 
					type = MapTileBottomLeftWall;
					break;
					
				case MAP_TILE_WALL_BTM_RIGHT: 
					type = MapTileBottomRightWall;
					break;
				
				case MAP_TILE_WALL_HORIZ:
					type = MapTileHorizontalWall;
					break;
					
				case MAP_TILE_WALL_VERTI:
					type = MapTileVerticalWall;
					break;
					
				default:
					@throw [NSException exceptionWithName:NSRangeException 
												   reason:[NSString stringWithFormat:@"Unknown wall tile value '%02X'", pixelData[i].green]
												 userInfo:nil];
			}
		}
		else { 
			
			// if the red byte is not set, this is a walkable tile
			
			switch (pixelData[i].green) {
					
					// We store the type of walkable tile in the green byte
					
				case MAP_TILE_EMPTY_SPACE:
					type = MapTileEmptySpace;
					break;
					
				case MAP_TILE_SMALL_DOT:
					type = MapTileSmallDot;
					break;
					
				case MAP_TILE_BIG_DOT:
					type = MapTileBigDot;
					break;
					
				default:
					@throw [NSException exceptionWithName:NSRangeException 
												   reason:[NSString stringWithFormat:@"Unknown walkable tile value '%02X'", pixelData[i].green]
												 userInfo:nil];
			}
		}

		tile = [[MapTile alloc] initWithType:type 
									   index:i];

		[[map tiles] addObject:tile];
		[self addChild:tile];
		[tile release];
		
		if (pixelData[i].blue) {
			
			// If the blue byte is set, this means a player resides on this tile
			
			pacman = [[Pacman alloc] initWithCurrentTile:tile direction:PacmanDirectionRight];			
		}
		
		i += 1;
	}
	
	if (pacman) {
	
		// Add pacman on top of the other tiles
		
		[self addChild:pacman];
		[pacman release];
	}
	
	[self setCurrentMap:map];
	
	[self calculateBestPath];
}


/*
 * Basic implemenation of the A* algorithm, calculates the best path to the ghost and
 * animates moving there, eating dots along the way
 */
- (void)calculateBestPath {

	id <AStarNode>start = [pacman currentTile];
	id <AStarNode>goal = nil;
	
	[start setG:[AStarUtil distanceTraveled:start]];
	[start setH:[AStarUtil manhattanHeuristicForStartNode:start 
												 endNode:goal]];
	[start setF:([start g] + [start h])];
	
	for (int i = 0; i < [[currentMap tiles] count]; i++) {
			
		if ([(MapTile *)[[currentMap tiles] objectAtIndex:i] type] == MapTileBigDot) {
			goal = [[currentMap tiles] objectAtIndex:i];
			break;
		}
	}
		
	NSMutableArray *openList = [NSMutableArray arrayWithObjects:[pacman currentTile], NULL];
	NSMutableArray *closedList = [NSMutableArray array];
	
	while (1) {

		id <AStarNode>currentNode = NULL;
		
		for (int i = 0; i < [openList count]; i++) {
			
			// Find the best node in the open list
			id <AStarNode>node = [openList objectAtIndex:i];
			if (!currentNode || [node f] < [currentNode f]) {
				currentNode = node;
			}
		}
		
		if (currentNode == goal) { 
			
			// We're done.
			
			break;
		}
		else {
			
			[AStarUtil moveNode:currentNode 
					   fromList:openList 
						 toList:closedList];
			
			NSArray *neighbors = [currentNode getWalkableNeighbors:[currentMap tiles]];
			
			for (int i = 0; i < [neighbors count]; i++) {
				
				id <AStarNode>node = [neighbors objectAtIndex:i];

				if (![openList containsObject:node] && ![closedList containsObject:node]) {
					
					[node setParentNode:currentNode];
					[node setG:[AStarUtil distanceTraveled:node]];
					[node setH:[AStarUtil manhattanHeuristicForStartNode:node 
																 endNode:goal]];
					[node setF:([node g] + [node h])];
					 
					[openList addObject:node];
				}
				
				// TODO
				// if the neighbor is already in open list, recalculate its G value
				//    if the new G value is lower, update it, and set its parent to this node
				// 
				//
				// if the neighbor is already in the closed list, recalculate its G value
				//    if the new G value is lower, update it, and set its parent to this node
				//
				
			}
		}
	}
	
	id <AStarNode>parent = goal;
	NSMutableArray *actions = [NSMutableArray array];
	while (parent) {
	
		id actionWillMove = [CCCallFuncND actionWithTarget:self 
												  selector:@selector(pacman:willMoveTo:) 
													  data:parent];
		
		id actionMove = [CCMoveTo actionWithDuration:.18f
											position:[parent position]];
		
		id actionDidMove = [CCCallFuncND actionWithTarget:self 
												 selector:@selector(pacman:didMoveTo:)
													 data:parent];
		
		[actions insertObject:actionDidMove atIndex:0];
		[actions insertObject:actionMove atIndex:0];
		[actions insertObject:actionWillMove atIndex:0];
		
		parent = [parent parentNode];
	}
	
	[pacman runAction:[CCSequence actionsInArray:actions]];
}


#pragma mark Pacman Delegate Methods 

- (void)pacman:(id)sender willMoveTo:(MapTile *)tile {
	
	int newDirection = -1;
	
	if ([tile getLeftTileIndex] == [[pacman currentTile] index]) {
		
		newDirection = PacmanDirectionRight;
	}
	else if ([tile getRightTileIndex] == [[pacman currentTile] index]) {

		newDirection = PacmanDirectionLeft;
	}
	else if ([tile getTopTileIndex] == [[pacman currentTile] index]) {

		newDirection = PacmanDirectionDown;
	}
	else if ([tile getBottomTileIndex] == [[pacman currentTile] index]) {

		newDirection = PacmanDirectionUp;
	}
	else {
		
		return;
	}
	
	[pacman setDirection:newDirection];
	[pacman nom];
}


- (void)pacman:(id)sender didMoveTo:(MapTile *)tile {

	if ([tile type] == MapTileSmallDot || [tile type] == MapTileBigDot) {
		
		// Is the tile edible?
		[tile setType:MapTileEmptySpace]; // Nom it
	}
	
	[pacman setCurrentTile:tile];
}


#pragma mark Convenience Methods


- (int)winHeight
{	
	// 320
	return [[CCDirector sharedDirector] winSize].height;
}



- (int)winWidth
{
	// 480
	return [[CCDirector sharedDirector] winSize].width;
}



- (void) dealloc {

	[currentMap release];
	[super dealloc];
}


@end
