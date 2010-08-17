//
//  GameScene.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "GameScene.h"
#import "GhostGuyMap.h"
#import "Pacman.h"
#import "PacmanAI.h"
#import "Ghost.h"
#import "GhostAI.h"
#import "MapTile.h"
#import "MapTileType.h"
#import "BitmapImage.h"
#import "AStarUtil.h"
#import "AStarNode.h"


@implementation GameScene


@synthesize gameStarted;

@synthesize currentLevel;

@synthesize currentMap;

@synthesize spriteSheet;

@synthesize pacman;

@synthesize pacmanAI;

@synthesize ghost;

@synthesize ghostAI;



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

		drawnPath = [[NSMutableArray array] retain];
		
		CGSize s = [[CCDirector sharedDirector] winSize];	
		
		// create a render texture, this is what we're going to draw into
		canvas = [[CCRenderTexture renderTextureWithWidth:s.width height:s.height] retain];
		[canvas setPosition:ccp(s.width/2, s.height/2)];
		
		// note that the render texture is a cocosnode, and contains a sprite of it's texture for convience,
		// so we can just parent it to the scene like any other cocos node
		[self addChild:canvas z:1];
		
		// create a brush image to draw into the texture with
		brush = [[CCSprite spriteWithFile:@"brush-pink.png"] retain];
		[brush setBlendFunc: (ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_ALPHA }];  
		
		self.isTouchEnabled = YES;
	}
	
	return self;
}


- (void)updateDrawnPath {
	
	if (drawnPath > 0) {
				
		MapTile *currentTile = nil;
		
		for (MapTile *nextTile in drawnPath) {
			
			if (!currentTile) {
				
				currentTile = nextTile;
			}
			else {
				
				CGPoint start = [currentTile position];
				CGPoint end = [nextTile position];
				
				float distance = ccpDistance(start, end);
				for (int i = 0; i < distance; i++) {
					
					float difx = end.x - start.x;
					float dify = end.y - start.y;
					
					float delta = (float)i / distance;
					
					CGPoint pos = ccp(start.x + (difx * delta), start.y + (dify * delta));
					
					[brush setBlendFunc: (ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_ALPHA }];  
					[brush setOpacity:90];
					[brush setPosition:pos];
					[brush visit];
				}
				
				currentTile = nextTile;
			}
		}
	}
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (!gameStarted) {
	
		[self start];
	}
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView: [touch view]];	
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	[drawnPath removeAllObjects];
	
	MapTile *tileSelected = [currentMap getWalkableTileForPoint:touchLocation 
													   snapRect:NO];
	
	if (tileSelected && ![drawnPath containsObject:tileSelected]) {
		
		[drawnPath addObject:tileSelected];
	}
	else {
	
		[canvas clear:0 g:0 b:0 a:0];
	}
}


-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	if ([drawnPath count] == 0)
		return;
	
	UITouch *touch = [touches anyObject];
	CGPoint start = [[drawnPath lastObject] position];
	CGPoint end = [touch previousLocationInView:[touch view]];
	end = [[CCDirector sharedDirector] convertToGL:end];
	
	[canvas clear:0 g:0 b:0 a:0];
	[canvas begin];
	
	[self updateDrawnPath];
	
	float distance = ccpDistance(start, end);
	if (distance > 1)
	{
		int d = (int)distance;
		for (int i = 0; i < d; i++)
		{
			float difx = end.x - start.x;
			float dify = end.y - start.y;
			
			float delta = (float)i / distance;
			
			CGPoint brushPos = ccp(start.x + (difx * delta), start.y + (dify * delta));
			
			MapTile *snapTile = nil;

			if ((snapTile = [currentMap getWalkableTileForPoint:brushPos snapRect:YES])) {
									
				NSArray *neighborTiles = [[drawnPath lastObject] getWalkableNeighbors:[currentMap tiles]];
				
				if ([neighborTiles containsObject:snapTile]) {
					
					[drawnPath addObject:snapTile];
					[canvas end];
					return;						
				}
				else if (snapTile != [drawnPath lastObject]) {
					
					NSArray *pathToSnapTile = [ghostAI findPathToNode:snapTile fromNode:[drawnPath lastObject]];
					
					NSLog(@"Path from %@ to %@ is %@", snapTile, [drawnPath lastObject], pathToSnapTile);
					
					if (pathToSnapTile && [pathToSnapTile count] > 0) {
					
						[drawnPath addObjectsFromArray:pathToSnapTile];
						[canvas end];
						return;
					}
				}
			}			
			
			[brush setPosition:brushPos];
			[brush setBlendFunc: (ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_ALPHA }];  
			[brush setOpacity:90];
			[brush visit];			
		}
	}

	[canvas end];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	if ([drawnPath count] == 0)
		return;
	
	[canvas clear:0 g:0 b:0 a:0];
	[canvas begin];

	[self updateDrawnPath];
	
	[canvas end];
	
	if ([drawnPath count] > 0) {
		
		[ghostAI travelPath:drawnPath];
	}
	
	// draw a simple line
	// The default state is:
	// Line Width: 1
	// color: 255,255,255,255 (white, non-transparent)
	// Anti-Aliased
	//	glEnable(GL_LINE_SMOOTH);
	//	ccDrawLine( ccp([self winWidth] >> 1, [self winHeight] >> 1), ccp([self winWidth], [self winHeight]) );
	
	/*	if (!gameStarted) {
	 
	 [self start];
	 } 
	 else {		
	 
	 UITouch *touch = [touches anyObject];
	 CGPoint touchLocation = [touch locationInView:[touch view]];
	 touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	 
	 for (MapTile *tile in [currentMap tiles]) {
	 
	 if (CGRectContainsPoint([tile rect], touchLocation)) {
	 
	 [ghostAI travelToTile:tile];
	 return;
	 }
	 }
	 }
	 */
}


/* 
 * We render each level from a small png, each pixel in the image represents a different tile 
 * on the game board. We use the complex color information stored in each pixel to denote 
 * the different tile types.
 */ 
- (void)drawMapForLevelNumber:(int)level {

	GhostGuyMap *map = [[GhostGuyMap alloc] initWithLevelNumber:level];
		
	NSMutableArray *tiles = [NSMutableArray array];
	
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

		[tiles addObject:tile];
		[self addChild:tile];
		[tile release];
		
		if (pixelData[i].blue) {
			
			// If the blue byte is set, this means a player resides on this tile
			switch (pixelData[i].blue) {
						
				case MAP_TILE_PACMAN_POSITION:
					pacman = [[Pacman alloc] initWithCurrentTile:tile direction:PlayerDirectionRight];
					break;
				case MAP_TILE_GHOST_POSITION:
					ghost = [[Ghost alloc] initWithCurrentTile:tile direction:PlayerDirectionRight];
					break;
			}
			

		}
		
		i += 1;
	}
	
	if (pacman) {
		
		[self addChild:pacman];
		[pacman release];
	}
	
	if (ghost) {
		
		[self addChild:ghost];
		[ghost release];
	}
	
	[map setTiles:[NSArray arrayWithArray:tiles]];
	
	
	[self setCurrentMap:map];
}



- (void)start {
	
	PacmanAI *pai = [[PacmanAI alloc] initWithMap:currentMap pacman:pacman ghost:ghost];
	GhostAI *gai = [[GhostAI alloc] initWithMap:currentMap pacman:pacman ghost:ghost];
	
	[self setPacmanAI:pai];
	[self setGhostAI:gai];
	
//	[pai start];
//	[gai start];
	
	[pai release];
	[gai release];
	
	[self setGameStarted:YES];	
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

	[pacmanAI release];
	[pacman release];
	[ghostAI release];
	[ghost release];
	[currentMap release];
	[brush release];
	[canvas release];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];	
	[super dealloc];
}


@end
