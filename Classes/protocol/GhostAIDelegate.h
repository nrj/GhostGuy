//
//  GhostAIDelegate.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <UIKit/UIKit.h>

@class GGTile;

@protocol GhostAIDelegate


- (void)ghost:(id)sender willMoveTo:(GGTile *)tile;

- (void)ghost:(id)sender didMoveTo:(GGTile *)tile;


@end
