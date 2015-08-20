//
//  HomeViewItemDataModel.h
//  quchezhen
//
//  Created by lijiajia on 15/8/19.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomeViewItemDataModel : NSObject

@property (nonatomic , strong) NSString *introText;

@property (nonatomic , strong) NSString *imageNameForDownLoad;

@property (nonatomic , strong) UIImage *image;

- (void)getImageMaybeAsynch:(UIImageView *)getter;

@end
