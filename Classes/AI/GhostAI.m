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

	if (![tile isWalkable]) {
		
		NSArray *neighbors = [tile getWalkableNeighbors:(NSArray *)[map tiles]];
		
		if ([neighbors count] > 0) {
		
			tile = [neighbors objectAtIndex:(arc4random() % [neighbors count])];
		}
		else {
		
			return;
		}
	}
	
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
			
			NSArray *moveActions = [self moveActionsForNode:[path objectAtIndex:1]];
			[ghost runAction:[CCSequence actionsInArray:moveActions]];
		}
	}	
}


- (int)aiKey {

	return 1;
}


- (NSArray *)enemies {
	
	return nil;
}


- (NSArray *)moveActionsForNode:(id <AStarNode>)node {
	
	id actionWillMove = [CCCallFuncND actionWithTarget:self 
											  selector:@selector(ghost:willMoveTo:) 
												  data:node];
	
	id actionMove = [CCMoveTo actionWithDuration:.22f
										position:[node position]];
	
	id actionDidMove = [CCCallFuncND actionWithTarget:self 
											 selector:@selector(ghost:didMoveTo:)
												 data:node];
	
	return [NSArray arrayWithObjects:actionWillMove, actionMove, actionDidMove, NULL];
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
	
//	NSLog(@"ghost:didMoveTo:%@", tile);

	[ghost setCurrentTile:tile];
	
	id <AStarNode>goal = [self updateTargetNode];
	
	NSArray *path = [self findPathToNode:goal fromNode:tile];
	
	if (goal && [path count] > 0) {
		
		NSArray *actions = [self moveActionsForNode:[path objectAtIndex:1]];
		
		[[CCActionManager sharedManager] addAction:[CCSequence actionsInArray:actions] 
											target:ghost 
											paused:NO];
	}
}


@end
