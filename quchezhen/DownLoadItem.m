//
//  DownLoadItem.m
//  quchezhen
//
//  Created by lijiajia on 15/8/19.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "DownLoadItem.h"
#import <BmobSDK/BmobProFile.h>

@interface DownLoadItem ()

@property (nonatomic , strong) NSMutableArray *observerList;
@property (nonatomic , strong) NSString *localFileName;

@property (nonatomic , strong) NSMutableArray *completeBlockList;
@property (nonatomic , strong) NSMutableArray *progressBlockList;

@end

typedef void(^DownLoadItemBlock)(void);

@implementation DownLoadItem

- (void)appendUIImageViewObserver:(UIImageView *)imageView
{
    if (!self.observerList)
    {
        self.observerList = [[NSMutableArray alloc] init];
        self.completeBlockList = [[NSMutableArray alloc] init];
        self.progressBlockList = [[NSMutableArray alloc] init];
    }
    
    [self.observerList addObject:imageView];
}

- (void)appendCompleteBlock:(void(^)(void))completeBlock progressBlock:(void(^)(void))progressBlock
{
    if (completeBlock) {
        [self.completeBlockList addObject:completeBlock];
    }
    
    if (progressBlock) {
        [self.progressBlockList addObject:completeBlock];
    }
}

- (void)loadImage:(NSString *)fileName
{
    __block DownLoadItem *_blockSelf = self;
    [BmobProFile downloadFileWithFilename:fileName block:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
        if (isSuccessful)
        {
            _blockSelf.localFileName = filepath;
            [_blockSelf notifyAll];
        }
        else
        {
            
        }
    } progress:^(CGFloat progress) {
        for (DownLoadItemBlock block in self.progressBlockList)
        {
            block();
        }
    }];
}

- (void)notifyAll
{
    UIImage *img = [UIImage imageWithContentsOfFile:self.localFileName];
    
    for (int i = 0; i < self.observerList.count; i++)
    {
        UIImageView *imageView = (UIImageView *)[self.observerList objectAtIndex:i];
        imageView.image = img;
    }
    
    for (DownLoadItemBlock block in self.completeBlockList)
    {
        block();
    }
    
    if (self.manager)
    {
        [self.manager loadFinished:self];
    }
}

@end
