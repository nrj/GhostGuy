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


+ (int)distanceTraveledToNode:(id <AStarNode>)node forId:(int)uid {

	int i = 0;
	
	id <AStarNode>n = node;
	
	while([n getParentNodeForId:uid]) {
	
		n = [n getParentNodeForId:uid];
		i++;
	}
	
	return i;
}


+ (int)heuristicForStartNode:(id <AStarNode>)sNode endNode:(id <AStarNode>)eNode {
	
	int manhattan = abs([sNode row] - [eNode row]) + abs([sNode column] - [eNode column]);
	
	//return (manhattan - [sNode weight]);
	return manhattan;
}


@end
