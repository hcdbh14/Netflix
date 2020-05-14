#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *category;

@end

NS_ASSUME_NONNULL_END
