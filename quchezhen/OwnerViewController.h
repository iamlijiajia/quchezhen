//
//  OwnerViewController.h
//  quchezhen
//
//  Created by lijiajia on 15/7/10.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SegmentType)
{
    likesRoute  =0,
    orderList   =1
};

@interface OwnerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) SegmentType segmentType;

@end
