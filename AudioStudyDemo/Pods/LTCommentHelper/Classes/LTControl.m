
//
//  ZCControl.m
//  Device
//
//  Created by ZhangCheng on 14-4-19.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "LTControl.h"

#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
#define LT_ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
#define LT_ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试

@implementation LTControl


+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString*)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=1;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=font;
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    label.textColor=[UIColor blackColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    //    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}

+ (UILabel*)createLabelWithFrame:(CGRect)frame FontName:(UIFont *)font Text:(NSString*)text color:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment numberLines:(NSInteger)num{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (font) {
        label.font = font;
    }
    if (text) {
        label.text = text;
    }
    if (color) {
        label.textColor = color;
    }
    if (textAlignment){
        label.textAlignment = textAlignment;
    }
    if (num >= 0) {
        label.numberOfLines = num;
    }
    return label;
}



+(UIButton*)createButtonWithFrame:(CGRect)frame andImageName:(NSString*)imageName andTitle:(NSString*)title andFont:(UIFont *)font andColor:(UIColor *)color Target:(id)target Action:(SEL)action
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    if (imageName) {
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    if (color) {
        [button setTitleColor:color forState:(UIControlStateNormal)];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        //设置背景图片，可以使文字与图片共存
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIView*)createViewWithFrame:(CGRect)frame andBGColor:(UIColor *)color
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    if (color) {
        view.backgroundColor = color;
    }
    return view ;
}

+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(UIImage*)image
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=image;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled=YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView ;
}




@end
