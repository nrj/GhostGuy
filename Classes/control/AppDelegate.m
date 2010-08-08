//
//  AppDelegate.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameScene.h"


@implementation AppDelegate


@synthesize window;


- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	CC_DIRECTOR_INIT();
	
	CCDirector *director = [CCDirector sharedDirector];

	[director setDisplayFPS:NO];	
	[director setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
		
	[[CCDirector sharedDirector] runWithScene:[GameScene scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}


- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}


- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}


@end
