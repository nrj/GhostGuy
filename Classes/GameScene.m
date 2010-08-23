//
//  GameScene.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "GameScene.h"
#import "GameHUD.h"
#import "Pacman.h"
#import "PacmanAI.h"
#import "Ghost.h"
#import "GhostAI.h"
#import "AStarUtil.h"
#import "GGTile.h"


@implementation GameScene

@synthesize hud;

@synthesize gameStarted;


/*
 * Returns the scene object with the HUD layer on top.
 */
+ (id)scene {

	CCScene *scene = [CCScene node];
	GameScene *game = [GameScene node];
	GameHUD *hud = [GameHUD node];    

	[scene addChild:game];
	[scene addChild:hud];
	
	[game setHud:hud];
	
	return scene;
}


/*
 * Initializes the scene.
 */
- (id)init {

	if( (self=[super init] )) {

		// Add our sprite sheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Tiles.plist"];
		spriteSheet = [[CCSpriteSheet spriteSheetWithFile:@"Tiles.png"] retain];
		[self addChild:spriteSheet];
		
		// Load the map
		map = [[CCTMXTiledMap tiledMapWithTMXFile:@"maps/level-0.tmx"] retain];
		tileLayer = [[map layerNamed:@"Tiles"] retain];

		// Create the node objects used for pathfinding.
		nodes = [[AStarUtil createNodesForMap:map layer:tileLayer] retain];
		objects = [map objectGroupNamed:@"Objects"];
		
		// Lookup the spawn point for pacman and position him
		NSMutableDictionary *pacmanSpawn = [objects objectNamed:@"PacmanSpawn"];
		
		int pacmanX = [[pacmanSpawn valueForKey:@"x"] intValue];
		int pacmanY = [[pacmanSpawn valueForKey:@"y"] intValue];
		
		GGTile *pacmanTile = [self nodeForPosition:ccp(pacmanX, pacmanY)];
				
		pacman = [[Pacman alloc] initWithCurrentTile:pacmanTile 
										   direction:PlayerDirectionRight];
		

		// Lookup the spawn point for ghostguy and position him
		NSMutableDictionary *playerSpawn = [objects objectNamed:@"PlayerSpawn"];
		
		int playerX = [[playerSpawn valueForKey:@"x"] intValue];
		int playerY = [[playerSpawn valueForKey:@"y"] intValue];
		
		GGTile *playerTile = [self nodeForPosition:ccp(playerX, playerY)];

		
		ghost = [[Ghost alloc] initWithCurrentTile:playerTile 
										 direction:PlayerDirectionRight];
		
		// Add our objects to the stage
        [self addChild:map z:-1];
		[self addChild:pacman];
		[self addChild:ghost];
		
		// Make this layer receive gestures and touches
		[self setIsTouchEnabled:YES];
		[[Gestures sharedGestures] setUseSwipes:YES];
		[[Gestures sharedGestures] setDelegate:self];
	}

	return self;
}


/*
 * Cleanup.
 */
- (void)dealloc {
	
	[spriteSheet release];
	[map release];
	[nodes release];
	[objects release];
	[pacman release];
	[hud release];
	
	[super dealloc];
}


/*
 *  TouchBegin handler, for now start the game or initiate a scroll.
 */
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (!gameStarted) {
		
		[self setGameStarted:YES];
		
		pacmanAI = [[PacmanAI alloc] initWithMap:map 
										   nodes:nodes 
										  pacman:pacman
										   ghost:ghost];
		
		[pacmanAI start];
		
		return;
	}
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:[touch view]];	
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	[[Gestures sharedGestures] reset];	
	[[Gestures sharedGestures] addPoint:touchLocation];	
	
	[self clearBoundaryCheck:nil];
	
	[[CCActionManager sharedManager] removeAllActionsFromTarget:self];
}


-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	CGPoint start = [touch locationInView: [touch view]];	
	start = [[CCDirector sharedDirector] convertToGL: start];
	CGPoint end = [touch previousLocationInView:[touch view]];
	end = [[CCDirector sharedDirector] convertToGL:end];
	
	float dify = end.y - start.y;		
	
	[self scrollY:dify];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:[touch view]];	
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	[[Gestures sharedGestures] addPoint:touchLocation];
}


/*
 *  Scroll this layer up/down
 */
- (void)scrollY:(float)dify {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CGPoint newPoint = ccp([self position].x, ([self position].y - dify));
	
	if (newPoint.y > 0) {
		
		newPoint.y = 0;
	}
	else if (newPoint.y < (winSize.height - [self mapHeight])) {
				
		newPoint.y = (winSize.height - [self mapHeight]);
	}
	
	[self setPosition:newPoint];
}


/*
 *  This is called by the cocos2d scheduler, when an easing action is scrolling our layer, 
 *  to keep the view in bounds.
 */
- (void)boundaryCheck:(id)sender {

	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	BOOL outOfBounds = NO;
	float newY;
	if ([self position].y > 0) {
				
		newY = 0;
		outOfBounds = YES;
	}
	else if ([self position].y < (winSize.height - [self mapHeight])) {
					
		newY = (winSize.height - [self mapHeight]);
		outOfBounds = YES;
	}
	
	if (outOfBounds) {
	
		[self clearBoundaryCheck:nil];
		[self setPosition:ccp([self position].x, newY)];
		[[CCActionManager sharedManager] removeAllActionsFromTarget:self];
	}
}


/*
 *   Called to unschedule the boundary checker method above. It is called when an easing action is 
 *   complete, or when the above method declares the view outOfBounds and stops the action.
 */ 
- (void)clearBoundaryCheck:(id)sender {

	[self unschedule:@selector(boundaryCheck:)];	
}


- (GGTile *)nodeForPosition:(CGPoint)pos {
	
    int col = (pos.x / map.tileSize.width);
    int row = ((map.mapSize.height * map.tileSize.height) - pos.y) / map.tileSize.height;
	
	const int NUM_COLS = map.mapSize.width;
	
	int nodeIndex = (NUM_COLS * (row + 1)) - NUM_COLS + col;
	
	NSAssert(nodeIndex > 0 && nodeIndex < [nodes count] && [nodes objectAtIndex:nodeIndex] != nil, 
			 @"Invalid node index for position.");
	
	return [nodes objectAtIndex:nodeIndex];
}


#pragma mark GestureComplete callbacks


-(void) swipeUpComplete {

	NSLog(@"Swiped Up");	
	
	CGPoint velocity = [[Gestures sharedGestures] accelerationSpeed];
		
	float dify = (abs(velocity.y) / 30);
	
	if (dify > 0) {
		
		id move = [CCMoveTo actionWithDuration:2.0 position:ccp([self position].x, [self position].y + dify)];
		
		id moveEase = [CCEaseOut actionWithAction:[[move copy] autorelease] rate:2.0f];

		id unschedule = [CCCallFuncN actionWithTarget:self 
											selector:@selector(clearBoundaryCheck:)];
		
		[self schedule:@selector(boundaryCheck:)];
		[self runAction:[CCSequence actions:moveEase, unschedule, nil]];
	}
}


-(void) swipeDownComplete {

	NSLog(@"Swiped Down");	
	
	CGPoint velocity = [[Gestures sharedGestures] accelerationSpeed];
	
	float dify = (abs(velocity.y) / 30);
	
	if (dify > 0) {
		
		id move = [CCMoveTo actionWithDuration:2.0 position:ccp([self position].x, [self position].y - dify)];
		
		id moveEase = [CCEaseOut actionWithAction:[[move copy] autorelease] 
											 rate:2.0f];

		id unschedule = [CCCallFuncN actionWithTarget:self 
											selector:@selector(clearBoundaryCheck:)];
		
		[self schedule:@selector(boundaryCheck:)];
		[self runAction:[CCSequence actions:moveEase, unschedule, nil]];
	}
}

			   // Returns the mapHeight in pixels.
- (int)mapHeight {
	
	return [map mapSize].height * [map tileSize].height;	
}


// Returns the mapWidth in pixels.
- (int)mapWidth {
	
	return [map mapSize].width * [map tileSize].width;	
}


@end
