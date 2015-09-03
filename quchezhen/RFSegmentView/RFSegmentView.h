//
//  RFSegmentView.h
//  RFSegmentView
//
//  Created by 王若风 on 1/15/15.
//  Copyright (c) 2015 王若风. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RFSegmentViewDelegate <NSObject>
- (void)segmentViewSelectIndex:(NSInteger)index;
@end

@interface RFSegmentView : UIView
/**
 *  设置风格颜色 默认蓝色风格
 */
@property(nonatomic ,strong) UIColor *tintColor;
@property(nonatomic) id<RFSegmentViewDelegate> delegate;
@property (nonatomic) NSInteger currentIndex;

/**
 *  默认构造函数
 *
 *  @param frame frame
 *  @param items title字符串数组
 *
 *  @return 当前实例
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
