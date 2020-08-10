//////////////////////////////////////////////////////////////////////////  
///                         COPYRIGHT NOTICE  
///
/// Copyright (c) 2011, CIeNET Technologies  
/// All rights reserved.  
///  
/// @file  BusinessConstant.h
/// @brief  业务需求常量定义.
///  
///  
///  
/// @version 1.0.0     
/// @author  Poseidon         
/// @date    2011.09.15               
///  
///  
/// 
//////////////////////////////////////////////////////////////////////////

// for GreetingCardMainView
#define kDicTagName @"name"
#define kDicTagDate @"date"
#define kDicTagTag  @"tag"
#define kDicTagStartNum @"startnum"
#define kDicTagPageStr @"pagestr"

#define kTagHttpPageNum @"pageNum="
#define kTagHttpResultSize @"resultSize="

#define kDefaultPageSize 10
#define constructStringForPage(num) [NSString stringWithFormat:@"%@%d&%@%d", \
                                                        kTagHttpPageNum, num, \
                                                        kTagHttpResultSize, kDefaultPageSize]

#define kDefaultResultSize          100
#define kAppKeyForSina              @"4116072510"
#define kAppSecretForSina           @"31d20533c9293aacf0ed47bb1369ad8f"
#define kAppKeyForTencent           @"801005674"
#define kAppSecretForTencent        @"3724cf0829f34c4aa3af600b6fc6d48f"
#define kAppKeyForRenRen            @"494a656999834241860967464c47fee7"
#define kAppSecretForRenRen         @"ee3d1aadef394a988f9357f5f91e05a6"
#define kTokenGrantType             @"password"
