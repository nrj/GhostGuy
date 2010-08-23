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
#import "GGTile.h"


@implementation PacmanAI


- (int)gid {
	
	return 2;
}


- (void)start {
	
	id <AStarNode>goal = [self updateTargetNode];
	
	if (goal) {
	
		[self findPathFrom:[pacman currentTile] to:goal];
	}
}


- (NSArray *)enemies {
	
	return [NSArray arrayWithObjects:ghost, NULL];
}


- (id <AStarNode>)updateTargetNode {
	
		
	if (!currentTarget || currentTarget == [pacman currentTile]) {
		
		
		[self setCurrentTarget:(GGTile *)[self randomTargetNode]];
	}
	
	return currentTarget;
}


- (NSArray *)moveActionsForNode:(id <AStarNode>)node {
	
	NSString *cacheKey = [NSString stringWithFormat:@"%d,%d", [node row], [node column]];
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


- (void)pacman:(id)sender willMoveTo:(GGTile *)tile {
	
	int newDirection = -1;

	if ([self getIndexLeftOfNode:tile] == [nodes indexOfObject:[pacman currentTile]]) {
	
		newDirection = PlayerDirectionRight;
	}
	else if ([self getIndexRightOfNode:tile] == [nodes indexOfObject:[pacman currentTile]]) {
		
		newDirection = PlayerDirectionLeft;
	}
	else if ([self getIndexAboveNode:tile] == [nodes indexOfObject:[pacman currentTile]]) {
		
		newDirection = PlayerDirectionDown;
	}
	else if ([self getIndexBelowNode:tile] == [nodes indexOfObject:[pacman currentTile]]) {
		
		newDirection = PlayerDirectionUp;
	}
	
	[pacman setDirection:newDirection];
	
	// Determine if we need to calculate a new path after this move
	
	BOOL recalculatePath = NO;
	
	if ([currentPath lastObject] == tile) {
		
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
		
		id <AStarNode>goal = [self randomTargetNode];
		
		for (int i = ([currentPath count] - 1); i > [currentPath indexOfObject:tile]; i--) {
		
			[currentPath removeObjectAtIndex:i];
		}
		
		[self findPathFrom:tile to:goal];
	}
}


- (void)pacman:(id)sender didMoveTo:(GGTile *)tile {
	
//	if ([tile isEdible]) {
//
//		[tile setType:GGTileEmptySpace];
//	}
	
	[pacman setCurrentTile:tile];
	[currentPath removeObjectAtIndex:0];
	
	if ([currentPath count] > 0) {
		
		NSArray *actions = [self moveActionsForNode:[currentPath objectAtIndex:0]];
		
		[[CCActionManager sharedManager] addAction:[CCSequence actionsInArray:actions] 
											target:pacman 
											paused:NO];
	}
	else {
		
		[self setReadyForNewPath:YES];
	}
}


@end
