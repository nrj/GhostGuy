//
//  AStarUtil.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "AStarNode.h"

@interface AStarUtil : NSObject


+ (void)moveNode:(id <AStarNode>)node fromList:(NSMutableArray *)fromList toList:(NSMutableArray *)toList;

+ (int)distanceTraveled:(id <AStarNode>)node;

+ (int)manhattanHeuristicForStartNode:(id <AStarNode>)sNode endNode:(id <AStarNode>)eNode;


@end
