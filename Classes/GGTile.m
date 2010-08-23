//
//  GGTile.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "GGTile.h"


@implementation GGTile

@synthesize g;

@synthesize h;


- (id)initWithType:(GGTileType)t position:(CGPoint)p row:(int)r column:(int)c {

	if ((self = [super init])) {
		
		type = t;
		position = p;
		row = r;
		column = c;

		[self setG:0];
		[self setH:0];
		
		parentMap = [[NSMutableDictionary dictionary] retain];
	}
	
	return self;
}


- (void)dealloc {

	[parentMap release];
	[super dealloc];
}


- (NSString *)description {
	
	return [NSString stringWithFormat:@"<GGTile (%0.f,%0.f) type=%d, row=%d, col=%d>", position.x, position.y, type, row, column];
}


- (GGTileType)type {
	
	return type;
}


- (int)f {
	
	return (g + h);
}


- (CGPoint)position {

	return position;
}


- (int)row {
	
	return row;
}


- (int)column {

	return column;
}


- (BOOL)isEdible {

	return (type == GGTileBigDot || type == GGTileSmallDot);
}


- (BOOL)isWalkable {

	return (type != GGTileWall);
}


- (void)setParentNode:(id <AStarNode>)value forId:(int)i {
	
	NSString *key = [NSString stringWithFormat:@"%d", i];	
	[parentMap setObject:value forKey:key];
}


- (id <AStarNode>)getParentNodeForId:(int)i {
	
	NSString *key = [NSString stringWithFormat:@"%d", i];
	if ([parentMap objectForKey:key]) {
		
		return [parentMap objectForKey:key];
	}
	return nil;
}


- (void)removeParentNodeForId:(int)i {
	
	NSString *key = [NSString stringWithFormat:@"%d", i];
	if ([parentMap objectForKey:key]) {
		
		[parentMap setValue:nil forKey:key];
	}
}


@end
