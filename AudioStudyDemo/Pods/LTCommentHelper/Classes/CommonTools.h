//
//  CommonTool.h
//  qianxiheiOS
//
//  Created by ZSC on 15/6/11.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface CommonTools : NSObject


/**
 获取字符串宽度

 @param textStr <#textStr description#>
 @param font <#fontSize description#>
 @return <#return value description#>
 */
+(CGFloat)getZSCTextWidth:(NSString *)textStr
          andTextFont:(UIFont *)font;



/**
 获取字符串高度

 @param textStr <#textStr description#>
 @param width <#width description#>
 @param font <#fontSize description#>
 @return <#return value description#>
 */
+ (CGFloat)getZSCTextHight:(NSString *)textStr andWidth:(CGFloat)width andTextFont:(UIFont *)font;

/**
 *  不需要遵循代理的警告视图
 *
 *  @param mainTitle      主标题
 *  @param secondaryTitle 次标题
 */
+ (void)showAlertWithMainTitle:(NSString *)mainTitle
             andSecondaryTitle:(NSString *)secondaryTitle;
+ (void)showAlertWithMoreTitle:(NSString *)mainTitle andMessageTitle:(NSString *)messageTitle;

/**
 *  打开
 */
+ (void)openAppaleShopWithAppleID:(NSString *)appleID;

/**
 *  获取时间戳
 *
 *  @return 时间戳
 */
+ (NSInteger)timeSp;

/**
 *  获取时间间隔(时间戳与当前时间间隔,如论坛发帖时间)
 *
 *  @param timeSp 时间戳
 *
 *  @return 时间
 */
+ (NSString *)timeInterval:(NSString *)timeSp;

/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
+ (NSString *)currentTime;


/** 明天 */
+ (NSString *)tomorrowDate;

/**
 *  转换成标准时间
 *  @param numTime 请求获取时间number型
 *  @return 标准时间
 */
+ (NSString *)standardTime:(NSNumber *)numTime;


/**
 时间戳转化为Date

 @param timeSp <#timeSp description#>
 @return <#return value description#>
 */
+ (NSDate *)dateWithTimeSp:(NSInteger)timeSp;

/**
 时间戳转化为时间

 @param time <#time description#>
 @return <#return value description#>
 */
+ (NSString *)timeStrWithTimeSp:(NSInteger)timeSp;


/**
 时间戳转化为日期


 @param timeSp <#timeSp description#>
 @param style <#style description#>
 @return <#return value description#>
 */
+ (NSString *)dateStrWithTimeSp:(NSInteger)timeSp style:(NSString *)style;


/**
 Date转化为日期

 @param date <#date description#>
 @param style <#style description#>
 @return <#return value description#>
 */
+ (NSString *)dateStrWithDate:(NSDate *)date style:(NSString *)style;


/**
 将date转化为时间戳

 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSInteger)timeSpWithDate:(NSDate *)date;

/**
 *  创建数据模型字段
 *
 *  @param dict      字典
 *  @param className 类名
 */
+(void)createModelFromDictionary:(NSDictionary *)dict className:(NSString *)className;

/**
 *  改变Scroller的内容大小
 *
 *  @param view  当前视图
 *  @param hight 高度
 */
+ (void)setContentSize:(UIScrollView *)view andHight:(CGFloat)hight;

#pragma mark - md5加密
+(NSString *)md5Encryption:(NSString *)inPutString;


#pragma mark - 图片适应--hao
+ (UIImage*)imageWithStretchableName:(NSString *)imageName;


/**
 获取系统版本号
 */
+ (NSString *)getSystemVersion;

/**
 获取app版本号
 */
+ (NSString *)getAppVersion;


/**检测字符串是否是纯数字*/
+ (BOOL)isNumber:(NSString *)num;
/**检测字符串是否是数字或字母组成*/
+ (BOOL)isNumberOrLetter:(NSString *)num;
/**检测是否是手机号码*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**判断字符串是否为空或者都是空格*/
+ (BOOL)isBlankString:(NSString *)string;

/**
 获取手机型号
 */
+ (NSString *)getPhoneVersion;


/**
 跳转到登录界面
 
 @param vc <#vc description#>
 */
+ (void)loginWithVC:(UIViewController *)vc;

/**
 跳转到个人信息关注页面

 @param ID <#ID description#>
 @param vc <#vc description#>
 @param type <#type description#>
 */
//+ (void)pushCitizenAttentionVCWithCitizenId:(NSString *)ID vc:(UIViewController *)vc sourceType:(YXAttentionSources)type;

/**
 保留两位小数

 @param num <#num description#>
 @return <#return value description#>
 */
+ (NSString *)getFloatStr:(CGFloat)num;

/**
 将字符串转换为保留精度的数字

 @param numStr <#numStr description#>
 @return <#return value description#>
 */
+ (CGFloat)getFloatNum:(NSString *)numStr;

#pragma mark -
/** 获取能量对应的大等级名称 */
+ (NSString *)getStageNameWithEnergy:(CGFloat)energy;

/** 获取每个等级的对应的小等级的名称 */
+ (NSString *)getLevelNameWithEnergy:(CGFloat)energy;

/**
 获取联系人的名字

 @param message <#message description#>
 @return <#return value description#>
 */
+ (NSString *)getNameWithEMMessage:(id)message;


/**
 获取联系人ID（用户的昵称，头像会变，但ID不会变）

 @param msg <#msg description#>
 @return <#return value description#>
 */
+ (NSString *)getToCitizenId:(id)message;

/**
 获取联系人的头像

 @param message <#message description#>
 @return <#return value description#>
 */
+ (NSString *)getAvatarWithEMMessage:(id)message;

/**
 获取最大值

 @param count <#count description#>
 @param max <#max description#>
 @return <#return value description#>
 */
+ (NSString *)getMaxNumStrWithCount:(NSInteger)count max:(NSInteger)max;


/**
 更具友盟的三房类型返回相应的后台的三方类型

 @param type <#type description#>
 @return <#return value description#>
 */
+ (NSInteger)getThirdTypeWithUMType:(NSInteger)type;

/**
 弹出强制更新

 @param vc <#vc description#>
 */
+ (void)showForceUpdateAlertWithVC:(UIViewController *)vc;

+ (void)showLocalNotification;

+ (UIViewController *)getKeyWindowRootVC;

@end
