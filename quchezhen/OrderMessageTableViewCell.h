//
//  OrderMessageTableViewCell.h
//  quchezhen
//
//  Created by lijiajia on 15/8/31.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookRoomViewCellDataModel.h"

@interface OrderMessageTableViewCell : UITableViewCell

- (void)configureCellDataModel:(BookRoomViewCellDataModel *)model andWidth:(CGFloat)width;

- (void)configureCellWithOrderItems:(NSArray *)orderItems andWidth:(CGFloat)width;
@end
