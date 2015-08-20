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

@end

@implementation DownLoadItem

- (void)appendUIImageViewObserver:(UIImageView *)imageView
{
    if (!self.observerList)
    {
        self.observerList = [[NSMutableArray alloc] init];
    }
    
    [self.observerList addObject:imageView];
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
        
    }];
}

- (void)notifyAll
{
    for (int i = 0; i < self.observerList.count; i++)
    {
        UIImageView *imageView = (UIImageView *)[self.observerList objectAtIndex:i];
        imageView.image = [UIImage imageNamed:self.localFileName];
    }
    
    if (self.manager)
    {
        [self.manager loadFinished:self];
    }
}

@end
