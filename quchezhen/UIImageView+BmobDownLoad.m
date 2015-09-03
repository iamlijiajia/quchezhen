//
//  UIImageView+BmobDownLoad.m
//  quchezhen
//
//  Created by lijiajia on 15/8/18.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "UIImageView+BmobDownLoad.h"
#import "SDProgressView.h"

#import <BmobSDK/BmobProFile.h>
#import "NSFileManager+Utilities.h"
#import "DownLoadManager.h"

@implementation UIImageView(BmobDownLoad)

- (id)initWithDefaultImage:(UIImage *)defaultImage NewImageName:(NSString *)imageName andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self resetWithDefaultImage:defaultImage NewImageName:imageName];
    }
    
    return self;
}

- (id)initWithDefaultImageName:(NSString *)defaultImageName NewImageName:(NSString *)imageName andFrame:(CGRect)frame
{
    UIImage *image = defaultImageName == nil ? nil : [UIImage imageNamed:defaultImageName];
    
    self = [self initWithDefaultImage:image NewImageName:imageName andFrame:frame];
    return self;
}

- (void)resetWithDefaultImageName:(NSString *)defaultImageName NewImageName:(NSString *)imageName
{
    [self resetWithDefaultImage:[UIImage imageNamed:defaultImageName] NewImageName:imageName];
}

- (void)resetWithDefaultImage:(UIImage *)defaultImage NewImageName:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
    if (!self.image)
    {
        NSString *path = CacheFilePath();
        NSString *fileName = [NSFileManager pathForItemNamed:imageName inFolder:path];
        
        if (fileName)
        {
            self.image = [UIImage imageWithContentsOfFile:fileName];
        }
        
        if (!self.image)
        {
            if (defaultImage)
            {
                self.image = defaultImage;
            }
            
            [[DownLoadManager shareInstance] loadImage:imageName forUIImageView:self withBlock:nil];
        }
    }
}

- (void)loadImageName:(NSString *)imageName withBlock:(void(^)(void))completeBlock
{
    self.image = [UIImage imageNamed:imageName];
    if (!self.image)
    {
        NSString *path = CacheFilePath();
        NSString *fileName = [NSFileManager pathForItemNamed:imageName inFolder:path];
        
        if (fileName)
        {
            self.image = [UIImage imageWithContentsOfFile:fileName];
            if (completeBlock)
            {
                completeBlock();
            }
        }
        else
        {
            [[DownLoadManager shareInstance] loadImage:imageName forUIImageView:self withBlock:^{
                completeBlock();
            }];
        }
    }
    else
    {
        if (completeBlock)
        {
            completeBlock();
        }
    }
}

@end
