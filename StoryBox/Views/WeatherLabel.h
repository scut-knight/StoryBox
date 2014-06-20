//
//  WeatherLabel.h
//  故事盒子
//
//  Created by bin on 14-6-12.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherLabel : UIView<UIAlertViewDelegate>
{
//    CLLocationManager *_currentLoaction;
//    NSString * _country;
//    NSString * _province;
//    NSString * _city;
//    NSString *_cityCode;
//    UIView *WeatherView;
//    UIView * imageViewBg;
    
    UIImageView * imageViewBg;
    UIScrollView * scView;  //父视图
    NSMutableArray *textEditViewArray;  //保存标注编辑层view数组


    UIButton * deleteBTn;
    
    int iconType;


    
}

@property(retain,nonatomic) UITextView * _textView;
@property(retain,nonatomic) UIImageView * imageViewBg;
@property(retain,nonatomic) UILabel * cityLabel;
@property(retain,nonatomic) UILabel * tempLabel;


//- (void)getWeather;

- (id)initWithFrame:(CGRect)frame withView:(UIScrollView *)sc withTextVArr:textVA iconType:(int)type;
- (id)initPreview:(CGRect)frame iconType:(int)type;
- (void)initWeather:(NSString *)city withWeather:(NSString *)weather withTemp:(NSString *)temp;
@end
