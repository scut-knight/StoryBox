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
    
    NSLog(@"locError:%@", error);
    
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
        NSLog(@"%@",error);

        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            _country = placemark.ISOcountryCode;
            _city = placemark.locality;
            
            NSLog(@"country:%@,city:%@",_country,_city);

        }
    }];

}


- (void)getLocation
{
//    NSLog(@"country:%@,city:%@",_country,_city);

}

@end
