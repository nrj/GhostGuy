//
//  BitmapImage.m
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "BitmapImage.h"


@implementation BitmapImage


@synthesize bitmapData;

@synthesize pixelByteData;

@synthesize pixelData;


- (id)initWithContentsOfFile:(NSString *)path {

	if ((self = [super initWithContentsOfFile:path])) {
		
	}
	
	return self;	
}

- (RGBAPixel *)bitmap {
	
	//  Get the bitmap data from the receiver's CGImage (see UIImage docs)
	
	[self setBitmapData:CGDataProviderCopyData(CGImageGetDataProvider([self CGImage]))];
	
	//  Create a buffer to store bitmap data (unitialized memory as long as the data)
	
	[self setPixelByteData:malloc(CFDataGetLength(bitmapData))];
	
	//  Copy image data into allocated buffer
	
	CFDataGetBytes(bitmapData, CFRangeMake(0, CFDataGetLength(bitmapData)), pixelByteData);
	
	//  Cast a pointer to the first element of pixelByteData
	
	//  Essentially what we're doing is making a second pointer that divides the byteData's units differently - instead of dividing each unit as 1 byte we will divide each unit as 3 bytes (1 pixel).
	
	pixelData = (RGBAPixel *)pixelByteData;
	
	return pixelData;
}

- (void)dealloc {
	
	if (pixelByteData) {
		free(pixelByteData); 
		pixelData = NULL;
	}
	
	[super dealloc];
}

@end
