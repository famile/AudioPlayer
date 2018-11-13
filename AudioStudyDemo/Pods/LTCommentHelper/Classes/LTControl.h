//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LTControl : NSObject

#pragma mark - 创建Label


/**
 创建label（frame font text）
 
 @param frame frame
 @param font font
 @param text text
 @return label
 */
+ (UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString*)text;

/**
 创建复杂label

 @param frame <#frame description#>
 @param font <#font description#>
 @param text <#text description#>
 @param color <#color description#>
 @param textAlignment <#textAlignment description#>
 @param num <#num description#>
 @return <#return value description#>
 */
+ (UILabel*)createLabelWithFrame:(CGRect)frame FontName:(UIFont *)font Text:(NSString*)text color:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment numberLines:(NSInteger)num;




#pragma mark - 创建button

/**
 创建常用button

 @param frame <#frame description#>
 @param imageName <#imageName description#>
 @param title <#title description#>
 @param size <#size description#>
 @param color <#color description#>
 @param target <#target description#>
 @param action <#action description#>
 @return <#return value description#>
 */
+(UIButton*)createButtonWithFrame:(CGRect)frame andImageName:(NSString*)imageName andTitle:(NSString*)title andFont:(UIFont *)font andColor:(UIColor *)color Target:(id)target Action:(SEL)action;

+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;



#pragma mark - 创建View
+ (UIView*)createViewWithFrame:(CGRect)frame andBGColor:(UIColor *)color;

#pragma mark - 创建imageView
+ (UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(UIImage*)image;



@end
