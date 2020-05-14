#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

- (void)request: (NSString *)method andURL: (NSString *)url completion:(void (^)(NSData *data, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
