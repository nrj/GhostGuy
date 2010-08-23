//
//  AStarUtil.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "AStarUtil.h"
#import "AStarNode.h"
#import "cocos2d.h"
#import "GGTile.h"

@implementation AStarUtil


+ (NSArray *)createNodesForMap:(CCTMXTiledMap *)map layer:(CCTMXLayer *)layer {

	NSMutableArray *arr = [NSMutableArray array];
	CGSize s = [layer layerSize];

	for (int row = 0; row < s.height; row++) {
		
		for (int col = 0; col < s.width; col++) {

			int gid = [layer tileGIDAt:ccp(col, row)];
			
			NSDictionary *props = [map propertiesForGID:gid];
			
			float x = ((col + 1) * map.tileSize.width) - (map.tileSize.width / 2);
			float y = (map.mapSize.height * map.tileSize.height) - (map.tileSize.height * row) - (map.tileSize.height / 2);
		  
			NSAssert(props != nil && [props objectForKey:@"type"] != nil, @"Invalid Tile Properties for GID %d", gid);
			
			GGTile *tile = [[GGTile alloc] initWithType:[[props objectForKey:@"type"] intValue]
											   position:ccp(x, y) 
													row:row 
												 column:col];
			
			[arr addObject:tile];
		}
	}
	
	return [NSArray arrayWithArray:arr];
}


+ (void)moveNode:(id <AStarNode>)node fromList:(NSMutableArray *)fromList toList:(NSMutableArray *)toList {
	
	if (![fromList containsObject:node]) {
	
		[NSException raise:@"Error moving node." format:@"Node %@ was not found in fromList %@", node, fromList];
	}
	else if ([toList containsObject:node]) {
		
		[NSException raise:@"Error moving node." format:@"Node %@ already exists in toList %@", node, toList];
	}
	
	[fromList removeObjectAtIndex:[fromList indexOfObject:node]];
	[toList addObject:node];
}


+ (int)distanceTraveledToNode:(id <AStarNode>)node forId:(int)uid {

	int i = 0;
	
	id <AStarNode>n = node;
	
	while([n getParentNodeForId:uid]) {
	
		n = [n getParentNodeForId:uid];
		i++;
	}
	
	return i;
}


+ (int)heuristicForStartNode:(id <AStarNode>)sNode endNode:(id <AStarNode>)eNode {
	
	int manhattan = abs([sNode row] - [eNode row]) + abs([sNode column] - [eNode column]);
	
	//return (manhattan - [sNode weight]);
	return manhattan;
}


@end
