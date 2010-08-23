//
//  AStarPathOperation.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "NSObject+Extensions.h"
#import "AIObject.h"
#import "AStarPathOperation.h"
#import "AStarUtil.h"

@implementation AStarPathOperation

@synthesize ai;

@synthesize startNode;

@synthesize endNode;


- (id)initWithAI:(AIObject *)impl startNode:(id <AStarNode>)start endNode:(id <AStarNode>)end {

	if ((self = [super init])) {
		
		[self setAi:impl];
		[self setStartNode:start];
		[self setEndNode:end];
	}
	
	return self;
}


- (void)dealloc {

	[ai release];
	[super dealloc];
}

- (void)main {

	NSLog(@"Calculating path from %@ to %@", startNode, endNode);
	
	[startNode setG:[AStarUtil distanceTraveledToNode:startNode forId:[ai gid]]];
	[endNode setH:[AStarUtil heuristicForStartNode:startNode endNode:endNode]];
	
	NSMutableArray *openList = [NSMutableArray arrayWithObjects:startNode, NULL];
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
		
		if ([ai enemyIsOnNode:endNode]) {
		
			return;
		}
		
		if (currentNode == endNode) { 
			
			id <AStarNode>next = endNode;
			
			while (next) {
				
				[pathToTake insertObject:next atIndex:0];
				next = [next getParentNodeForId:[ai gid]];
			}
			
			break;
		}
		else {
			
			[AStarUtil moveNode:currentNode 
					   fromList:openList 
						 toList:closedList];
			
			NSArray *neighbors = [ai getWalkableNeighbors:currentNode];
			
			int newG = [AStarUtil distanceTraveledToNode:currentNode forId:[ai gid]] + 1;
			
			for (id <AStarNode>neighbor in neighbors) {
				
				if ([ai enemyIsOnNode:neighbor]) continue;
				
				if ([openList containsObject:neighbor] && newG < [neighbor g]) {
					
					[neighbor setG:newG];
					[neighbor setParentNode:currentNode forId:[ai gid]];					
				}
				else if ([closedList containsObject:neighbor] && newG < [neighbor g]) {
					
					[neighbor setG:newG];
					[neighbor setParentNode:currentNode forId:[ai gid]];
				}
				else if (![openList containsObject:neighbor] && ![closedList containsObject:neighbor]){
					
					[neighbor setG:newG];
					[neighbor setH:[AStarUtil heuristicForStartNode:neighbor endNode:endNode]];
					[neighbor setParentNode:currentNode forId:[ai gid]];
					
					[openList addObject:neighbor];
				}
			}
		}	
	}
	
	for (id <AStarNode>node in [ai nodes]) {
		
		[node removeParentNodeForId:[ai gid]];
	}
	
	if ([pathToTake count] > 0) {
		
		[pathToTake removeObjectAtIndex:0];
	}
	
	while (![[ai invokeOnMainThreadAndWaitUntilDone:YES] readyForNewPath]) {
		
		//NSLog(@"AI is NOT ready to receive new path");
	}
	
	NSLog(@"Calculated path %@", [NSArray arrayWithArray:pathToTake]);
	
	[[ai invokeOnMainThread] didReceiveNewPath:pathToTake];
}

@end
