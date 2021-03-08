//
//  MDIFMDBManager.m
//  testDemo
//
//  Created by 马迪 on 2021/2/23.
//

#import "MDIFMDBManager.h"
#import <objc/runtime.h>
#import "ViewController.h"

@interface MDIFMDBManager ()

@property(nonatomic,strong) FMDatabase *dataBase;


@end

@implementation MDIFMDBManager

+ (instancetype)shareInstance
{
    static MDIFMDBManager *dataManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[MDIFMDBManager alloc]init];
    });
    return dataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        self.dataBase = [FMDatabase databaseWithPath:dataPath];
    }
    return self;
}

///根据对象创建表
- (BOOL)creatTableWithObject:(id)object
{
    NSString *tbName = NSStringFromClass([object class]);
    
    //SQL语句
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"creat table if not exist %@(id integer primary key autoincrement",tbName];
    
    NSArray *properts = [self propertiesFromClass:[object class]];
    for (NSString *string in properts)
    {
        [sqlString appendFormat:@"%@ text",string];
    }
    
    [sqlString appendString:@")"];
    // 执行SQL语句
    BOOL isFinish = [_dataBase executeUpdate:sqlString];
    
    return isFinish;
}

/**
 *  向表中插入一条数据
 */
- (BOOL)insertObjectToDatabaseWithObjct:(id)object
{
    // 1.打开数据库
    if (![_dataBase open])
    {
        return NO;
    }
    
    // 2.获得表名
    NSString *tbName = NSStringFromClass([object class]);

    // 3.判断表是否存在,不存在则返回no
    if (![self isExistTableInDatabaseWithTableName:tbName])
    {
        if (![self creatTableWithObject:object])
        {
            return NO;
        }
    }
    
    // 4.拼接SQL语句
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"insert into %@ (",tbName];
    // values
    NSMutableString *valueString = [NSMutableString stringWithFormat:@" values ("];
    
    NSArray *properties = [self propertiesFromClass:[object class]];
    // 遍历属性
    for (int i = 0; i < properties.count; i ++) {
        NSLog(@"properties = %@ objectValue = %@",properties[i],[object valueForKey:properties[i]]);
        
        if (i == properties.count - 1)
        {
            [sqlString appendFormat:@"%@)",properties[i]];
            [valueString appendFormat:@"'%@')",[object valueForKey:properties[i]]];
        }
        else
        {
            [sqlString appendFormat:@"%@,",properties[i]];//属性名
            [valueString appendFormat:@"'%@',",[object valueForKey:properties[i]]];//属性值
        }
    }
    [sqlString appendString:valueString];
    
    // 5.执行SQL语句
    BOOL isFinish = [_dataBase executeUpdate:sqlString];
    
    // 6.关闭数据库
    [_dataBase close];
    
    return isFinish;
}


/**
 *  根据一条数据的某个属性删除某表中的这条数据（对象）
 *
 *  @param object   对象
 *  @param propertyName 属性名
 *  @param propertyData 属性值
 *
 *  @return 是否成功
 */
- (BOOL)deleteObjectFrameDatabase:(id)object whitProperty:(NSString *)propertyName data:(NSString *)propertyData
{
    // 1.打开数据库
    if (![_dataBase open])
    {
        return NO;
    }
    
    // 2.获得表名
    NSString *tbName = NSStringFromClass([object class]);

    // 3.判断表是否存在,不存在则返回no
    if (![self isExistTableInDatabaseWithTableName:tbName])
    {
        return NO;
    }
    
    // 4.更新
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where %@ = %@",tbName,propertyName,propertyData];
    BOOL isFinish = [_dataBase executeUpdate:sqlString];
    
    // 5.关闭数据库
    [_dataBase close];
    return isFinish;
}

/**
 *  删除指定表的所有数据
 */
- (BOOL)deleteAllObjectsFromDatabaseWithClass:(Class)className
{
    if (![_dataBase open])
    {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@",NSStringFromClass(className)];
    // 执行sql
    BOOL isFinish = [_dataBase executeUpdate:sql];
    [_dataBase close];
    return isFinish;
}



/**
 *  判断表是否存在
 */
- (BOOL)isExistTableInDatabaseWithTableName:(NSString *)tablename
{
    // sqlite_master是系统表
    NSString *sql = @"select name from sqlite_master where type='table' and name=?";
    // 查询
    FMResultSet *set = [_dataBase executeQuery:sql,tablename];
    
    // 第一个存在，就存在，无需遍历
    return set.next;
}


/**
 *  返回某个对象的所有属性
 */
- (NSArray *)propertiesFromClass:(Class)clssName{
    // 保存所有属性的名字
    NSMutableArray *array = [NSMutableArray array];
    // 属性个数
    unsigned int outCount;
    // 获取所有的属性（runtime应用）
    objc_property_t *properties = class_copyPropertyList(clssName,&outCount);
    for (int i = 0; i < outCount; i ++) {
        // 每个属性的结构体
        objc_property_t property = properties[i];
        // 获取属性名称
        const char *name = property_getName(property);
        [array addObject:[NSString stringWithUTF8String:name]];
    }
    // 释放资源
    free(properties);
    return array;
}


@end
