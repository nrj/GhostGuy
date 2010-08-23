//
//  GameHUD.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "GameHUD.h"


@implementation GameHUD


- (id)init {
	
	if ((self = [super init])) {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		label = [CCLabel labelWithString:@"HUD LAYER" 
							  dimensions:CGSizeMake(winSize.width, 16)
							   alignment:UITextAlignmentLeft 
								fontName:@"Verdana" 
								fontSize:14.0];
		
		label.color = ccc3(255,255,255);
		int margin = 0;
		label.position = ccp(winSize.width - (label.contentSize.width/2) 
							 - margin, label.contentSize.height/2 + margin);
		[self addChild:label];
	}
	
	return self;
}

- (void)updateScore:(int)num {
	
	[label setString:[NSString stringWithFormat:@"%d", num]];
}

@end
