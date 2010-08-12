//
//  PacmanAIDelegate.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <UIKit/UIKit.h>

@class MapTile;

@protocol PacmanAIDelegate


- (void)pacman:(id)sender willMoveTo:(MapTile *)tile;

- (void)pacman:(id)sender didMoveTo:(MapTile *)tile;


@end
