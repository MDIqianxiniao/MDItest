//
//  MDIFMDBManager.h
//  testDemo
//
//  Created by 马迪 on 2021/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDIFMDBManager : NSObject


+ (instancetype)shareInstance;


/**
 *  向表中插入一条数据
 */
- (BOOL)insertObjectToDatabaseWithObjct:(id)object;

/**
 *  根据一条数据的某个属性删除某表中的这条数据（对象）
 *
 *  @param object   对象
 *  @param propertyName 属性名
 *  @param propertyData 属性值
 *
 *  @return 是否成功
 */
- (BOOL)deleteObjectFrameDatabase:(id)object whitProperty:(NSString *)propertyName data:(NSString *)propertyData;
/**
 *  删除指定表的所有数据
 */
- (BOOL)deleteAllObjectsFromDatabaseWithClass:(Class)className;

@end

NS_ASSUME_NONNULL_END
