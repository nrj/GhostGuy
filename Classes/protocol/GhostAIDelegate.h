//
//  GhostAIDelegate.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <UIKit/UIKit.h>

@class MapTile;

@protocol GhostAIDelegate


- (void)ghost:(id)sender willMoveTo:(MapTile *)tile;

- (void)ghost:(id)sender didMoveTo:(MapTile *)tile;


@end
