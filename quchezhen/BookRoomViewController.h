//
//  BookRoomViewController.h
//  quchezhen
//
//  Created by lijiajia on 15/7/10.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookRoomViewCell.h"

@interface BookRoomViewController : UIViewController<BookRoomViewCellDelegate>

@property (nonatomic, strong) NSString *beginDateString;//出发日期
@property (nonatomic, strong) NSDate *beginDate;//出发日期

@property (strong, nonatomic) NSDictionary *detailrouteDic;

@end
