//
//  AStarNode.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


@protocol AStarNode

- (int)f;

- (void)setG:(int)value;
- (int)g;

- (void)setH:(int)value;
- (int)h;

- (int)row;
- (int)column;
- (CGPoint)position;

- (void)setParentNode:(id <AStarNode>)value forId:(int)i;
- (id <AStarNode>)getParentNodeForId:(int)i;
- (void)removeParentNodeForId:(int)i;

@end
