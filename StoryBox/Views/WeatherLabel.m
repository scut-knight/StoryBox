//
//  WeatherLabel.m
//  故事盒子
//
//  Created by bin on 14-6-12.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "WeatherLabel.h"

@implementation WeatherLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _currentLoaction = [[CLLocationManager alloc] init];
        _currentLoaction.delegate = self;
        [_currentLoaction startUpdatingLocation];
    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Error:%@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_currentLoaction stopUpdatingLocation];
    
    NSString *latitude = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@  Lng: %@", latitude, longitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error)
    {
//        NSLog(@"%@",error);
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            _country = placemark.ISOcountryCode;
            _province = placemark.administrativeArea;
            _city = placemark.locality;
            
            NSLog(@"country:%@,province:%@,city:%@",_country,_province,_city);
            [self getWeather];

        }
    }];

}


- (void)getWeather
{
    //查询城市代号
    NSError *error;
    NSString *path = [[NSBundle mainBundle]  pathForResource:@"cityCode" ofType:@"json"];
//    NSLog(@"path:%@",path);
    NSData *jdata = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *jdataDic = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableLeaves error:&error];
    NSArray *cityDict = [jdataDic objectForKey:_province];
    for(NSDictionary *city in cityDict)
    {
        if([[city objectForKey:@"市名"] isEqualToString:_city])
        {
            _cityCode = [city objectForKey:@"编码"];
            NSLog(@"%@",_cityCode);
            break;
        }
        
    }

    
    //获取当前城市的天气信息
    NSString * url = [NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/%@.html",_cityCode];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];

    NSLog(@"温度:%@ - %@",[weatherInfo objectForKey:@"temp1"],[weatherInfo objectForKey:@"temp2"]);
    NSLog(@"天气:%@",[weatherInfo objectForKey:@"weather"]);

}

@end
