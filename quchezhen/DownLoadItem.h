//
//  DownLoadItem.h
//  quchezhen
//
//  Created by lijiajia on 15/8/19.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownLoadManager.h"

@interface DownLoadItem : NSObject

@property (nonatomic) DownLoadManager *manager;

- (void) appendUIImageViewObserver:(UIImageView *)imageView;

- (void) loadImage:(NSString *)fileName;

@end
