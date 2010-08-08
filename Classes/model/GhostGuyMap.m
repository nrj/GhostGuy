//
//  GhostGuyMap.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "GhostGuyMap.h"
#import "BitmapImage.h"


@implementation GhostGuyMap


@synthesize levelNumber;

@synthesize levelImage;

@synthesize tiles;


- (id)initWithLevelNumber:(int)level {
	
	if ((self = [super init])) {
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Tiles.plist"];
		
		tiles = [[NSMutableArray alloc] init];
		
		[self setLevelNumber:level];
		
		BitmapImage *image = [[BitmapImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] 
									pathForResource:[NSString stringWithFormat:@"Level-%d", level] 
								    ofType:@"png"]];
		
		[self setLevelImage:image];
	}
	
	return self;
}


- (void)dealloc {

	[levelImage release]; levelImage = nil;
	[tiles release]; tiles = nil;
	[super dealloc];
}


@end
