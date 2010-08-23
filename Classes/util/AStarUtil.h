//
//  AStarUtil.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "AStarNode.h"

@class CCTMXTiledMap, CCTMXLayer;

@interface AStarUtil : NSObject

+ (NSArray *)createNodesForMap:(CCTMXTiledMap *)map layer:(CCTMXLayer *)layer;

+ (void)moveNode:(id <AStarNode>)node fromList:(NSMutableArray *)fromList toList:(NSMutableArray *)toList;

+ (int)distanceTraveledToNode:(id <AStarNode>)node forId:(int)uid;

+ (int)heuristicForStartNode:(id <AStarNode>)sNode endNode:(id <AStarNode>)eNode;

@end
