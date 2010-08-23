//
//  GameHUD.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameHUD : CCLayer {

	CCLabel *label;
}

- (void)updateScore:(int)num;

@end
