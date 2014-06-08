//
//  TypeDevice.m
//  故事盒子
//
//  Created by mac on 14-1-10.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "TypeDevice.h"

@implementation TypeDevice

+(NSString *)detectDevice
{
    
    NSString * str1=[[UIDevice currentDevice] systemVersion];
    NSString * str2=[[UIDevice currentDevice] systemName];
    NSString * str3 =[[UIDevice currentDevice] name];
    NSLog(@"当前设备:系统版本:%@,系统名称：%@,,名称%@",str1,str2,str3);
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    //使用系统函数sysctlbyname 来获取设备名称
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    NSLog(@"platform=%@",platform);
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone4";
    else if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone4";
    else if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone4";
    else if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone4";//4
    else if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    else if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    else if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone4";
    else if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    else if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    
    else if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch";
    else if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch";
    else if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch";
    else if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch";
    else if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch";
    
    else if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad1,2"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad2,1"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad2,2"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad2,3"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad2,4"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad2,5"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    else if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    else if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    else if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    else if ([platform isEqualToString:@"i386"])         return @"Simulator";
    else if ([platform isEqualToString:@"x86_64"])       return @"x86_64";//Simulator
    else return @"iPhone5s";
    //    return platform;
    
    
}

/**
 *  类方法，返回设备类型
 *
 *  @return 设备类型
 */
+(NSString *)returnTypeName
{
    NSString * str=[self detectDevice];
    if ([str isEqualToString:@"iPhone4"])
    {
        return @"Type4";
    }
    else if ([str isEqualToString:@"iPhone5"]||[str isEqualToString:@"iPod Touch"]||[str isEqualToString:@"x86_64"]||[str isEqualToString:@"iPhone5s"])
    {
        return @"Type5";
    }
    else//ipad
    {
        return @"ipad";
        
    }
    
}
@end
