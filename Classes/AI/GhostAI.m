//
//  GhostAI.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "GhostAI.h"
#import "cocos2d.h"
#import "Pacman.h"
#import "Ghost.h"
#import "MapTile.h"

@implementation GhostAI


- (void)start {
	
}


- (void)travelToTile:(MapTile *)tile {

	if (tile == [ghost currentTile]) {

		[self setCurrentTarget:nil];
		return;
	}
	
	if (![tile isWalkable]) {
		
		NSArray *neighbors = [tile getWalkableNeighbors:(NSArray *)[map tiles]];
		
		if ([neighbors count] > 0) {
		
			tile = [neighbors objectAtIndex:(arc4random() % [neighbors count])];
		}
		else {
		
			return;
		}
	}
	
	[tile select];
	
	BOOL runAction = NO;
	
	if (!currentTarget)  {
		
		runAction = YES;
	}
	
	id <AStarNode>goal = tile;
	
	[self setCurrentTarget:tile];
	
	if (runAction) {
		
		NSArray *path = [self findPathToNode:goal 
									fromNode:[ghost currentTile]];
		
		if ([path count] > 0) {
			[self setCurrentPath:[NSMutableArray arrayWithArray:path]];
			NSArray *moveActions = [self moveActionsForNode:[currentPath objectAtIndex:0]];
			[ghost runAction:[CCSequence actionsInArray:moveActions]];
		}
	}
	else {
	
		[self setCurrentTarget:tile];
	}
}


- (int)aiKey {

	return 1;
}


- (NSArray *)enemies {
	
	return nil;
}


- (NSArray *)moveActionsForNode:(id <AStarNode>)node {
	
	NSString *cacheKey = [NSString stringWithFormat:@"%d", [node index]];
	NSArray *actions = nil;

	if (!((actions = [actionCache objectForKey:cacheKey]))) {
				
		id actionWillMove = [CCCallFuncND actionWithTarget:self 
												  selector:@selector(ghost:willMoveTo:) 
													  data:node];
		
		id actionMove = [CCMoveTo actionWithDuration:.18f
											position:[node position]];
		
		id actionDidMove = [CCCallFuncND actionWithTarget:self 
												 selector:@selector(ghost:didMoveTo:)
													 data:node];
		
		actions = [NSArray arrayWithObjects:actionWillMove, actionMove, actionDidMove, NULL];
		[actionCache setObject:actions forKey:cacheKey];
	}
	
	return actions;
}



- (id <AStarNode>)updateTargetNode {
		
	if (!currentTarget || currentTarget == [ghost currentTile]) {
		
		[self setCurrentTarget:nil];
	}
	
	return currentTarget;
}


#pragma mark GhostAIDelegate methods


- (void)ghost:(id)sender willMoveTo:(MapTile *)tile {
	
	
}


- (void)ghost:(id)sender didMoveTo:(MapTile *)tile {

	[ghost setCurrentTile:tile];
	
	id <AStarNode>goal = [self updateTargetNode];
	
	BOOL recalculatePath = (goal != [currentPath lastObject]);
		
	if (recalculatePath) {
		
		NSLog(@"Recalculating ghost path ...");
		
		NSArray *path = [self findPathToNode:goal fromNode:tile];
		[self setCurrentPath:[NSMutableArray arrayWithArray:path]];
	}
	else {
		
		[currentPath removeObjectAtIndex:0];
	}
	
	if ([currentPath count] > 0) {
		
		NSArray *actions = [self moveActionsForNode:[currentPath objectAtIndex:0]];
		
		[[CCActionManager sharedManager] addAction:[CCSequence actionsInArray:actions] 
											target:ghost 
											paused:NO];
	}}


@end
