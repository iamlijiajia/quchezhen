//
//  UIImage+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>





/**
 用于支持图片拉伸
 */
@interface UIImage (HDStretch)
/**
 iOS5以前使用的是
 - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
 
 iOS5之后新添加方法
 - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets;
 而
 - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
 工作不正常
 所以根据情况需要判断，所以添加此方法，统一使用此方法
 */
- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets;


/**
 上下拉伸
 */
- (UIImage *)stretchableImageByHeightCenter;



@end

/**
 保存Image到文件
 */
@interface UIImage (SaveUtilities)

/**
 如果没有完整路径会先建立完整路径
 */
- (BOOL)saveToJPGFile:(NSString *)savePath compressionQuality:(CGFloat)quality;
- (BOOL)saveToPNGFile:(NSString *)savePath;
@end

@interface UIImage (ImageGenerator)

+(UIImage*)imageWithPureColorBackgroundImage:(CGColorRef)color withSize:(CGSize)size;

+ (UIImage *)roundedImageWithSize:(CGSize)size color:(UIColor *)color radius:(CGFloat)radius;


@end

