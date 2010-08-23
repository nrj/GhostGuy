//
//  AStarPathOperation.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "AStarNode.h"

@class AIObject;

@interface AStarPathOperation : NSOperation {

	AIObject *ai;
	id <AStarNode>startNode;
	id <AStarNode>endNode;
}

- (id)initWithAI:(AIObject *)impl startNode:(id <AStarNode>)start endNode:(id <AStarNode>)end;

@property(nonatomic, retain) AIObject *ai;
@property(nonatomic, assign) id <AStarNode>startNode;
@property(nonatomic, assign) id <AStarNode>endNode;

@end
