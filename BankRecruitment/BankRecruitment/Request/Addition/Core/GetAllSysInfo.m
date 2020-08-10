//
//  GetAllSysInfo.m
//  SuningEBuy
//
//  Created by xy ma on 11-12-27.
//  Copyright (c) 2011年 sn. All rights reserved.
//

#import "GetAllSysInfo.h"
#import "Preferences.h"
//#import "OpenUDID.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GetAllSysInfo


+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}




@end

