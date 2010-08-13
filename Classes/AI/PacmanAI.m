//
//  PacmanAI.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "PacmanAI.h"
#import "cocos2d.h"
#import "Pacman.h"
#import "Ghost.h"
#import "MapTile.h"


@implementation PacmanAI


- (int)aiKey {
	
	return 0;
}


- (void)start {
	
	id <AStarNode>goal = [self updateTargetNode];
	
	if (goal) {
	
		NSArray *path = [self findPathToNode:goal fromNode:[pacman currentTile]];
		
		if ([path count] > 0) {

			NSArray *moveActions = [self moveActionsForNode:[path objectAtIndex:1]];
			[pacman runAction:[CCSequence actionsInArray:moveActions]];
		}
	}
}


- (NSArray *)enemies {
	
	return [NSArray arrayWithObjects:ghost, NULL];
}


- (id <AStarNode>)updateTargetNode {
	
		
	if (!currentTarget || currentTarget == [pacman currentTile]) {
		
		
		[self setCurrentTarget:(MapTile *)[self randomTargetNode]];
	}
	
	return currentTarget;
}


- (NSArray *)moveActionsForNode:(id <AStarNode>)node {
	
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


#pragma mark PacmanAIDelegate methods


- (void)pacman:(id)sender willMoveTo:(MapTile *)tile {
	
	// NSLog(@"pacman:willMoveTo:%@", tile);
	
	int newDirection = -1;
	
	if ([tile getLeftTileIndex] == [[pacman currentTile] index]) {
		
		newDirection = PlayerDirectionRight;
	}
	else if ([tile getRightTileIndex] == [[pacman currentTile] index]) {
		
		newDirection = PlayerDirectionLeft;
	}
	else if ([tile getTopTileIndex] == [[pacman currentTile] index]) {
		
		newDirection = PlayerDirectionDown;
	}
	else if ([tile getBottomTileIndex] == [[pacman currentTile] index]) {
		
		newDirection = PlayerDirectionUp;
	}
	
	[pacman setDirection:newDirection];
}


- (void)pacman:(id)sender didMoveTo:(MapTile *)tile {
	
//	NSLog(@"pacman:didMoveTo:%@", tile);
	
	if ([tile isEdible]) {
		
		// Is the tile edible?
		[tile setType:MapTileEmptySpace]; // Nom it
	}
	
	[pacman setCurrentTile:tile];
	
	// Calculate the next path
	
	id <AStarNode>goal = [self updateTargetNode];
	
	NSArray *path = [self findPathToNode:goal fromNode:tile];
	
	if ([path count] > 0) {
		
		NSArray *actions = [self moveActionsForNode:[path objectAtIndex:1]];
		
		[[CCActionManager sharedManager] addAction:[CCSequence actionsInArray:actions] 
											target:pacman 
											paused:NO];
	}
}


@end
