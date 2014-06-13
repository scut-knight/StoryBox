#import <UIKit/UIKit.h>

/**
 *  协议，用于更新当前选择的图片
 */
@protocol UpdateCurrentImageDelegate <NSObject>
@optional
-(void)UpdateCurrentImage:(UIImage*)img;

@end

/**
 *  裁剪图片界面控制器
 */
@interface ClipViewController: UIViewController<UpdateCurrentImageDelegate>

+(ClipViewController *)sharedInstance;
-(void)initWith:(UIImage*)img with:(UIView *)VC withDelegate:(id)parent;
@end
