//
//  UIDevice+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 和设备唯一性相关的辅助方法
 */
@interface UIDevice (Helpers)
/**
 判断是否是Retin屏幕
 */
- (BOOL)isRetinaDisplay;

/**
 判断是否是IPhone5
 */
- (BOOL)is4InchRetinaDisplay;

/**
 判断是否支持多任务
 */
- (BOOL)checkMultitaskingSupported;

/**
 返回当前语言（目前实现不是= =；）
 etc:zh_CN zh_HK en_US
 */
- (NSString *)language;

/**
 运营商名称
 */
- (NSString *)carrierName;

/**
 运营商国家
 */
- (NSString *)mobileCountryCode;

/**
 运营商代码
 */
- (NSString *)mobileNetworkCode;

/**
 mac地址
 */
- (NSString *)macAddress;

/**
 能否打电话
 */
- (BOOL)canMakeCall;

/**
 能否发信息
 */
- (BOOL)canSendText;

/**
 平台
 */
- (NSString *)platform;

/**
 设备型号
 */
- (NSString *)getReturnPlat:(NSString *)platform;


- (NSString *)getStandardPlat;
@end