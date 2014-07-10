//
//  SBViewerView.h
//  StoryBox
//
//  Created by bin on 14-7-10.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickupViewController.h"

@interface SBViewerView : UIView
{
    UIScrollView *imageScrollView;     //滚动界面
    UIImageView *imageView;
    UIView * NavigationView;
    float viewHeight;

}

@property(retain,nonatomic) id<HiddenTopViewDelegate>delegate;

-(id)initWithImage:(UIImage *) image withImageURL:(NSURL *)imageURL;

@end
