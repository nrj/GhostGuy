//
//  GhostAI.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>
#import "AIObject.h"
#import "GhostAIDelegate.h"

@class GGTile;

@interface GhostAI : AIObject <GhostAIDelegate> {

}

- (void)travelToTile:(GGTile *)tile;

@end
