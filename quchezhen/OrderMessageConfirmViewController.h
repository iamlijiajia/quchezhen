//
//  OrderMessageConfirmViewController.h
//  quchezhen
//
//  Created by lijiajia on 15/7/30.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomOrderCellModel.h"

@interface OrderMessageConfirmViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>

@property (strong , nonatomic) NSMutableArray *orderModelArray;

@end
