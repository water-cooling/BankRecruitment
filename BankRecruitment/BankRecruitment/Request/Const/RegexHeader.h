//
//  RegexHeader.h
//  JDFramework
//
//  Created by wkx on 14-5-4.
//  Copyright (c) 2014年 JD. All rights reserved.
//

#ifndef JDFramework_RegexHeader_h
#define JDFramework_RegexHeader_h


#pragma mark--正则表达式

//浮点数
#define REGEX_decmal		@"^([+-]?)\\d*\\.\\d+$"
//正浮点数
#define REGEX_decmal1		@"^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*$"
//负浮点数
#define REGEX_decmal2		@"^-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*)$"
//浮点数
#define REGEX_decmal3		@"^-?([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0)$"
//非负浮点数（正浮点数 + 0）
#define REGEX_decmal4		@"^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0$"
//非正浮点数（负浮点数 + 0）
#define REGEX_decmal5		@"^(-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*))|0?.0+|0$"
//整数
#define REGEX_intege		@"^-?[1-9]\\d*$"
//正整数
#define REGEX_intege1		@"^[1-9]\\d*$"
//负整数
#define REGEX_intege2		@"^-[1-9]\\d*$"
//数字
#define REGEX_num			@"^([+-]?)\\d*\\.?\\d+$"
//正数（正整数 + 0）
#define REGEX_num1			@"^[1-9]\\d*|0$"
//负数（负整数 + 0）
#define REGEX_num2			@"^-[1-9]\\d*|0$"
//仅ACSII字符
#define REGEX_ascii			@"^[\\x00-\\xFF]+$"
//仅中文
#define REGEX_chinese		@"^[\\u4e00-\\u9fa5]+$"
//颜色
#define REGEX_color			@"^[a-fA-F0-9]{6}$"
//日期
#define REGEX_date			@"^\\d{4}(\\-|\\/|\.)\\d{1,2}\\1\\d{1,2}$"
//邮件
//#define REGEX_email			@"^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$"
#define REGEX_email         @"\\w+@\\w+\\.[a-z]+(\\.[a-z]+)?"
//身份证
#define REGEX_idcard		@"^\\d{6}(18|19|20)?\\d{2}(0[1-9]|1[12])(0[1-9]|[12]\\d|3[01])\\d{3}|(\\d|X)$"
//ip地址
#define REGEX_ip4			@"^(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)$"
//字母
#define REGEX_letter		@"^[A-Za-z]+$"
//小写字母
#define REGEX_letter_l		@"^[a-z]+$"
//大写字母
#define REGEX_letter_u		@"^[A-Z]+$"
//手机
#define REGEX_mobile		@"^[1][3-8]+\\d{9}"
//手机(严格)
#define REGEX_mobileMore	@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))|(170)\\d{8}$"
//非空
#define REGEX_notempty		@"^\\S+$"
//密码
#define REGEX_password		@"^(?=.*?\\d)(?=.*?[A-Za-z])[\\dA-Za-z0-9]{6,20}$" //@"^[A-Za-z0-9_-]+$" ^[A-Za-z0-9]+$
                                                                               //图片
#define REGEX_picture		@"(.*)\\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png|raw|tga)$"
//QQ号码
#define REGEX_qq			@"^[1-9]*[1-9][0-9]*$"
//压缩文件
#define REGEX_rar			@"(.*)\\.(rar|zip|7zip|tgz)$"
//电话号码的函数(包括验证国内区号,国际区号,分机号)
#define REGEX_tel			@"^[0-9\-()（）]{7,18}$"
//url
#define REGEX_url			@"^http[s]?:\\/\\/([\\w-]+\\.)+[\\w-]+([\\w-./?%&=]*)?$"
//用户名
#define REGEX_username		@"^[A-Za-z0-9_\\-\\u4e00-\\u9fa5]+$"
//单位名
#define REGEX_deptname		@"^[A-Za-z0-9_()（）\\-\\u4e00-\\u9fa5]+$"
//邮编
#define REGEX_zipcode		@"^\\d{6}$"
//真实姓名
#define REGEX_realname		@"^[A-Za-z0-9\\u4e00-\\u9fa5]+$"
//银行卡
#define REGEX_bankcard      @"^\\d{16,19}$|^\\d{6}[  ]\\d{10,13}$|^\\d{4}[  ]\\d{4}[  ]\\d{4}[  ]\\d{4}[  ]\\d{2,3}$"
//正负金额
#define REGEX_money_negative @"^(-)?(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$"
//正金额
#define REGEX_money_plus    @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$"


#endif
