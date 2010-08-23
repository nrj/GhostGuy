//
//  GameScene.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "cocos2d.h"
#import "Gestures.h"

@class GameHUD, Pacman, PacmanAI, Ghost, GhostAI, GGTile;

@interface GameScene : CCLayer <GestureComplete> {

	CCSpriteSheet *spriteSheet;
	
	CCTMXTiledMap *map;
	CCTMXLayer *tileLayer;
	NSArray *nodes;
	CCTMXObjectGroup *objects;
	GameHUD *hud;
	
	Pacman *pacman;
	PacmanAI *pacmanAI;
	
	Ghost *ghost;
	GhostAI *ghostAI;
	
	BOOL gameStarted;
}

@property (nonatomic, retain) GameHUD *hud;
@property (nonatomic, assign) BOOL gameStarted; 

+ (id)scene;

- (void)scrollY:(float)dify;
- (void)boundaryCheck:(id)sender;
- (void)clearBoundaryCheck:(id)sender;

- (int)mapHeight;
- (int)mapWidth;
- (GGTile *)nodeForPosition:(CGPoint)pos;

@end
