#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *movieYear;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *movieCategory;

@end

NS_ASSUME_NONNULL_END
