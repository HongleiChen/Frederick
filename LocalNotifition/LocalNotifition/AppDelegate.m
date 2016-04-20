//
//  AppDelegate.m
//  LocalNotifition
//
//  Created by FredChen on 16/3/22.
//  Copyright © 2016年 FrederickChen. All rights reserved.
//

#import "AppDelegate.h"
#import "KCMainViewController.h"

#define iPhoneSoftVersion ([[UIDevice currentDevice].systemVersion floatValue])

@interface AppDelegate ()
@end
@implementation AppDelegate
#pragma mark - 应用代理方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _window.backgroundColor =[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    
    //设置全局导航条风格和颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:23/255.0 green:180/255.0 blue:237/255.0 alpha:1]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    KCMainViewController *mainController=[[KCMainViewController alloc]init];
    _window.rootViewController=mainController;
    
    [_window makeKeyAndVisible];
    
    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
    if (iPhoneSoftVersion >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            [self addLocalNotification];
        }else{
            [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
        }
        
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (UIRemoteNotificationTypeNone != type) {
            [self addLocalNotification];
        } else {
            [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
            
        }

    }
//    //添加通知
//    [self addLocalNotification];
//    //接收通知参数
//    UILocalNotification *notification=[launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    NSDictionary *userInfo= notification.userInfo;
//    
//    [userInfo writeToFile:@"/Users/kenshincui/Desktop/didFinishLaunchingWithOptions.txt" atomically:YES];
//    NSLog(@"didFinishLaunchingWithOptions:The userInfo is %@.",userInfo);
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"=--=-==--==-=-%@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"==============%@", error);
}
#pragma mark 接收本地通知时触发
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    NSDictionary *userInfo=notification.userInfo;
//    [userInfo writeToFile:@"/Users/kenshincui/Desktop/didReceiveLocalNotification.txt" atomically:YES];
//    NSLog(@"didReceiveLocalNotification:The userInfo is %@",userInfo);
//}


#pragma mark 调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (iPhoneSoftVersion >= 8.0f) {
        if (notificationSettings.types!=UIUserNotificationTypeNone) {
            [self addLocalNotification];
        }
    }
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"_____________________userInfo : %@", userInfo);
}

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
{
    NSLog(@"------------------------");
    if (iPhoneSoftVersion < 8.0f) {
        if (types!=UIRemoteNotificationTypeNone) {
            [self addLocalNotification];
        }
    }
    
}

#pragma mark 进入前台后设置消息信息
-(void)applicationWillEnterForeground:(UIApplication *)application{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}
#pragma mark - 私有方法
#pragma mark 添加本地通知
-(void)addLocalNotification{
    
    //定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10.0];//通知触发的时间，10s以后
    notification.repeatInterval=2;//通知重复次数
    //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    
    //设置通知属性
    notification.alertBody=@"最近添加了诸多有趣的特性，是否立即体验？"; //通知主体
    notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    
    //设置用户信息
    notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他附加信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark 移除本地通知，在不需要此通知时记得移除
-(void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end
