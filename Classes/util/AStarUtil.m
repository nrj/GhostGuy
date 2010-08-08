//
//  AStarUtil.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "AStarUtil.h"
#import "AStarNode.h"

@implementation AStarUtil


+ (void)moveNode:(id <AStarNode>)node fromList:(NSMutableArray *)fromList toList:(NSMutableArray *)toList {
	
	if (![fromList containsObject:node]) {
	
		[NSException raise:@"Error moving node." format:@"Node %@ was not found in fromList %@", node, fromList];
	}
	else if ([toList containsObject:node]) {
		
		[NSException raise:@"Error moving node." format:@"Node %@ already exists in toList %@", node, toList];
	}
	
	[fromList removeObjectAtIndex:[fromList indexOfObject:node]];
	[toList addObject:node];
}


+ (int)distanceTraveled:(id <AStarNode>)node {

	int i = 0;
	
	id <AStarNode>n = node;
	
	while([n parentNode]) {
	
		n = [n parentNode];
		i++;
	}
	
	return i;
}


+ (int)manhattanHeuristicForStartNode:(id <AStarNode>)sNode endNode:(id <AStarNode>)eNode {
	
	return abs([sNode row] - [eNode row]) + abs([sNode column] - [eNode column]);
}


@end
