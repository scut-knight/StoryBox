//
//  SBWeatherSelectViewController.m
//  StoryBox
//
//  Created by bin on 14-6-17.
//  Copyright (c) 2014年 scutknight. All rights reserved.
//

#import "SBWeatherSelectViewController.h"
#import "WeatherLabel.h"

@interface SBWeatherSelectViewController ()

@end

@implementation SBWeatherSelectViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)setParentView:(UIScrollView *)scrollView withTextArr:(NSMutableArray *)arr;
{
    scView = scrollView;
    textEditViewArray = arr;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _currentLoaction = [[CLLocationManager alloc] init];
    _currentLoaction.delegate = self;
    
    [self initNavigationBar];
    self.LocationActivityIndictor.hidesWhenStopped = YES;
    self.WeatherActivityIndictor.hidesWhenStopped = YES;
    self.TempActivityIndictor.hidesWhenStopped = YES;
    [self.LocationActivityIndictor startAnimating];
    [self.WeatherActivityIndictor startAnimating];
    [self.TempActivityIndictor startAnimating];

}

- (void)viewDidAppear:(BOOL)animated
{
    #if TARGET_IPHONE_SIMULATOR
    
    _province = @"广东省";
    _city = @"广州市";
    [self.LocationActivityIndictor stopAnimating];
    self.LocationLabel.text = _city;
    [self getWeather];
    
    #else
    
    [_currentLoaction startUpdatingLocation];
    
    #endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  导航条布局
 */
-(void)initNavigationBar
{
    NavigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    [NavigationView setBackgroundColor:[UIColor colorWithRed:(28.0/255) green:(33.0/255) blue:39.0/255 alpha:0.95]];
    [self.view addSubview:NavigationView];
    [NavigationView release];
    
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(20, 15, 40,15)];
    [back setImage:[UIImage imageNamed:@"titleBackBtn.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:back];
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
             //设置位置
             [self.LocationActivityIndictor stopAnimating];
             self.LocationLabel.text = _city;
             
             [self getWeather];
         }
     }];
    
}


- (void)getWeather
{
//    //查询城市代号
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
    
    _weather = [weatherInfo objectForKey:@"weather"];
    _temperature = [NSString stringWithFormat:@"%@ - %@",[weatherInfo objectForKey:@"temp2"],[weatherInfo objectForKey:@"temp1"]];

    NSLog(@"温度:%@",_temperature);
    NSLog(@"天气:%@",_weather);
    
    [self.TempActivityIndictor stopAnimating];
    [self.WeatherActivityIndictor stopAnimating];
    self.TempLabel.text = _temperature;
    self.WeatherLabel.text = _weather;
    
    
}

-(void)backEdit:(id)sender
{
    [self.delegate hiddenTopView:NO];
    [self.view removeFromSuperview];
}

- (void)dealloc
{
    [_LocationActivityIndictor release];
    [_WeatherActivityIndictor release];
    [_TempActivityIndictor release];
    [_LocationLabel release];
    [_WeatherLabel release];
    [_TempLabel release];
    [super dealloc];
}

- (IBAction)addButtonPressed:(UIButton *)sender
{
    WeatherLabel *label = [[WeatherLabel alloc] initWithFrame:CGRectMake(100, scView.contentOffset.y+100, 400, 200) withView:scView withTextVArr:textEditViewArray];

    [label initWeather:_city withWeather:_weather withTemp:_temperature];
    
    [self.delegate hiddenTopView:NO];
    [scView addSubview:label];
    [self.view removeFromSuperview];

}
@end
