//
//  ViewController.m
//  testDemo
//
//  Created by 马迪 on 2021/2/23.
//

#import "ViewController.h"



@interface ViewController ()

@property (nonatomic,copy) NSString *dddd;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    name = @"123";
    
    
    //数组去重
    [self arrayRemoveSameItems];
    
}

//数组去重
- (void)arrayRemoveSameItems
{
    NSArray *array = @[@"12-11", @"12-11", @"12-11", @"12-12", @"12-13", @"12-14"];
    
    //method1：
//    NSArray *resultArray = [self arrayRemoveSameItemsMethod1:array];
    
//    NSArray *resultArray = [self arrayRemoveSameItemsMethod2:array];
    
    NSArray *resultArray = [self arrayRemoveSameItemsMethod3:array];
    
    NSLog(@"去重后的数组：%@",resultArray);
}
//method1：
- (NSArray *)arrayRemoveSameItemsMethod1:(NSArray *)array
{
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array)
    {
        if (![mutArray containsObject:string])
        {
            [mutArray addObject:string];
        }
    }
    return [mutArray copy];
}

//method2：
- (NSArray *)arrayRemoveSameItemsMethod2:(NSArray *)array
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:array.count];
    for (NSString *string in array)
    {
        [dict setValue:string forKey:string];
    }
    return dict.allValues;
}

//method3：
- (NSArray *)arrayRemoveSameItemsMethod3:(NSArray *)array
{
    NSSet *set = [NSSet setWithArray:array];
    return set.allObjects;
}


@end
