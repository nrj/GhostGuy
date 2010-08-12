//
//  AIBase.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "AStarNode.h"

@class GhostGuyMap, Pacman, Ghost, MapTile;


@interface AIBase : NSObject {

	GhostGuyMap *map;
	Pacman *pacman;
	Ghost *ghost;
	MapTile *currentTarget;
}


@property(readwrite, retain) GhostGuyMap *map;

@property(readwrite, retain) Pacman *pacman;

@property(readwrite, retain) Ghost *ghost;

@property(readwrite, retain) MapTile *currentTarget;


- (void)start;

- (int)aiKey;

- (id)initWithMap:(GhostGuyMap *)m pacman:(Pacman *)p ghost:(Ghost *)g;

- (id <AStarNode>)updateTargetNode;

- (id <AStarNode>)randomTargetNode;

- (NSArray *)findPathToNode:(id <AStarNode>)goal fromNode:(id <AStarNode>)start;

- (NSArray *)moveActionsForNode:(id <AStarNode>)node;


@end
