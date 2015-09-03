//
//  DownLoadManager.h
//  quchezhen
//
//  Created by lijiajia on 15/8/19.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DownLoadItem;

@interface DownLoadManager : NSObject

+ (DownLoadManager *) shareInstance;

- (void) loadImage:(NSString *)fileName forUIImageView:(UIImageView *)imageView withBlock:(void(^)(void))completeBlock;

- (void)loadFinished:(DownLoadItem *)item;

@end
