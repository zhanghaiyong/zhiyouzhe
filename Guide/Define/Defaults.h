//
//  Defaults.h
//  有车生活
//
//  Created by ksm on 15/11/2.
//  Copyright © 2015年 ksm. All rights reserved.
//

#ifndef Defaults_h
#define Defaults_h


#endif /* Defaults_h */

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//边距
#define BORDER_VALUE 10

//圆角
#define CORNER_RADIUS 6


//#define RGBC(r,g,b)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

#define MainColor        RGB(255, 206, 45)
#define DeepMainColor    RGB(248, 195, 49)
#define backgroudColor   RGB(240, 240, 240)
#define lever1Color      RGB(74, 74, 74)
#define lever2Color      RGB(166, 166, 166)
#define lever3Color      RGB(212, 212, 212)
#define specialRed       RGB(255, 100, 136)
#define specialGreed     RGB(47, 176, 130)

#define lever1Font         [UIFont systemFontOfSize:17]
#define lever2Font         [UIFont systemFontOfSize:14]
#define lever3Font         [UIFont systemFontOfSize:12]
#define lever4Font         [UIFont systemFontOfSize:10]

#define DELAY 2

#define Account (@"account")
#define Cost (@"Cost")
#define GETCOSTTIME (@"getCostTime")

#define REFRESH_SYSTEM  (@"refreshSystem")
#define REFRESH_ORDER   (@"refreshOrder")
#define REFRESH_APPOINT (@"refreshAppoint")



//shareSDK APIKey
const static NSString *SMSKey = @"1229a77693d00";
const static NSString *SMSecret = @"766c6e4c400fe5e1649f64ed232ac5a9";


#if (DEBUG || TESTCASE)
#define FxLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define FxLog(format, ...)
#endif

// 日志输出宏
#define BASE_LOG(cls,sel) FxLog(@"%@-%@",NSStringFromClass(cls), NSStringFromSelector(sel))
#define BASE_ERROR_LOG(cls,sel,error) FxLog(@"ERROR:%@-%@-%@",NSStringFromClass(cls), NSStringFromSelector(sel), error)
#define BASE_INFO_LOG(cls,sel,info) FxLog(@"INFO:%@-%@-%@",NSStringFromClass(cls), NSStringFromSelector(sel), info)

// 日志输出函数
#if (DEBUG || TESTCASE)
#define BASE_LOG_FUN()         BASE_LOG([self class], _cmd)
//BASE_ERROR_FUN([error localizedDescription]);
#define BASE_ERROR_FUN(error)  BASE_ERROR_LOG([self class],_cmd,error)
//BASE_INFO_FUN(@"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信");
#define BASE_INFO_FUN(info)    BASE_INFO_LOG([self class],_cmd,info)
#else
#define BASE_LOG_FUN()
#define BASE_ERROR_FUN(error)
#define BASE_INFO_FUN(info)
#endif

#define kAppDelegate   ((AppDelegate *)[[UIApplication sharedApplication] delegate])


//#define DEBUG_MODE 1
//#if DEBUG_MODE
//#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define DLog( s, ... )
//#endif

