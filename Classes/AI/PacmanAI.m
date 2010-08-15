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
	
	return 2;
}


- (void)start {
	
	id <AStarNode>goal = [self updateTargetNode];
	
	if (goal) {
	
		NSArray *path = [self findPathToNode:goal fromNode:[pacman currentTile]];
		
		if ([path count] > 0) {
			[self setCurrentPath:[NSMutableArray arrayWithArray:path]];
			NSArray *moveActions = [self moveActionsForNode:[path objectAtIndex:0]];
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
	
	NSString *cacheKey = [NSString stringWithFormat:@"%d", [node index]];
	NSArray *actions = nil;
	
	if (!((actions = [actionCache objectForKey:cacheKey]))) {
		
		id actionWillMove = [CCCallFuncND actionWithTarget:self 
												  selector:@selector(pacman:willMoveTo:) 
													  data:node];
		
		id actionMove = [CCMoveTo actionWithDuration:.18f
											position:[node position]];
		
		id actionDidMove = [CCCallFuncND actionWithTarget:self 
												 selector:@selector(pacman:didMoveTo:)
													 data:node];
		
		actions = [NSArray arrayWithObjects:actionWillMove, actionMove, actionDidMove, NULL];
		[actionCache setObject:actions forKey:cacheKey];
	}
	
	return actions;
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
	
	BOOL recalculatePath = NO;
	
	if (goal != [currentPath lastObject]) {
		
		recalculatePath = YES;
	}
	else {
		
		for (id <AStarNode>node in currentPath) {
		
			if ([self enemyIsOnNode:node]) {
				
				recalculatePath = YES;
				break;
			}
		}
	}
	

	if (recalculatePath) {
	
		NSLog(@"Recalculating pacman path ...");
		
		NSArray *path = [self findPathToNode:goal fromNode:tile];
		[self setCurrentPath:[NSMutableArray arrayWithArray:path]];
	}
	else {
	
		[currentPath removeObjectAtIndex:0];
	}
	
	if ([currentPath count] > 0) {
		
		NSArray *actions = [self moveActionsForNode:[currentPath objectAtIndex:0]];
		
		[[CCActionManager sharedManager] addAction:[CCSequence actionsInArray:actions] 
											target:pacman 
											paused:NO];
	}
}


@end
