//
//  DetailViewController.h
//  quchezhen
//
//  Created by lijiajia on 15/6/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIScrollViewDelegate>

- (id)initWithDictionary:(NSDictionary *)routeDic;

@property (strong, nonatomic) NSDictionary *detailrouteDic;


@end

