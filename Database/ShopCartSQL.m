//
//  ShopCartSQL.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ShopCartSQL.h"
#import "InitSQL.h"
#import <YTKKeyValueStore.h>
#import "ModelProduct.h"
#import <YYModel.h>

NSString *const tableName = @"shopCartList";

@implementation ShopCartSQL


+(void)saveToShopCart:(NSDictionary *)productDic withId:(NSString *)productId
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    [store createTableWithName:tableName];
    
//    NSDate *date=[NSDate date];
//    NSDateFormatter *datefor=[[NSDateFormatter alloc] init];
//    [datefor setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
//    NSString *day=[datefor stringFromDate:date];
    [store putObject:productDic withId:productId intoTable:tableName];
}

+(NSMutableArray *)readShopCart
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    [store createTableWithName:tableName];
    
    NSArray *arr = [store getAllItemsFromTable:tableName];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (YTKKeyValueItem *item in arr) {
//        model.doyenKey = item.itemId;
        NSDictionary *dic = (NSDictionary *)item.itemObject;
//        ModelProduct * modelPro = [ModelProduct yy_modelWithDictionary:dic];
        ModelProduct * modelPro = [[ModelProduct alloc]init];
        modelPro.productId = dic[@"productId"];
        modelPro.code = dic[@"code"];
        modelPro.name = dic[@"name"];
        modelPro.specifications = dic[@"specifications"];
        modelPro.sellingPrice = dic[@"sellingPrice"];
        modelPro.primeImageUrl = dic[@"primeImageUrl"];
        modelPro.qty = dic[@"qty"];
        
        [dataArr addObject:modelPro];
    }
    
    return dataArr;

}

+(id)getObjectById:(NSString *)objectId
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    [store createTableWithName:tableName];
    
   return [store getObjectById:objectId fromTable:tableName];

}

+(void)removeProductById:(NSString *)productId
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    [store createTableWithName:tableName];
    
    [store deleteObjectById:productId fromTable:tableName];
}

+(void)removeAllProInShopCart
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    
    [store clearTable:tableName];
}
@end
