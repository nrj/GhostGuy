//
//  BitmapImage.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>

typedef unsigned char byte;

typedef struct RGBAPixel {
	byte    red;
	byte    green;
	byte    blue;
	byte	alpha;
} RGBAPixel;


@interface BitmapImage : UIImage {
		
	CFDataRef bitmapData;     
	UInt8 *pixelByteData;
	RGBAPixel *pixelData;
}

@property(readwrite, assign) CFDataRef bitmapData;
@property(readwrite, assign) UInt8 *pixelByteData;
@property(readwrite, assign) RGBAPixel *pixelData;

- (RGBAPixel *)bitmap;

@end
