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

@interface WeatherLabel : UIView
{
    CLLocationManager *_currentLoaction;
    NSString * _country;
    NSString * _province;
    NSString * _city;
    NSString *_cityCode;
    
}

-(void)getWeather;


@end
