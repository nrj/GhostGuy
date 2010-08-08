//
//  GameScene.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


#import "cocos2d.h"

@class GhostGuyMap, Pacman;


@interface GameScene : CCLayer {

	int currentLevel;
	GhostGuyMap *currentMap;
	CCSpriteSheet *spriteSheet;
	Pacman *pacman;
}


@property(readwrite, assign) int currentLevel;
@property(readwrite, retain) GhostGuyMap *currentMap;
@property(readwrite, retain) CCSpriteSheet *spriteSheet;
@property(readwrite, retain) Pacman *pacman;

+ (id)scene;

- (void)drawMapForLevelNumber:(int)level;

- (void)calculateBestPath;

- (int)winHeight;

- (int)winWidth;


@end
