/**
 * 新增分类列表
 * @author 郑业强 2018-12-21 创建文件
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACAModel : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger section_id;
@property (nonatomic, strong) NSString *icon_n;
@property (nonatomic, strong) NSString *icon_l;
@property (nonatomic, strong) NSString *icon_s;

@end


@interface ACAListModel : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<ACAModel *> *list;

@end


NS_ASSUME_NONNULL_END
