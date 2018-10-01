//
//  NSString+Category.m
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/7.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

static float const UILabel_Line_SPACE = 3.2; //行间距
static float const UILabel_Word_SPACE = 1.0; //字间距

@implementation NSString (Valid)

//MARK: - MD5加密
- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

//MARK: - base64加密
- (NSString *)base64EncodeString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

//MARK: - base64解密
- (NSString *)base64DecodeString {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//MARK: - 判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)string {
    if([string isKindOfClass:[NSString class]]) {
        return string == nil || string==(id)[NSNull null] || [string isEqualToString:@""] || string.length == 0;
    }
    return YES;
}

//MARK: - 过滤掉字符
- (NSString *)filterChineseCharacterAndOthers {
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    NSString *tempString = [[self componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [tempString stringByTrimmingCharactersInSet:set];
    return trimmedString;
}

//MARK: - 保留小数点后两位
- (NSString *)filterTwoCharacter {
    if (![NSString isEmpty:self] && [self containsString:@"."]) {
        NSArray *arr = [self componentsSeparatedByString:@"."];
        NSString *lastText = [arr lastObject];
        if (lastText && lastText.length > 2) {
            return [NSString stringWithFormat:@"%@.%@",arr.firstObject,[lastText substringToIndex:2]];
        }
    }
    return self;
}

//MARK: - 字母、数字、中文正则判断
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

//MARK: - 过滤表情
- (NSString *)disable_emoji {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

//MARK: - 判断字符串是否包含表情
- (BOOL)containsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

//MARK: - 钱的处理（每隔3位数添加逗号）
- (NSString *)moneyNumberHandle {
    if (!self.doubleValue) {
        return @"0.00";
    }
    
    NSString *str0; //整数
    NSString* str1; //小数点之后的数字
    if ([self containsString:@"."]) {
        NSArray* array = [self componentsSeparatedByString:@"."];
        str0 = array[0];
        str1 = array[1];
    }else{
        str0 = self;
    }
    int count = 0;
    long long int a = str0.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:str0];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    if ([self containsString:@"."]) {
        //包含小数点
        //返回的数字
        NSString* str2;
        if (str1.length) {
            //小数点后面有数字
            str2 = [NSString stringWithFormat:@"%@.%@",newstring,str1];
        }else{
            //没有数字
            str2 = [NSString stringWithFormat:@"%@.00",newstring];
        }
        return str2;
    }else{
        //不包含小数点
        return [NSString stringWithFormat:@"%@.00",newstring];;
    }
}

//MARK: - 手机号码的处理 (加横杆)
- (NSString *)phoneNumberHandle {
    if (self && self.length == 11) {
        NSString *newString = [NSString stringWithFormat:@"%@-%@-%@",[self substringToIndex:2],[self substringWithRange:NSMakeRange(3,4)],[self substringFromIndex:7]];
    }
    return self;
}

//MARK: - 时间的处理 (时间格式：yyy-MM-dd HH:mm:ss)
- (NSString *)timeHandleReturnType:(TimeHandleType)type {
    if (self && self.length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate* dateTodo = [formatter dateFromString:self];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *currentDateString = [dateFormatter stringFromDate:dateTodo];
        NSArray *arr0 = [currentDateString componentsSeparatedByString:@" "];
        NSArray *arr1 = [[arr0 firstObject] componentsSeparatedByString:@"-"];
        NSArray *arr2 = [[arr0 lastObject] componentsSeparatedByString:@":"];
        if (type == TimeHandleDefaultType && arr1.count == 3 && arr2.count == 3) {
            return [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分%@秒",arr1[0],arr1[1],arr1[2],arr2[0],arr2[1],arr2[2]];
        }else if (type == TimeHandleYMDType && arr1.count == 3) {
            return [NSString stringWithFormat:@"%@年%@月%@日",arr1[0],arr1[1],arr1[2]];
        }else if (type == TimeHandleYMType && arr1.count == 3) {
            return [NSString stringWithFormat:@"%@年%@月",arr1[0],arr1[1]];
        }else if (type == TimeHandleYType && arr1.count == 3) {
            return [NSString stringWithFormat:@"%@年",arr1[0]];
        }else if (type == TimeHandleHMSType && arr2.count == 3) {
            return [NSString stringWithFormat:@"%@时%@分%@秒",arr2[0],arr2[1],arr2[2]];
        }else if (type == TimeHandleHMType && arr2.count == 3) {
            return [NSString stringWithFormat:@"%@时%@分",arr2[0],arr2[1]];
        }
    }
    return self;
}

//MARK: - 距现在的时间间隔(0:在当前时间之前  1：在1年以内  2：1年以外)
- (NSInteger)intervalSinceNow {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [date dateFromString:self];
    NSTimeInterval late = [d timeIntervalSince1970] * 1;
    NSDate *dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;
    NSTimeInterval cha = late - now;
    if (cha < -10) {
        //当前时间之前
        return 0;
    } else if(cha > 365 * 86400) {
        //大于一年
        return 2;
    }
    return 1;
}

//MARK: - 去除掉逗号
- (NSString *)solveCommaSymbol {
    if (self && self.length && [self containsString:@","]) {
        NSString *string = [self stringByReplacingOccurrencesOfString:@"," withString:@""];  //去掉空格
        return string;
    }
    return self;
}

//MARK: - 验证邮箱是否输入正确
- (BOOL)checkEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [emailTest evaluateWithObject:self];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

//MARK: - 验证用户名是否为手机号
- (BOOL)isTelPhone {
    NSString *regex =  @"^[1][358][0-9]{9}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pre evaluateWithObject:self];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

//MARK: - 设置Label字体（带有行间距）
- (void)setLabelAttributedWithFont:(UIFont *)font withLabel:(UILabel *)label {
    if ([NSString isEmpty:self]) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    [paragraphStyle setLineSpacing:UILabel_Line_SPACE];
    //设置字间距
    NSDictionary *dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@(UILabel_Word_SPACE)};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dic];
    label.attributedText = attributeStr;
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
}

//MARK: - 计算字符串长度、高度（增加了行间距）
- (CGFloat)getSpaceLabelWithFont:(UIFont*_Nullable)font withWidth:(CGFloat)width {
    if ([NSString isEmpty:self]) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILabel_Line_SPACE;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(UILabel_Word_SPACE)};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, [[UIScreen mainScreen] bounds].size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    size.height = ceil(size.height) + 1;
    return size.height;
}

//MARK: - 计算今年的时间（type 1：2018   2：2018.9   3：2018.09   4：2018-9  5:2018-09）
+ (NSString *)recentYear:(NSInteger)type {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy MM dd HH mm ss"];
    NSString *result = [formatter stringFromDate:now];
    NSArray *arr = [result componentsSeparatedByString:@" "];
    if (type == 1) {
        return arr[0];
    }else if (type == 2) {
        NSInteger month = [arr[1] integerValue];
        return [NSString stringWithFormat:@"%@.%ld",arr[0],month];
    }else if (type == 3) {
        return [NSString stringWithFormat:@"%@.%@",arr[0],arr[1]];
    }else if (type == 4) {
        NSInteger month = [arr[1] integerValue];
        return [NSString stringWithFormat:@"%@-%ld",arr[0],month];
    }else if (type == 5) {
        NSInteger month = [arr[1] integerValue];
        return [NSString stringWithFormat:@"%@-%@",arr[0],arr[1]];
    }
    return result;
}

//MARK: - 处理时间（举例： dateString：2018-09-04  返回：2018.9）
+ (NSString *)solveDateString:(NSString *)dateString {
    if ([NSString isEmpty:dateString]) {
        return @"";
    }
    if ([dateString containsString:@"-"]) {
        NSArray *arr0 = [dateString componentsSeparatedByString:@"-"];
        if (arr0.count >= 2) {
            NSString *yearStr = arr0[0];
            NSString *monthStr = arr0[1];
            NSString *dateStr = [NSString stringWithFormat:@"%@.%ld",yearStr,[monthStr integerValue]];
            return dateStr;
        }
    }
    return dateString;
}

//MARK: - 计算本月的日期 （type  1：当前年 2：当前月 3：当前日 4：当前小时 5：当前分钟 6：当前秒）
+ (NSString *)recentTimeDate:(NSInteger)type {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy MM dd HH mm ss"];
    NSString *result = [formatter stringFromDate:now];
    NSArray *arr = [result componentsSeparatedByString:@" "];
    if (type == 1) {
        return arr[0];
    }else if (type == 2){
        return arr[1];
    }else if (type == 3){
        return arr[2];
    }else if (type == 4){
        return arr[3];
    }else if (type == 5){
        return arr[4];
    }else if (type == 6){
        return arr[5];
    }
    return nil;
}

//MARK: - 获取某个月的1号是星期几
+ (NSInteger)getFirstDayWeekForMonth:(NSString *)currentDate {
    NSString *time = @"";
    if (currentDate && ![NSString isEmpty:currentDate] && [currentDate containsString:@"-"] && currentDate.length >= 8) {
        time = [currentDate substringToIndex:7];
        time = [NSString stringWithFormat:@"%@-01 11:00:00",time];
    }else{
        NSString *time = [NSString recentYear:5];
        time = [NSString stringWithFormat:@"%@-01 11:00:00",time];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:sss"];
    NSDate *date = [formatter dateFromString:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//指定日历的算法
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    //WeekDay 表示周里面的天 1代表周日 2代表周一 7代表周六
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    weekday = weekday - 2;
    if (weekday == 7) {
        return 0;
    }else {
        return weekday;
    }
}

//MARK: - 获取月份的天数 (type: 1：当前月 2：上个月 3：下个月)
+ (NSInteger)getDayNumbersOfMonth:(NSInteger)type {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDate *currentDate = [NSDate date];
    if (type == 1) {
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:currentDate];
        return range.length;
    }else{
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:currentDate];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:type == 2 ? -1 : +1];
        [adcomps setDay:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:currentDate options:0];
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:newdate];
        return range.length;
    }
}

//MARK: - 计算最近一周的时间
+ (NSString *)recentAWeak {
    NSDate *now = [NSDate date];
    NSString *string = [self timeStringSolved:now];
    return string;
}

//MARK: - 计算最近一周的时间
+ (NSString *)calculateRecentAWeak:(NSString *)nowTime {
    NSString *currentDay = nowTime;
    if (!currentDay) return nil;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![nowTime containsString:@":"]) {
        currentDay = [NSString stringWithFormat:@"%@ 00:00:00",currentDay];
    }
    NSDate *now = [formatter dateFromString:currentDay];
    NSString *string = [NSString timeStringSolved:now];
    return string;
}

//MARK: - 时间的处理
+ (NSString *)timeStringSolved:(NSDate *)now {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 7 - weekDay;
    }
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MM月dd日"];
    NSString *s1 = [formater stringFromDate:firstDayOfWeek];
    NSString *s2 = [formater stringFromDate:now];
    NSString *s3 = [formater stringFromDate:lastDayOfWeek];
    
    NSArray *arr0 = [s1 componentsSeparatedByString:@"月"];
    NSArray *arr2 = [[arr0 lastObject] componentsSeparatedByString:@"日"];
    NSInteger index0 = [[arr2 firstObject] integerValue];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
                                   inUnit: NSMonthCalendarUnit
                                  forDate:now];
    NSString *monday,*sunday;
    if (index0 + 1 <= range.length) {
        //+1小于当前月的天数
        monday = [NSString stringWithFormat:@"%@月%d日",[arr0 firstObject],index0 + 1];
    }else{
        monday = [NSString stringWithFormat:@"%@月1日",[[arr0 firstObject] integerValue] + 1];
    }
    
    NSArray *arr01 = [s3 componentsSeparatedByString:@"月"];
    NSArray *arr21 = [[arr01 lastObject] componentsSeparatedByString:@"日"];
    NSInteger index01 = [[arr21 firstObject] integerValue];
    NSRange range1 = [calendar rangeOfUnit:NSDayCalendarUnit
                                    inUnit: NSMonthCalendarUnit
                                   forDate:now];
    if (index01 + 1 <= range1.length) {
        //+1小于当前月的天数
        sunday = [NSString stringWithFormat:@"%@月%d日",[arr01 firstObject],index01 + 1];
    }else{
        sunday = [NSString stringWithFormat:@"%@月1日",[[arr01 firstObject] integerValue] + 1];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@-%@",monday,sunday];
    return string;
}

//MARK: - 判断物业审核人中是否包含用户
- (BOOL)propertVerifyUserIdsContainsUserId:(NSString *)userId propertVerifyUserIds:(NSString *)propertVerifyUserIds {
    @synchronized (self) {
        __block BOOL caontains = NO;
        if (!propertVerifyUserIds || !propertVerifyUserIds.length || !userId || !userId.length) return NO;
        NSArray *arr = [propertVerifyUserIds componentsSeparatedByString:@","];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:userId]) {
                caontains = YES;
            }
        }];
        return caontains;
    }
}

//MARK: - 权限管理的时候，url缺少了 "/" 符号
- (NSString *)appendingStringForURL {
    if (!self){
        return @"";
    }
    NSString *string = self;
    if (string && ![NSString isEmpty:string]) {
        if (![string hasPrefix:@"/"]) {
            string = [NSString stringWithFormat:@"/%@",string];
        }
    }
    string = [string removeEmptyBlank:YES];
    return string;
}

//MARK: - 空格的过滤 (removeAll: 是否是所有的空格，默认是去除头尾的空格)
- (NSString *)removeEmptyBlank:(BOOL)removeAll {
    NSString *string = self;
    if ([string hasPrefix:@" "] || [string hasSuffix:@" "] || [string rangeOfString:@"\n"].location != NSNotFound || [string rangeOfString:@"\n\n"].location != NSNotFound || [string rangeOfString:@"\n\n\n"].location != NSNotFound) {
        if (removeAll) {
            //去除所有的空格
            [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        //去除回车
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //去除首尾的空格
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return string;
    }else{
        return string;
    }
}

//MARK: - 判断是否是纯汉字
- (BOOL)isAllChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

//MARK: - 判断是否含有汉字
- (BOOL)includeChinese {
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSingleLetter {
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    int tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    if(tLetterMatchCount == 1){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)containsString:(NSString *)str
{
    return [self containsString:str Options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString *)str Options:(NSStringCompareOptions)compareOptions
{
    return (str != nil) && ([str length] > 0) && ([self length] >= [str length]) && ([self rangeOfString:str options:compareOptions].location != NSNotFound);
}

@end

//MARK: - pinyin
@implementation NSString (Pinyin)

- (NSString*)pinyinWithPhoneticSymbol {
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    return pinyin;
}

- (NSString*)pinyin {
    NSMutableString *pinyin = [NSMutableString stringWithString:[self pinyinWithPhoneticSymbol]];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

- (NSArray*)pinyinArray {
    NSArray *array = [[self pinyin] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return array;
}

- (NSString*)pinyinWithoutBlank {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    for (NSString *str in [self pinyinArray]) {
        [string appendString:str];
    }
    return string;
}

- (NSArray*)pinyinInitialsArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in [self pinyinArray]) {
        if ([str length] > 0) {
            [array addObject:[str substringToIndex:1]];
        }
    }
    return array;
}

- (NSString*)pinyinInitialsString {
    NSMutableString *pinyin = [NSMutableString stringWithString:@""];
    for (NSString *str in [self pinyinArray]) {
        if ([str length] > 0) {
            [pinyin appendString:[str substringToIndex:1]];
        }
    }
    return pinyin;
}

- (NSString*)pinyinFirstCharacter {
    NSString *pinyin = [self pinyinWithoutBlank];
    pinyin =  [[pinyin substringToIndex:1] uppercaseString];
    return pinyin;
}

@end

//MARK: - Size
@implementation NSString (Size)

- (CGSize)sizeWithFontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    CGSize limitsize = maxSize;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [self boundingRectWithSize:limitsize options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //向上取整处理
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    return size;
}

- (CGSize)sizeWithFont:(UIFont*)font MaxSize:(CGSize)maxSize {
    CGSize limitsize = maxSize;
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:limitsize options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //向上取整处理
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    return size;
}

@end

