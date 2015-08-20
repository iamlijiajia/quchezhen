//
//  HomeViewItemDataModel.m
//  quchezhen
//
//  Created by lijiajia on 15/8/19.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "HomeViewItemDataModel.h"
#import <BmobSDK/BmobProFile.h>

@interface HomeViewItemDataModel ()

@property (nonatomic , strong) UIImageView *imageGetter;
@property (nonatomic) BOOL getterIsWaiting;

@end

@implementation HomeViewItemDataModel

- (void)setImageNameForDownLoad:(NSString *)imageNameForDownLoad
{
    __block HomeViewItemDataModel *_blockSelf = self;
    
    [BmobProFile downloadFileWithFilename:imageNameForDownLoad block:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
        self.image = [UIImage imageNamed:filepath];
        
        if (_blockSelf.getterIsWaiting && _blockSelf.imageGetter)
        {
            _imageGetter.image = self.image;
        }
        
        self.imageGetter = nil;
        self.getterIsWaiting = NO;
    } progress:nil];
}

- (void)getImageMaybeAsynch:(UIImageView *)getter
{
    if (self.image)
    {
        getter.image = self.image;
    }
    else
    {
        self.imageGetter = getter;
        self.getterIsWaiting = YES;
    }
}

@end
