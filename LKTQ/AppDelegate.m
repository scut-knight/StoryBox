//
//  AppDelegate.m
//  LKTQ
//
//  Created by mac on 13-12-2.
//  Copyright (c) 2013年 sony. All rights reserved.
// modify tianqi  2014.4.27

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"



@implementation AppDelegate
@synthesize rootViewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [ShareSDK registerApp:@"e31df19f9d3"];
   
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:@"wx5535ac4b5be2d969"        //此参数为申请的微信AppID
                           wechatCls:[WXApi class]];//valide
    
    [WXApi isWXAppSupportApi];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"2105656920"
                               appSecret:@"a940f51ab7013609eee24723977681d4"
                             redirectUri:@"http://www.sharesdk.cn"];//valide
    
//    //添加腾讯微博应用
//    [ShareSDK connectTencentWeiboWithAppKey:@"801452578"
//                                  appSecret:@"6a12209c8e2e58ba8e87afb922379ee1"
//                             redirectUri:@"http://www.sharesdk.cn"];//valide
//    //添加QQ空间应用
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
//    
//    //添加人人网应用
//    [ShareSDK connectRenRenWithAppKey:@"70bdacb3be084b18ad3a523f9a8bc3b6"
//                            appSecret:@"2b0365dc3da24a678d2e398acaac9b0c"];//valide
//    
//    //添加豆瓣应用
//    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
//                            appSecret:@"e32896161e72be91"
//            redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
     self.rootViewController=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:Nil];
    
    
    self.window.rootViewController=rootViewController;
    [self.window addSubview:rootViewController.view];
//    [rootViewController clickPhotoPickup:nil];//相册打开
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
