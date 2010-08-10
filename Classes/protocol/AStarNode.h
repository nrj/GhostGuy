//
//  AStarNode.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


@protocol AStarNode

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

- (void)setParentNode:(id <AStarNode>)value;
- (id <AStarNode>)parentNode;

- (void)highlight;

- (int)weight;

@end
