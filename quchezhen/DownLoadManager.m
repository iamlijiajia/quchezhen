//
//  DownLoadManager.m
//  quchezhen
//
//  Created by lijiajia on 15/8/19.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "DownLoadManager.h"
#import "DownLoadItem.h"

@interface DownLoadManager ()

@property (nonatomic , strong) NSMutableArray *downloadFileNameList;
@property (nonatomic , strong) NSMutableArray *downloadItemList;

@end

@implementation DownLoadManager

+ (DownLoadManager *) shareInstance
{
    static DownLoadManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.downloadFileNameList = [[NSMutableArray alloc] init];
        self.downloadItemList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) loadImage:(NSString *)fileName forUIImageView:(UIImageView *)imageView
{
    NSInteger index = [self.downloadFileNameList indexOfObject:fileName];
    if (index >= 0 && index < self.downloadFileNameList.count)
    {
        DownLoadItem *item = [self.downloadItemList objectAtIndex:index];
        [item appendUIImageViewObserver:imageView];
    }
    else
    {
        DownLoadItem *item = [[DownLoadItem alloc] init];
        [self.downloadItemList addObject:item];
        [self.downloadFileNameList addObject:fileName];
        
        item.manager = self;
        [item appendUIImageViewObserver:imageView];
        [item loadImage:fileName];
    }
}

- (void)loadFinished:(DownLoadItem *)item
{
    [self.downloadItemList removeObject:item];
}

@end
