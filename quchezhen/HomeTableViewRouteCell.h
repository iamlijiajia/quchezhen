//
//  HomeTableViewRouteCell.h
//  quchezhen
//
//  Created by lijiajia on 15/8/24.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>

@interface HomeTableViewRouteCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)configureCellwithRouteObject:(BmobObject *)route;

@end
