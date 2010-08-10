//
//  GameScene.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "cocos2d.h"
#import "AStarNode.h"

@class GhostGuyMap, Pacman, Ghost;


@interface GameScene : CCLayer {

	int currentLevel;
	GhostGuyMap *currentMap;
	CCSpriteSheet *spriteSheet;
	Pacman *pacman;
	Ghost *ghost;
	BOOL gameStarted;
}


@property(readwrite, assign) int currentLevel;
@property(readwrite, retain) GhostGuyMap *currentMap;
@property(readwrite, retain) CCSpriteSheet *spriteSheet;
@property(readwrite, retain) Pacman *pacman;
@property(readwrite, retain) Ghost *ghost;
@property(readwrite, assign) BOOL gameStarted;

+ (id)scene;

- (void)start;

- (void)drawMapForLevelNumber:(int)level;

- (id <AStarNode>)determineTargetNode;

- (NSArray *)findPathToNode:(id <AStarNode>)goal fromNode:(id <AStarNode>)start;

- (NSArray *)actionAnimationsForNode:(id <AStarNode>)node;

- (int)winHeight;

- (int)winWidth;


@end
