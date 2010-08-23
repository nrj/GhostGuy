//
//  CGPointUtils.m
//  pocket Kat
//
//  Created by Aaron Klick on 10/10/09.
//  Copyright 2009 Vantage Technic. All rights reserved.
//

#import "CGPointUtils.h"

#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
	CGFloat deltaX = second.x - first.x;
	CGFloat deltaY = second.y - first.y;
	return sqrt((deltaX*deltaX) + (deltaY*deltaY));
};

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
	CGFloat height = second.y - first.y;
	CGFloat width = first.x - second.x;
	CGFloat rads = atan(height/width);
	return radiansToDegrees(rads);
};

CGFloat angleBetweenLines(CGLine line1, CGLine line2) {
	
	CGFloat a = line1.point2.x - line1.point1.x;
	CGFloat b = line1.point2.y - line1.point1.y;
	CGFloat c = line2.point2.x - line2.point1.x;
	CGFloat d = line2.point2.y - line2.point1.y;
	
	CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
	
	return radiansToDegrees(rads);	
};
						  
CGFloat distanceBetweenLines(CGLine line1, CGLine line2)
{
	CGFloat centerLine1 = (distanceBetweenPoints(line1.point1, line1.point2) / 2);
	CGFloat centerLine2 = (distanceBetweenPoints(line2.point1, line2.point2) / 2);
	
	CGFloat distance = abs(centerLine1 - centerLine2);
	
	return distance;
};

CGCircle CGMakeCircle(CGPoint center, CGFloat radius)
{
	CGCircle nCircle;
	
	nCircle.center = center;
	nCircle.radius = radius;
	
	return nCircle;
};

CGX CGMakeX(CGLine line1, CGLine line2, CGPoint center)
{
	CGX nX;
	
	nX.line1 = line1;
	nX.line2 = line2;
	nX.center = center;
	
	return nX;
};
						  
CGLine CGMakeLine(CGPoint point1, CGPoint point2)
{
	CGLine nLine;
	
	nLine.point1 = point1;
	nLine.point2 = point2;
	
	return nLine;
};

CGSquare CGMakeSquare(CGPoint center, CGFloat width, CGFloat height)
{
	CGSquare nSquare;
	
	nSquare.center = center;
	nSquare.width = width;
	nSquare.height = height;
	
	return nSquare;
};

BOOL CGCircleCollision(CGCircle circle1, CGCircle circle2) 
{
	float xdif = circle1.center.x - circle2.center.x;
	float ydif = circle1.center.y - circle2.center.y;
	
	float distance = sqrt(xdif*xdif+ydif*ydif);
	
	if(distance <= circle1.radius+circle2.radius)
	{
		return YES;
	}
	
	return NO;
};