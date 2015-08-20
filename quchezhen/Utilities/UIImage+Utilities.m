//
//  UIImage+Utilities.m
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "UIImage+Utilities.h"





@implementation UIImage (HDStretch)

- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        return [self resizableImageWithCapInsets:capInsets];
    }
    return [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
}


- (UIImage *)stretchableImageByHeightCenter
{
	CGFloat topCapHeight = floorf(self.size.height / 2);
	if (topCapHeight == self.size.height / 2)
	{
		topCapHeight--;
	}
    return [self stretchableImageWithCapInsets:UIEdgeInsetsMake(topCapHeight, 0, topCapHeight, 0)];
	return [self stretchableImageWithLeftCapWidth:0
									 topCapHeight:topCapHeight];
}


@end

@implementation UIImage(SaveUtilities)

- (BOOL)saveToPNGFile:(NSString *)savePath
{
    return [UIImagePNGRepresentation(self) saveToFile:savePath];
}

- (BOOL)saveToJPGFile:(NSString *)savePath compressionQuality:(CGFloat)quality
{
    return [UIImageJPEGRepresentation(self, quality) saveToFile:savePath];;
}
@end

@implementation UIImage (ImageGenerator)

+(UIImage*)imageWithPureColorBackgroundImage:(CGColorRef)color withSize:(CGSize)size
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, size.width, size.height));
    
    
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                newRect.size.width * 4,
                                                rgbColorSpace,					// CGImageGetColorSpace(imageRef)
                                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(rgbColorSpace);
	
	// Default white background color.
	CGRect rect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
	CGContextSetFillColorWithColor(bitmap, color);
	CGContextFillRect(bitmap, rect);
	
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}


+ (UIImage *)roundedImageWithSize:(CGSize)size color:(UIColor *)color radius:(CGFloat)radius {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, size.width, size.height));
    
    
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                newRect.size.width * 4,
                                                rgbColorSpace,					// CGImageGetColorSpace(imageRef)
                                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(rgbColorSpace);
	
	// Default white background color.
	CGRect rect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextAddPath(bitmap, clippath);
    CGContextClip(bitmap);
    
	CGContextSetFillColorWithColor(bitmap, color.CGColor);
	CGContextFillRect(bitmap, rect);
	
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}


@end

