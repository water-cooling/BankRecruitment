//
//  LdCommon.m
//  GroupV
//
//  Created by lurn on 1/25/14.
//  Copyright (c) 2014 Lordar. All rights reserved.
//

#import "LdCommon.h"
#import "UIView+WebCache.h"
#import "UIImage+fixOrientation.h"
#import "LdActionSheet.h"
#import "LdAlertView.h"
#import "UIImageView+WebCache.h"

//
// 从table中获得cell，如果没有就创建
//
UITableViewCell* ldGetTableCellFromNib(UITableView* tableView, NSString* cellReuseId, Class cellClass, NSString* nibName)
{
    UITableViewCell* loc_Cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    if(!loc_Cell)
    {
        NSArray* loc_Objs = [[NSBundle mainBundle] loadNibNamed:nibName owner:tableView options:nil];
        
        for(UITableViewCell* loc_Obj in loc_Objs)
        {
            if([loc_Obj isKindOfClass:cellClass])
            {
                return loc_Obj;
            }
        }
    }
    
    return loc_Cell;
}

//
// 从table中获得cell，如果没有就创建
//
UITableViewCell* ldGetTableCellWithStyle(UITableView* tableView, NSString* cellReuseId, UITableViewCellStyle cellStyle)
{
    UITableViewCell* loc_Cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    if(!loc_Cell)
    {
        loc_Cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellReuseId];
    }
    return loc_Cell;
}

UITableViewCell* ldGetTableBusyCell(UITableView* tableView)
{
    UITableViewCell* loc_Cell = [tableView dequeueReusableCellWithIdentifier:@"BUSY_CELL"];
    if(!loc_Cell)
    {
        loc_Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BUSY_CELL"];

        // 追加指示器
        UIActivityIndicatorView* actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        actView.color = [UIColor blackColor];
        actView.frame = loc_Cell.contentView.bounds;
        actView.hidesWhenStopped = FALSE;
        actView.tag = 9898;
        [loc_Cell.contentView addSubview:actView];
    }
    
    for(UIActivityIndicatorView* actView in loc_Cell.contentView.subviews)
    {
        if(actView.tag == 9898)
        {
            [actView startAnimating];
        }
    }
    
    return loc_Cell;
}

BOOL ldGetHeightAndLineNumFromLabel(UILabel* label, NSString* str, float* height, int* linenum)
{
    // 至少有一个字符的内容
    if(!str || !str.length)
    {
        str = @" ";
    }
    
    CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX) lineBreakMode:label.lineBreakMode];
    
    *height = ceilf(size.height);
    *linenum = (int)(0.5f + *height / label.font.lineHeight);
    return TRUE;
}

BOOL strIsNullOrEmpty(NSString* str)
{
    return (!str || [str isKindOfClass:[NSNull class]] || !str.length || [str isEqualToString:@"null"]);
}

NSString* strWithOutSpaceAndReturn(NSString* responseString)
{
    responseString = [responseString stringByReplacingOccurrencesOfString:@" " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return responseString;
}

NSString* strIfNull(NSString* str, NSString* def)
{
    return (strIsNullOrEmpty(str) ? def : str);
}

NSString* strIfNullDB(NSString* str, NSString* def)
{
    return ((strIsNullOrEmpty(str) || [str.lowercaseString isEqualToString:@"null"]) ? def : str);
}

BOOL strIsLongTelNum(NSString* str)
{
    return (!strIsNullOrEmpty(str) && str.length >= 11 && str.length <= 15);
}

BOOL isMobileTelNum(NSString* str)
{
    NSString* telHead = [str substringToIndex:3];
    NSArray* telAry = @[@"134",@"135",@"136",@"137",@"138",@"139",@"147",@"150",@"151",@"152",@"157",@"158",@"159",@"182",@"183",@"184",@"187",@"188"];
    
    for(NSString* t in telAry)
    {
        if([t isEqualToString:telHead])
        {
            return TRUE;
        }
    }
    return FALSE;
}

BOOL isUnionComTelNum(NSString* str)
{
    NSString* telHead = [str substringToIndex:3];
    NSArray* telAry = @[@"130",@"131",@"132",@"145",@"155",@"156",@"185",@"186"];
    
    for(NSString* t in telAry)
    {
        if([t isEqualToString:telHead])
        {
            return TRUE;
        }
    }
    return FALSE;
}

BOOL isTeleComTelNum(NSString* str)
{
    NSString* telHead = [str substringToIndex:3];
    NSArray* telAry = @[@"133",@"153",@"180",@"181",@"189"];
    
    for(NSString* t in telAry)
    {
        if([t isEqualToString:telHead])
        {
            return TRUE;
        }
    }
    return FALSE;
}

void showSimpleAlert(NSString* title, NSString* msg)
{
    LdAlertView* alertView = [[LdAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    [alertView show];
}

//
// 图片加载
//
void showWebImageOnView(UIImageView* imageView, NSString* url, UIImage* placehold)
{
    if(!imageView)
    {
        return;
    }
    
    [imageView sd_cancelCurrentImageLoad];
    if(strIsNullOrEmpty(url))
    {
        imageView.image = placehold;
    }
    else
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placehold];
    }
}

//
// 保持图片到文件
//
BOOL saveJPEGPicture(UIImage* image, NSString* jpge_path, CGSize size, SAVE_PICTURE_TYPE type)
{
    if(type != SAVE_PICTURE_KEEP_SIZE)
    {
        int w = image.size.width;
        int h = image.size.height;
        if(type == SAVE_PICTURE_FIT_SIZE)
        {
            float R = MIN(size.width/w, size.height/h);
            w = w*R;
            h = h*R;
        }
        else if(type == SAVE_PICTURE_FILL_SIZE)
        {
            float R = MAX(size.width/w, size.height/h);
            w = w*R;
            h = h*R;
        }
        else if(type == SAVE_PICTURE_STRETCH)
        {
            w = size.width;
            h = size.height;
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(w, h));
        [image drawInRect:CGRectMake(0, 0, w, h)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return [UIImageJPEGRepresentation(image, 0.3) writeToFile:jpge_path atomically:YES];
}

NSDate* dateFromStrISO(NSString* date_str)
{
    if(strIsNullOrEmpty(date_str))
    {
        return nil;
    }
    
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFmt dateFromString:date_str];
}

BOOL isMobileNumberClassification(NSString* content)
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[1234567890]|7[1234567890]|8[1234567890])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestcm evaluateWithObject:content] == YES)
        || ([regextestct evaluateWithObject:content] == YES)
        || ([regextestcu evaluateWithObject:content] == YES)
        || ([regextestphs evaluateWithObject:content] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


NSString* strFromDateISO(NSDate* date)
{
    if(!date)
    {
        return nil;
    }
    
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFmt stringFromDate:date];
}

NSString* getUUID()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString* uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);

    return uuid;
}


NSString* getFileNameFromURL(NSString* urlStr)
{
    if(strIsNullOrEmpty(urlStr))
    {
        return nil;
    }
    
    NSArray* parts = [urlStr componentsSeparatedByString:@"/"];
    if(parts.count == 0)
    {
        return nil;
    }
    
    return [parts[parts.count - 1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 获取会议附件的URL
NSString* getAttachURL(NSString* url)
{
    if(strIsNullOrEmpty(url))
    {
        return nil;
    }
    
    NSMutableArray* parts = [[url componentsSeparatedByString:@","] mutableCopy];
    if(parts.count < 2)
    {
        return parts[0];
    }
    
    // 删除最后一部分，剩余部分重新用逗号组合
    [parts removeObjectAtIndex:parts.count - 1];
    return [parts componentsJoinedByString:@","];
}

// 获取会议附件的原名称
NSString* getAttachOriginName(NSString* url)
{
    NSArray* parts = [url componentsSeparatedByString:@","];
    if(parts == 0)
    {
        return nil;
    }
    return parts[parts.count - 1];
}

// 获取排序后的号码名称
NSString* createSortNames(NSArray* names)
{
    NSMutableArray* telNums = [NSMutableArray arrayWithArray:names];
    [telNums sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*)obj1 compare:obj2];
    }];
    
    return [telNums componentsJoinedByString:@";"];
}



// 聊天背景图数组
NSString* getChatBackImageFilePath(NSString* taskId)
{
    if(strIsNullOrEmpty(taskId))
    {
        return nil;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *backImageDict = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"kBackImageDict"]];
    if(backImageDict)
    {
        return [backImageDict objectForKey:taskId];
    }
    else
    {
        backImageDict = [NSMutableDictionary dictionaryWithCapacity:9];
        [defaults setObject:backImageDict forKey:@"kBackImageDict"];
        [defaults synchronize];
        return nil;
    }
}

void setChatBackImageFilePath(NSString* taskId, NSString* imageFile)
{
    if(strIsNullOrEmpty(taskId)||strIsNullOrEmpty(imageFile))
    {
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *backImageDict = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"kBackImageDict"]];
    if(backImageDict)
    {
        [backImageDict setObject:imageFile forKey:taskId];
    }
    else
    {
        backImageDict = [NSMutableDictionary dictionaryWithCapacity:9];
        [backImageDict setObject:imageFile forKey:taskId];
    }
    [defaults setObject:backImageDict forKey:@"kBackImageDict"];
    [defaults synchronize];
}


UIImage *getNavigationBarBackImageByImage(UIImage *image)
{
    UIGraphicsBeginImageContext(CGSizeMake(Screen_Width, 64));
    [image drawInRect:CGRectMake(0, 0, Screen_Width, 64)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//字典转Json字符串
NSString* convertToJSONData(id infoDict)
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

//JSON字符串转化为字典
NSDictionary *dictionaryWithJsonString(NSString *jsonString)
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

int dateNumberFromDateToToday(NSString* date_str)
{
    if(strIsNullOrEmpty(date_str))
    {
        return 0;
    }
    
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFmt dateFromString:date_str];
    return (int)[date timeIntervalSinceNow]/60/60/24 + 1;
}

bool isSignAppToday(NSString* date_str)
{
    if(strIsNullOrEmpty(date_str))
    {
        return NO;
    }
    
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [dateFmt dateFromString:date_str];
    NSDate *today = [[NSDate alloc] init];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

NSString *AssignEmptyString(NSString* str)
{
    NSString *tempStr = @"";
    if([str isKindOfClass:[NSNumber class]])
    {
        tempStr = [NSString stringWithFormat:@"%@",str];
        return tempStr;
    }
    
    if (strIsNullOrEmpty(str))
    {
        return @"";
    }
    
    if ([str isEqualToString:@"<null>"])
    {
        return @"";
    }
    return str;
}

//正则去除网络标签
NSString *getZZwithString(NSString* string){
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

//iOS NSString 转换编码格式ISO-8859-1
NSString *getISO8859withString(NSString* string){
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    return [NSString stringWithCString:[string UTF8String] encoding:enc];
}

