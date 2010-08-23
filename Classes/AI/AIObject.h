//
//  AIObject.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "AStarNode.h"

@class CCTMXTiledMap, Pacman, Ghost;

@interface AIObject : NSObject {

	CCTMXTiledMap *map;
	NSArray *nodes;
	Pacman *pacman;
	Ghost *ghost;
	id <AStarNode>currentTarget;
	NSMutableArray *currentPath;
	NSMutableDictionary *actionCache;
	BOOL readyForNewPath;
	NSOperationQueue *operationQueue;
}


@property(readwrite, retain) CCTMXTiledMap *map;

@property(readwrite, retain) NSArray *nodes;

@property(readwrite, retain) Pacman *pacman;

@property(readwrite, retain) Ghost *ghost;

@property(readwrite, assign) id <AStarNode>currentTarget;

@property(readwrite, retain) NSMutableArray *currentPath;

@property(readwrite, retain) NSMutableDictionary *actionCache;

@property(readwrite, assign) BOOL readyForNewPath;

- (void)start;

- (void)travelCurrentPath;

- (int)gid;

- (NSArray *)enemies;

- (id)initWithMap:(CCTMXTiledMap *)m nodes:(NSArray *)n pacman:(Pacman *)p ghost:(Ghost *)g;

- (id <AStarNode>)updateTargetNode;

- (id <AStarNode>)randomTargetNode;

- (NSArray *)getWalkableNeighbors:(id <AStarNode>)node;

- (int)getIndexLeftOfNode:(id <AStarNode>)node;

- (int)getIndexRightOfNode:(id <AStarNode>)node;

- (int)getIndexAboveNode:(id <AStarNode>)node;

- (int)getIndexBelowNode:(id <AStarNode>)node;

- (void)findPathFrom:(id <AStarNode>)startNode to:(id <AStarNode>)endNode;

- (NSArray *)moveActionsForNode:(id <AStarNode>)node;

- (BOOL)enemyIsOnNode:(id <AStarNode>)node;

- (void)didReceiveNewPath:(NSArray *)path;

@end
