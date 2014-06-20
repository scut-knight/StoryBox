//
//  SBWeatherSelectViewController.h
//  StoryBox
//
//  Created by bin on 14-6-17.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import <CoreLocation/CoreLocation.h>
#import "ExtraLayerView.h"

@interface SBWeatherSelectViewController : UIViewController <HiddenTopViewDelegate>
{
    UIView * NavigationView;
//    UIScrollView *_sc;
    UIScrollView * scView;  //父视图
    NSMutableArray *textEditViewArray;  //保存标注编辑层view数组

    
    CLLocationManager *_currentLoaction;
    NSString * _country;
    NSString * _province;
    NSString * _city;
    NSString *_cityCode;
    NSString *_weather;
    NSString *_temperature;
    
    int selectType;

}

@property(retain,nonatomic) id<HiddenTopViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *LocationActivityIndictor;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *WeatherActivityIndictor;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *TempActivityIndictor;
@property (retain, nonatomic) IBOutlet UILabel *LocationLabel;
@property (retain, nonatomic) IBOutlet UILabel *WeatherLabel;
@property (retain, nonatomic) IBOutlet UILabel *TempLabel;
- (IBAction)addButtonPressed:(UIButton *)sender;
- (void)setParentView:(UIScrollView *)scrollView withTextArr:(NSMutableArray *)arr;
- (IBAction)selectTypeChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@end
