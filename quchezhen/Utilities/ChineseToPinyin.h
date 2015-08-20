//
//  ChineseToPinyin.h
//  LianPu
//
//  Created by shawnlee on 10-12-16.
//  Modified  by Stephen Liu on 11-10-25
//  Copyright 2010 lianpu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 返回汉字的首字母
 */
char pinyinFirstLetter(unsigned short hanzi);

/**
 判断是否为大写字母(首先判断是否是英文字母)
 */
BOOL isCapitalLetter(char letter);

/**
 判断是否为小写字母(首先判断是否是英文字母)
 */
BOOL isLowercaseLetter(char letter);

/**
 判断是否是英文字母
 */
BOOL isLetter(char letter);

/**
 把字母转换为大写
 */
void capitalLetter(char *letter);


NSString* FindLetter(int nCode);


/**
 提供汉字到拼音的转换和一些辅助功能，可以用于排序和查找等用途
 */
@interface ChineseToPinyin : NSObject {

}
/**
 把所给字符串中包含的汉字转换为对应拼音返回
 */
+ (NSString *) pinyinFromChiniseString:(NSString *)string;

/**
 方便tableview导航排序
 */
+ (char) sortSectionTitle:(NSString *)string; 
@end
