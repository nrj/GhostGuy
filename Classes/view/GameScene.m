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
		
		[self setIsTouchEnabled:YES];
		
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

				case MAP_TILE_WALL_HORIZ_LFT:
					type = MapTileHorizontalLeftWall;
					break;

				case MAP_TILE_WALL_HORIZ_RGT:
					type = MapTileHorizontalRightWall;
					break;
					
				case MAP_TILE_WALL_VERTI:
					type = MapTileVerticalWall;
					break;
					
				case MAP_TILE_WALL_VERTI_TOP:
					type = MapTileVerticalTopWall;
					break;
					
				case MAP_TILE_WALL_VERTI_BTM:
					type = MapTileVerticalBottomWall;
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
	
}



- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	NSLog(@"Touched %0.f/%0.f", location.x, location.y);
	
	[self start];
}


- (void)start {
	
	id <AStarNode>goal = [self determineTargetNode];
	
	NSArray *initialPath = [self findPathToNode:goal fromNode:[pacman currentTile]];
	
	if ([initialPath count] > 0) {
		
		NSArray *actions = [self actionAnimationsForNode:[initialPath objectAtIndex:1]];
		
		[pacman runAction:[CCSequence actionsInArray:actions]];
	}
}



- (id <AStarNode>)determineTargetNode {

	for (MapTile *tile in [currentMap tiles]) {
		
		if ([tile isEdible]) {
			
			return tile;
		}
	}
	
	return nil;
}



- (NSArray *)findPathToNode:(id <AStarNode>)goal fromNode:(id <AStarNode>)start {
	
	[start setG:[AStarUtil distanceTraveled:start]];
	[start setH:[AStarUtil manhattanHeuristicForStartNode:start 
												 endNode:goal]];
	[start setF:([start g] + [start h])];
	
	NSMutableArray *openList = [NSMutableArray arrayWithObjects:[pacman currentTile], NULL];
	NSMutableArray *closedList = [NSMutableArray array];
	NSMutableArray *pathToTake = [NSMutableArray array];
	
	
	while (1) {	
				
		id <AStarNode>currentNode = NULL;
		
		for (id <AStarNode>node in openList) {
			
			// Find the best node in the open list
			if (!currentNode || [node f] < [currentNode f]) {
				currentNode = node;
			}
		}
		
		if (currentNode == goal) { 
			
			id <AStarNode>next = goal;
			
			while (next) {
				
				
				[pathToTake insertObject:next atIndex:0];
				
				next = [next parentNode];
			}
			
			break;
			
		}
		else {
			
			[AStarUtil moveNode:currentNode 
					   fromList:openList 
						 toList:closedList];
			
			NSArray *neighbors = [currentNode getWalkableNeighbors:[currentMap tiles]];
			
			int newG = [AStarUtil distanceTraveled:currentNode] + 1;
			
			for (id <AStarNode>neighbor in neighbors) {
				
				if ([closedList containsObject:neighbor] && newG < [neighbor g]) {
					
					[neighbor setG:newG];
					[neighbor setF:(newG + [neighbor h])];
					[neighbor setParentNode:currentNode];
				}
				else if ([openList containsObject:neighbor] && newG < [neighbor g]) {
					
					[neighbor setG:newG];
					[neighbor setF:(newG + [neighbor h])];
					[neighbor setParentNode:currentNode];
				}				
				else if (![openList containsObject:neighbor] && ![closedList containsObject:neighbor]){
					
					[neighbor setG:newG];
					[neighbor setH:[AStarUtil manhattanHeuristicForStartNode:neighbor endNode:goal]];
					[neighbor setF:(newG + [neighbor h])];
					[neighbor setParentNode:currentNode];
					
					[openList addObject:neighbor];
				}
			}
		}	
	}
	
	for (id <AStarNode>node in pathToTake) {
	
		[node setParentNode:nil];
	}
	
	return [NSArray arrayWithArray:pathToTake];
}



- (NSArray *)actionAnimationsForNode:(id <AStarNode>)node {
	
	id actionWillMove = [CCCallFuncND actionWithTarget:self 
											  selector:@selector(pacman:willMoveTo:) 
												  data:node];
		
	id actionMove = [CCMoveTo actionWithDuration:.15f
										position:[node position]];
		
	id actionDidMove = [CCCallFuncND actionWithTarget:self 
											 selector:@selector(pacman:didMoveTo:)
												 data:node];
	
	return [NSArray arrayWithObjects:actionWillMove, actionMove, actionDidMove, NULL];
}


#pragma mark Pacman Delegate Methods 


- (void)pacman:(id)sender willMoveTo:(MapTile *)tile {
	
	NSLog(@"pacman:willMoveTo:%@", tile);
	
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
	
	[pacman setDirection:newDirection];
}


- (void)pacman:(id)sender didMoveTo:(MapTile *)tile {
	
	NSLog(@"pacman:didMoveTo:%@", tile);

	if ([tile type] == MapTileSmallDot || [tile type] == MapTileBigDot) {
		
		// Is the tile edible?
		[tile setType:MapTileEmptySpace]; // Nom it
	}
	
	[pacman setCurrentTile:tile];
	
	// Calculate the next path
	
	id <AStarNode>goal = [self determineTargetNode];
	
	NSArray *path = [self findPathToNode:goal fromNode:tile];
	
	if ([path count] > 0) {
		
		NSArray *actions = [self actionAnimationsForNode:[path objectAtIndex:1]];
		
		[[CCActionManager sharedManager] addAction:[CCSequence actionsInArray:actions] 
											target:sender 
											paused:NO];
	}
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
