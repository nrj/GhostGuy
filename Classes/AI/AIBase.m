//
//  AIBase.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "AIBase.h"
#import "GhostGuyMap.h"
#import "Player.h"
#import "Pacman.h"
#import "Ghost.h"
#import "AStarNode.h"
#import "AStarUtil.h"


@implementation AIBase


@synthesize map;

@synthesize pacman;

@synthesize ghost;

@synthesize currentTarget;


- (id)initWithMap:(GhostGuyMap *)m pacman:(Pacman *)p ghost:(Ghost *)g {
	
	if ((self = [super init])) {
		
		[self setMap:m];
		[self setPacman:p];
		[self setGhost:g];
		[self setCurrentTarget:nil];
		
		return self;
	}
	
	return nil;
}


- (void)dealloc {
	
	[map release];
	[pacman release];
	[ghost release];
	[currentTarget release];
	
	[super dealloc];
}


- (int)aiKey {

	// Abstract: Return an array of <Player> pointers which represent an enemy to this AI implementation.
	
	@throw [NSException exceptionWithName:NSGenericException 
								   reason:@"No implementation found for 'aiKey'." 
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


- (id <AStarNode>)randomTargetNode {

	// Return a random edible node;

	NSArray *tileSet = [map edibleTiles];
		
	return [tileSet objectAtIndex:(arc4random() % [tileSet count])];
}


- (NSArray *)findPathToNode:(id <AStarNode>)goal fromNode:(id <AStarNode>)start {
		
	[start setG:[AStarUtil distanceTraveledToNode:start forId:[self aiKey]]];
	[start setH:[AStarUtil heuristicForStartNode:start endNode:goal]];
	[start setF:([start g] + [start h])];
	
	NSMutableArray *openList = [NSMutableArray arrayWithObjects:start, NULL];
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
				next = [next getParentNodeForId:[self aiKey]];
			}
			
			break;
		}
		else {
			
			[AStarUtil moveNode:currentNode 
					   fromList:openList 
						 toList:closedList];
			
			NSArray *neighbors = [currentNode getWalkableNeighbors:[map tiles]];
			
			int newG = [AStarUtil distanceTraveledToNode:currentNode forId:[self aiKey]] + 1;
			
			for (id <AStarNode>neighbor in neighbors) {

				BOOL enemyEncounter = NO;
				
				if ([self enemies]) {
					
					for (id <Player>enemy in [self enemies]) {
						
						if ([enemy currentTile] == (MapTile *)neighbor) {
							
							enemyEncounter = YES;
							break;
						}
					}
				}
				
				if (![openList containsObject:neighbor] && ![closedList containsObject:neighbor]){
					
					[neighbor setG:newG];
					[neighbor setH:[AStarUtil heuristicForStartNode:neighbor endNode:goal]];
					[neighbor setF:(newG + [neighbor h])];
					[neighbor setParentNode:currentNode forId:[self aiKey]];
					
					[openList addObject:neighbor];
				}
			}
		}	
	}
	
	for (id <AStarNode>node in pathToTake) {
		
		[node deleteParentNodeForId:[self aiKey]];
	}
	
	return [NSArray arrayWithArray:pathToTake];
}


@end
