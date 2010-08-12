//
//  GhostGuyMap.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BitmapImage;


@interface GhostGuyMap : NSObject {

	int levelNumber;
	BitmapImage *levelImage;
	NSMutableArray *tiles;
}


@property(readwrite, assign) int levelNumber;
@property(readwrite, retain) BitmapImage *levelImage;
@property(readwrite, retain) NSMutableArray *tiles;

- (id)initWithLevelNumber:(int)level;

- (NSArray *)edibleTiles;

- (NSArray *)edibleTilesInQuadrant:(int)q;

@end
