//
//  BaseModelObject.h
//  RunTime
//
//  Created by 邱成西 on 15/9/17.
//  Copyright (c) 2015年 邱成西. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModelObject : NSObject

//便利构造器
+ (instancetype)modelWithDictionary: (NSDictionary *) data;

//实体类的初始化方法
- (instancetype)initWithDictionary: (NSDictionary *) data;

-(NSDictionary *) propertyMapDic;
@end
