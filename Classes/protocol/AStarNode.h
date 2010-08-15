//
//  AStarNode.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


@protocol AStarNode

- (int)index;
- (int)row;
- (int)column;

- (void)setF:(int)value;
- (int)f;

- (void)setG:(int)value;
- (int)g;

- (void)setH:(int)value;
- (int)h;

- (CGPoint)position;

- (NSArray *)getWalkableNeighbors:(NSArray *)nodes;

- (void)setParentNode:(id <AStarNode>)value forId:(int)i;
- (id <AStarNode>)getParentNodeForId:(int)i;
- (void)deleteParentNodeForId:(int)i;

- (void)highlight;
- (void)unHighlight;

- (int)weight;

@end
