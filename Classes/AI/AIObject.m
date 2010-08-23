//
//  AIObject.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "AIObject.h"
#import "Player.h"
#import "Pacman.h"
#import "Ghost.h"
#import "GGTile.h"
#import "AStarNode.h"
#import "AStarUtil.h"
#import "AStarPathOperation.h"


@implementation AIObject

@synthesize map;

@synthesize nodes;

@synthesize pacman;

@synthesize ghost;

@synthesize currentTarget;

@synthesize currentPath;

@synthesize actionCache;

@synthesize readyForNewPath;


- (id)initWithMap:(CCTMXTiledMap *)m nodes:(NSArray *)n pacman:(Pacman *)p ghost:(Ghost *)g {
	
	if ((self = [super init])) {
		
		[self setMap:m];
		[self setNodes:n];
		[self setPacman:p];
		[self setGhost:g];
		[self setCurrentTarget:nil];
		[self setCurrentPath:nil];
		[self setActionCache:[NSMutableDictionary dictionary]];
		[self setReadyForNewPath:YES];
		
		operationQueue = [[NSOperationQueue alloc] init];
		
		return self;
	}
	
	return nil;
}


- (void)dealloc {
	
	[map release];
	[nodes release];
	[pacman release];
	[ghost release];
	[currentPath release];
	[actionCache release];
	[operationQueue release];
	
	[super dealloc];
}


- (id <AStarNode>)randomTargetNode {

	// Return a random edible node;

	NSMutableArray *edibleTiles = [NSMutableArray array];
	
	for (GGTile *tile in nodes) {
	
		if ([tile isEdible]) {
		
			[edibleTiles addObject:tile];
		}
	}
	
	if (edibleTiles && [edibleTiles count] > 0) {
		
		return [edibleTiles objectAtIndex:(arc4random() % [edibleTiles count])];
	}
	
	return nil;
}


- (BOOL)enemyIsOnNode:(id <AStarNode>)node {
	
	BOOL enemyEncounter = NO;
	
	if ([self enemies]) {
		
		for (id <Player>enemy in [self enemies]) {
			
			if ([enemy currentTile] == (GGTile *)node) {
				
				enemyEncounter = YES;
				break;
			}
		}
	}
	
	return enemyEncounter;
}


- (void)travelCurrentPath {
	
	if ([currentPath count] > 0) {
		[self setReadyForNewPath:NO];
		NSArray *moveActions = [self moveActionsForNode:[currentPath objectAtIndex:0]];
		[pacman runAction:[CCSequence actionsInArray:moveActions]];
	}
}	


- (void)findPathFrom:(id <AStarNode>)startNode to:(id <AStarNode>)endNode {
	
	AStarPathOperation *pathOp = [[AStarPathOperation alloc] initWithAI:self 
															  startNode:startNode 
																endNode:endNode];
	[operationQueue addOperation:pathOp];
	[pathOp release];
}


/*
 *  This will be called when a new path was calculated by the AStarPathOperation, but only when 
 *  readyForNewPath is true.
 */ 
- (void)didReceiveNewPath:(NSArray *)path {
	
	[self setCurrentTarget:[path lastObject]];
	[self setCurrentPath:[NSMutableArray arrayWithArray:path]];
	
	[self travelCurrentPath];
}



- (NSArray *)getWalkableNeighbors:(id <AStarNode>)node {

	NSMutableArray *walkable = [NSMutableArray array];

	int ti = [self getIndexAboveNode:node];
	int ri = [self getIndexRightOfNode:node];
	int bi = [self getIndexBelowNode:node];
	int li = [self getIndexLeftOfNode:node];

	if (ti != -1 && [[nodes objectAtIndex:ti] isWalkable]) {
	
		[walkable addObject:[nodes objectAtIndex:ti]];
	}
	if (ri != -1 && [[nodes objectAtIndex:ri] isWalkable]) {

		[walkable addObject:[nodes objectAtIndex:ri]];
	}
	if (bi != -1 && [[nodes objectAtIndex:bi] isWalkable]) {
		
		[walkable addObject:[nodes objectAtIndex:bi]];		
	}
	if (li != -1 && [[nodes objectAtIndex:li] isWalkable]) {
		
		[walkable addObject:[nodes objectAtIndex:li]];		
	}
		
	return [NSArray arrayWithArray:walkable];
}


- (int)getIndexLeftOfNode:(id <AStarNode>)node {

	const int NUM_COLS = map.mapSize.width;

	int nodeIndex = [nodes indexOfObject:node];
	
	return (nodeIndex % NUM_COLS) != 0 ? (nodeIndex - 1) : -1;
}


- (int)getIndexRightOfNode:(id <AStarNode>)node {
	
	const int NUM_COLS = map.mapSize.width;

	int nodeIndex = [nodes indexOfObject:node];
	
	return ((nodeIndex + 1) % NUM_COLS) != 0 ? (nodeIndex + 1) : -1;
}


- (int)getIndexAboveNode:(id <AStarNode>)node {

	const int NUM_COLS = map.mapSize.width;

	int nodeIndex = [nodes indexOfObject:node];
	
	return (nodeIndex > NUM_COLS) ? (nodeIndex - NUM_COLS) : -1;
}


- (int)getIndexBelowNode:(id <AStarNode>)node {

	const int NUM_COLS = map.mapSize.width;
	const int NUM_ROWS = map.mapSize.height;

	int nodeIndex = [nodes indexOfObject:node];
	
	return (nodeIndex < (NUM_COLS * (NUM_ROWS - 1))) ? (nodeIndex + NUM_COLS) : -1;
}


#pragma mark Abstract Methods


- (int)gid {
	
	// Abstract: Return an array of <Player> pointers which represent an enemy to this AI implementation.
	
	@throw [NSException exceptionWithName:NSGenericException 
								   reason:@"No implementation found for 'gid'." 
								 userInfo:nil];
}


- (NSArray *)enemies {
	
	// Abstract: Return an array of <Player> pointers which represent an enemy to this AI implementation.
	
	@throw [NSException exceptionWithName:NSGenericException 
								   reason:@"No implementation found for 'enemies'." 
								 userInfo:nil];
}


- (NSArray *)moveActionsForNode:(id <AStarNode>)node {
	
	// Abstract: Return an array of CCActions needed to move this AI to node.
	
	@throw [NSException exceptionWithName:NSGenericException 
								   reason:@"No implementation found for 'moveActionsForNode:'." 
								 userInfo:nil];
}


- (void)start {
	
	// Abstract: Start this AI implementation.
	
	@throw [NSException exceptionWithName:NSGenericException 
								   reason:@"No implementation found for 'start'." 
								 userInfo:nil];	
}


- (id <AStarNode>)updateTargetNode {
	
	// Abstract: Determine the current target node for this AI and return it.
	
	@throw [NSException exceptionWithName:NSGenericException 
								   reason:@"No implementation found for 'updateTargetNode'." 
								 userInfo:nil];	
	
}


@end
