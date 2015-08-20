//
//  PayMethodViewController.h
//  quchezhen
//
//  Created by lijiajia on 15/7/31.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomOrdersDataModel.h"

@interface PayMethodViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>

- (id)initWithDataModel:(RoomOrdersDataModel *)dataModel;

@end
