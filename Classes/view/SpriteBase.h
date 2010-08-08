//
//  SpriteBase.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface SpriteBase : CCSprite

- (int)width;
- (int)height;

- (int)x;
- (int)y;

- (double)centerX;
- (double)centerY;


@end
