//
//  OrderMessageConfirmViewController.h
//  quchezhen
//
//  Created by lijiajia on 15/7/30.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomOrdersDataModel.h"

@interface OrderMessageConfirmViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>

- (id)initWithDataModel:(RoomOrdersDataModel *)model;
- (id)initToCheckOrderListWithRouteObject:(BmobObject *)routeObject;
- (id)initWithOrderList:(NSArray *)orderlist;

@end
