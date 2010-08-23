//
//  PacmanAIDelegate.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <UIKit/UIKit.h>

@class GGTile;

@protocol PacmanAIDelegate


- (void)pacman:(id)sender willMoveTo:(GGTile *)tile;

- (void)pacman:(id)sender didMoveTo:(GGTile *)tile;


@end
