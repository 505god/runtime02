//
//  BaseModelObject.m
//  RunTime
//
//  Created by 邱成西 on 15/9/17.
//  Copyright (c) 2015年 邱成西. All rights reserved.
//

#import "BaseModelObject.h"
#import <objc/runtime.h>

@implementation BaseModelObject

+ (instancetype)modelWithDictionary: (NSDictionary *) data{
    return [[self alloc] initWithDictionary:data];
}

- (instancetype)initWithDictionary: (NSDictionary *) data{
    {
        self = [super init];
        if (self) {
            if ([self propertyMapDic] == nil) {
                [self assginToPropertyWithDictionary:data];
            } else {
                [self assginToPropertyWithNoMapDictionary:data];
            }
        }
        return self;
    }
}

///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

#pragma mark -  返回属性和字典key的映射关系
-(NSDictionary *) propertyMapDic{
    return @{};
}


#pragma 根据映射关系来给Model的属性赋值
-(void) assginToPropertyWithNoMapDictionary: (NSDictionary *) data{
    ///获取字典和Model属性的映射关系
    NSDictionary *propertyMapDic = [self propertyMapDic];
    
    ///转化成key和property一样的字典，然后调用assginToPropertyWithDictionary方法
    
    NSArray *dicKey = [data allKeys];
    
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:dicKey.count];
    
    for (int i = 0; i < dicKey.count; i ++) {
        NSString *key = dicKey[i];
        [tempDic setObject:data[key] forKey:propertyMapDic[key]];
    }
    
    [self assginToPropertyWithDictionary:tempDic];
    
}


#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回

- (SEL) creatSetterWithPropertyName: (NSString *) propertyName{
    
    //1.首字母大写
    propertyName = propertyName.capitalizedString;
    
    //2.拼接上set关键字
    propertyName = [NSString stringWithFormat:@"set%@:", propertyName];
    
    //3.返回set方法
    return NSSelectorFromString(propertyName);
}

#pragma mark -- 把字典赋值给当前实体类的属性

-(void) assginToPropertyWithDictionary: (NSDictionary *) data{
    
    if (data == nil) {
        return;
    }
    
    ///1.获取字典的key
    NSArray *dicKey = [data allKeys];
    
    ///2.循环遍历字典key, 并且动态生成实体类的setter方法，把字典的Value通过setter方法
    ///赋值给实体类的属性
    for (int i = 0; i < dicKey.count; i ++) {
        
        ///2.1 通过getSetterSelWithAttibuteName 方法来获取实体类的set方法
        SEL setSel = [self creatSetterWithPropertyName:dicKey[i]];
        
        if ([self respondsToSelector:setSel]) {
            ///2.2 获取字典中key对应的value
            NSString  *value = [NSString stringWithFormat:@"%@", data[dicKey[i]]];
            
            ///2.3 把值通过setter方法赋值给实体类的属性
            [self performSelectorOnMainThread:setSel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
        
    }
    
}

@end
