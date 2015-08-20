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

#import "DownLoadManager.h"

@implementation UIImageView(BmobDownLoad)

- (id)initWithDefaultImage:(UIImage *)defaultImage NewImageName:(NSString *)imageName andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self resetWithDefaultImage:defaultImage NewImageName:imageName andFrame:frame];
    }
    
    return self;
}

- (id)initWithDefaultImageName:(NSString *)defaultImageName NewImageName:(NSString *)imageName andFrame:(CGRect)frame
{
    UIImage *image = defaultImageName == nil ? nil : [UIImage imageNamed:defaultImageName];
    
    self = [self initWithDefaultImage:image NewImageName:imageName andFrame:frame];
    return self;
}

- (void)resetWithDefaultImage:(UIImage *)defaultImage NewImageName:(NSString *)imageName andFrame:(CGRect)frame
{
    self.image = [UIImage imageNamed:imageName];
    if (!self.image)
    {
        if (defaultImage)
            {
                self.image = defaultImage;
            }
        
//        [BmobProFile downloadFileWithFilename:imageName block:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
//            if (isSuccessful)
//            {
//                self.image = [UIImage imageNamed:filepath];
//            }
//            else
//            {
//                
//            }
//        } progress:^(CGFloat progress) {
//            
//        }];
        
        
        [[DownLoadManager shareInstance] loadImage:imageName forUIImageView:self];
    }
}

@end
