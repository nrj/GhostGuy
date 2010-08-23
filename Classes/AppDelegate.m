//
//  AppDelegate.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "AppDelegate.h"
#import "cocos2d.h"
#import "GameScene.h"

@implementation AppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	CC_DIRECTOR_INIT();
	
	CCDirector *director = [CCDirector sharedDirector];
	
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	//[director setDisplayFPS:YES];
	
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	[[CCDirector sharedDirector] runWithScene: [GameScene scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	
	NSLog(@"applicationWillResignActive");
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
	NSLog(@"applicationDidBecomeActive");
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	
	NSLog(@"applicationDidReceiveMemoryWarning");
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	
	NSLog(@"applicationDidEnterBackground");
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	
	NSLog(@"applicationWillEnterForeground");
	[[CCDirector sharedDirector] startAnimation];
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
