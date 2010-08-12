//
//  GameScene.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "cocos2d.h"
#import "AStarNode.h"

@class GhostGuyMap, Pacman, PacmanAI, Ghost, GhostAI;


@interface GameScene : CCLayer {

	BOOL gameStarted;
	int currentLevel;
	CCSpriteSheet *spriteSheet;	
	GhostGuyMap *currentMap;
	Pacman *pacman;
	PacmanAI *pacmanAI;
	Ghost *ghost;
	GhostAI *ghostAI;
}


@property(readwrite, assign) BOOL gameStarted;

@property(readwrite, assign) int currentLevel;

@property(readwrite, retain) CCSpriteSheet *spriteSheet;

@property(readwrite, retain) GhostGuyMap *currentMap;

@property(readwrite, retain) Pacman *pacman;

@property(readwrite, retain) PacmanAI *pacmanAI;

@property(readwrite, retain) Ghost *ghost;

@property(readwrite, retain) GhostAI *ghostAI;


+ (id)scene;

- (void)start;

- (void)drawMapForLevelNumber:(int)level;

- (int)winHeight;

- (int)winWidth;


@end
