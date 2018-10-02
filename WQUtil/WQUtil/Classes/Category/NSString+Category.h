//
//  NSString+Category.h
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , TimeHandleType) {
    TimeHandleDefaultType = 0, //yyy-MM-dd HH:mm:ss，返回 yyy年MM月dd日 HH时mm分ss秒
    TimeHandleYMDType,     //yyy-MM-dd HH:mm:ss，返回 yyy年MM月dd日
    TimeHandleYMType,      //yyy-MM-dd HH:mm:ss，返回 yyy年MM月
    TimeHandleYType,       //yyy-MM-dd HH:mm:ss，返回 yyy年
    TimeHandleHMSType,     //yyy-MM-dd HH:mm:ss，返回 HH时mm分ss秒
    TimeHandleHMType,      //yyy-MM-dd HH:mm:ss，返回 HH时mm分
};

@interface NSString (Valid)

//MARK: - MD5加密
- (NSString *)MD5;

//MARK: - base64加密
- (NSString *)base64EncodeString;

//MARK: - base64解密
- (NSString *)base64DecodeString;

//MARK: - 判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)string;

//MARK: - 判断字符串是否包含表情
- (BOOL)containsEmoji;

//MARK: - 过滤表情
- (NSString *)disable_emoji;

//MARK: - 钱的处理（每隔3位数添加逗号）
- (NSString *)moneyNumberHandle;

//MARK: - 手机号码的处理 (加横杆)
- (NSString *)phoneNumberHandle;

//MARK: - 时间的处理 (时间格式：yyy-MM-dd HH:mm:ss)
- (NSString *)timeHandleReturnType:(TimeHandleType)type;

//MARK: - 距现在的时间间隔(0:在当前时间之前  1：在1年以内  2：1年以外)
- (NSInteger)intervalSinceNow;

//MARK: - 去除掉逗号
- (NSString *)solveCommaSymbol;

//MARK: - 邮箱是否输入正确
- (BOOL)checkEmail;

//MARK: - 是否为手机号
- (BOOL)isTelPhone;

//MARK: - 设置Label字体（带有行间距）
- (void)setLabelAttributedWithFont:(UIFont *)font withLabel:(UILabel *)label;

//MARK: - 计算字符串长度、高度（增加了行间距）
- (CGFloat)getSpaceLabelWithFont:(UIFont *)font withWidth:(CGFloat)width;

//MARK: - 计算今年的时间（type 1：2018   2：2018.9   3：2018.09   4：2018-9  5:2018-09）
+ (NSString *)recentYear:(NSInteger)type;

//MARK: - 计算本月的日期 （type  1：当前年 2：当前月 3：当前日 4：当前小时 5：当前分钟 6：当前秒）
+ (NSString *)recentTimeDate:(NSInteger)type;

//MARK: - 获取某个月的1号是星期几
+ (NSInteger)getFirstDayWeekForMonth:(NSString *)currentDate;

//MARK: - 获取月份的天数 (type: 1：当前月 2：上个月 3：下个月)
+ (NSInteger)getDayNumbersOfMonth:(NSInteger)type;

//MARK: - 计算最近一周的时间 (返回格式：07月07日-07月18日)
+ (NSString *)recentAWeak;

//MARK: - 计算最近一周的时间
+ (NSString *)calculateRecentAWeak:(NSString *)nowTime;

//MARK: - 处理时间（举例： dateString：2018-09-04  返回：2018.9）
+ (NSString *)solveDateString:(NSString *)dateString;

//MARK: - 判断物业审核人中是否包含用户
- (BOOL)propertVerifyUserIdsContainsUserId:(NSString *)userId propertVerifyUserIds:(NSString *)propertVerifyUserIds;

//MARK: - 权限管理的时候，url缺少了 "/" 符号
- (NSString *)appendingStringForURL;

//MARK: - 空格的过滤 (removeAll: 是否过滤掉所有的空格，默认是只去除头尾的空格)
- (NSString *)removeEmptyBlank:(BOOL)removeAll;

//MARK: - 判断是否是纯汉字
- (BOOL)isAllChinese;

//MARK: - 判断是否含有汉字
- (BOOL)includeChinese;

//MARK: - 过滤掉字符
- (NSString *)filterChineseCharacterAndOthers;

//MARK: - 字母、数字、中文正则判断
- (BOOL)isInputRuleNotBlank:(NSString *)str;

//MARK: - 保留小数点后两位
- (NSString *)filterTwoCharacter;

//MARK: - 是否是单个字母
- (BOOL)isSingleLetter;

//是否包含
- (BOOL)containsString:(NSString *)str;

@end

@interface NSString (Pinyin)

- (NSString*)pinyinWithPhoneticSymbol;
- (NSString*)pinyin;
- (NSArray*)pinyinArray;
- (NSString*)pinyinWithoutBlank;
- (NSArray*)pinyinInitialsArray;
- (NSString*)pinyinInitialsString;
- (NSString*)pinyinFirstCharacter;

@end

@interface NSString (Size)

//MARK: - 字符串高度的计算
-(CGSize)sizeWithFontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;
-(CGSize)sizeWithFont:(UIFont*)font MaxSize:(CGSize)maxSize;

@end

