//
//  main.m
//  runtime02
//
//  Created by 邱成西 on 15/9/17.
//  Copyright (c) 2015年 邱成西. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeautifulGirlModel.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:11];
        
        //创建测试适用的字典
        for(int i = 0; i <= 10; i ++){
            NSString *key = [NSString stringWithFormat:@"girl%d", i];
            
            NSString *value = [NSString stringWithFormat:@"我是第%d个女孩", i];
            
            [data setObject:value forKey:key];
        }
        
        
        
        BeautifulGirlModel *model = [BeautifulGirlModel modelWithDictionary:data];
        NSLog(@"girl 10 = %@",model.girl100);
    }
    return 0;
}
