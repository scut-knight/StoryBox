
#import <UIKit/UIKit.h>
@protocol UpdateCurrentImageDelegate <NSObject>
@optional
-(void)UpdateCurrentImage:(UIImage*)img;

@end

@interface ClipViewController: UIViewController<UpdateCurrentImageDelegate>

-(void)initWith:(UIImage*)img with:(UIView *)VC withDelegate:(id)parent;
@end
