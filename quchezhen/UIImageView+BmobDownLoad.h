//
//  UIImageView+BmobDownLoad.h
//  quchezhen
//
//  Created by lijiajia on 15/8/18.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BmobDownLoad)

- (id)initWithDefaultImage:(UIImage *)defaultImage NewImageName:(NSString *)imageName andFrame:(CGRect)frame;

- (id)initWithDefaultImageName:(NSString *)defaultImageName NewImageName:(NSString *)imageName andFrame:(CGRect)frame;

- (void)resetWithDefaultImageName:(NSString *)defaultImageName NewImageName:(NSString *)imageName;
- (void)resetWithDefaultImage:(UIImage *)defaultImage NewImageName:(NSString *)imageName;

- (void)loadImageName:(NSString *)imageName withBlock:(void(^)(void))completeBlock;
@end
