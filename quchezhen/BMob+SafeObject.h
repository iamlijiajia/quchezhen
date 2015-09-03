//
//  BMob+SafeObject.h
//  quchezhen
//
//  Created by lijiajia on 15/8/26.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <BmobSDK/Bmob.h>

@interface BmobObject (SafeObject)

- (void)setSafeObject:(id)obj forKey:(NSString *)aKey;

@end
