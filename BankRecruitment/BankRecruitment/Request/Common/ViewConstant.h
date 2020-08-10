//////////////////////////////////////////////////////////////////////////  
///                         COPYRIGHT NOTICE  
///
/// Copyright (c) 2011, CIeNET Technologies  
/// All rights reserved.  
///  
/// @file  ViewConstant.h
/// @brief  全局界面常量定义.
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

#pragma mark - For Global
//Global Define

#define kStandardWindowWidth          320
#define kStandardWindowHeight         568
#define kStandardWindowWidth2x        640
#define kStandardWindowHeight2x       568*2
#define kDefaultSystemBarHeight       44

#define kActivityIndicatorViewFrame   CGRectMake(0, 0, 32, 32)

#define kDefaultCollectionCapacity    2
#define kDefaultViewBackgroundColor   \
        [UIColor colorWithRed:(245.0/255)\
                        green:(245.0/255)\
                         blue:(245.0/255)\
                        alpha:1.0]


#pragma mark - For Dynamic 
//Dynamic Define
#define kPlainTextModeEnabled      0     //0为开启图文编辑模式,1为使用普通编辑模式

// 默认文本颜色
#define kDefaultTextColor           [UIColor colorWithRed:(51.0/255.0) \
                                                    green:(51.0/255.0) \
                                                     blue:(51.0/255.0) \
                                                    alpha:1.0]
// 链接文本颜色
#define kDefaultLinkTextColor       [UIColor colorWithRed:(0.0/255.0) \
                                                    green:(102.0/255.0) \
                                                     blue:(204.0/255.0) \
                                                    alpha:1.0]
// 动态首页时间颜色
#define kDynamicTimeTextColor       [UIColor colorWithRed:(228.0/255.0) \
                                                    green:(159.0/255.0) \
                                                     blue:(64.0/255.0) \
                                                    alpha:1.0]
// 动态首页转发文本颜色
#define kDynamicForwardTextColor    [UIColor colorWithRed:(128.0/255.0) \
                                                    green:(128.0/255.0) \
                                                     blue:(128.0/255.0) \
                                                    alpha:1.0]
// 动态首页来源文本颜色
#define kDynamicSourceTextColor     [UIColor colorWithRed:(180.0/255.0) \
                                                    green:(180.0/255.0) \
                                                     blue:(180.0/255.0) \
                                                    alpha:1.0]
// 动态首页背景颜色
#define kDynamicBackgroundColor     [UIColor colorWithRed:(247.0/255.0) \
                                                    green:(247.0/255.0) \
                                                     blue:(247.0/255.0) \
                                                    alpha:1.0]

// 返回按钮文字颜色
#define kBarItemTextColor           [UIColor colorWithRed:(77.0/255.0) \
                                                    green:(98.0/255.0) \
                                                     blue:(120.0/255.0) \
                                                    alpha:1.0]

#define kSegmentBackgroundColor     [UIColor colorWithRed:(198.0/255.0) \
                                                    green:(215.0/255.0) \
                                                     blue:(229.0/255.0) \
                                                    alpha:1.0]

#define kSegmentSelectBgColor       [UIColor colorWithRed:(168.0/255.0) \
                                                    green:(179.0/255.0) \
                                                     blue:(188.0/255.0) \
                                                    alpha:1.0]
#define kTopicSymbol                @"#"
#define kAtSymbol                   @"@"
#define kMotionFile                 @"motionStr.plist"
#define kMotionZHArrayFile          @"MotionZHArray.plist"
#define kMotionENArrayFile          @"MotionENArray.plist"
#define kMotionZHHashArrayFile      @"MotionZHHashArray.plist"
#define kMotionENHashArrayFile      @"MotionENHashArray.plist"

#define kDefaultCellHeight          50
#define kDefalutCommentCellHeight   70
#define kMaxForwardCharNum          2000
#define kMaxCommentCharNum          2000
#define kMaxPublishCharNum          2000
#define kMaxMessageCharNum          500

// 动态标题区域
#define kDynamicTitleTextRect       CGRectMake(97, 0, 180, 44)
// 默认标题区域
#define kDefaultTitleTextRect       CGRectMake(50, 0, 220, 44)

#define kSearchViewFrameMid         CGRectMake(0, 142, 320, 274 + 150)
#define kSearchViewFrameTop         CGRectMake(0, -14, 320, 258 + 100)
#define kSearchViewFrameBottom      CGRectMake(0, 358, 320, 274)
#define kSemicircleOrFilmFrame      CGRectMake(0, 0, 320, 368)

#define kSettingViewCenter          CGPointMake(130.0f, 370.0f) 

#define kTabBarItemViewCenter       CGPointMake(160.0f, 325.0f)           //“特效”、“边框”和“位置”选项的View的中心
#define kAutoImgTabBarCenter        CGPointMake(160.0f, 369.0f)           //从自拍页面跳转到图片处理页面的“特效”、“边框”和“位置”选项的View的中心
#define kEditViewCenter             CGPointMake(100.0f, 344.0f)           //“编辑”选项的View的中心
#define kAutoEditViewCenter         CGPointMake(100.0f, 388.0f)           //从自拍页面跳转到图片处理页面的“编辑”选项的View的中心
#define kPositionViewMoveUp         CGPointMake(160.0f, 158.0f)           //点击位置View中的“添加描述”，该View弹到键盘上方
#define kAutoPosViewMoveUp          CGPointMake(160.0f, 202.0f)           //从自拍页面跳转到图片处理页面的点击位置View中的“添加描述”，该View弹到键 
#define kPositionViewMoveDown       CGPointMake(160.0f, 325.0f)           //位置信息“添加描述”完毕，该View回到原来的位置
#define kCutOkButtonSize            CGRectMake(255, 440, 55, 30)          //剪切时的“确定”按钮的大小
#define kCutCancelButtonSize        CGRectMake(10, 440, 55, 30)           //剪切时的“取消”按钮的大小
#define kBackgroundButtonSize       CGRectMake(0, 430, 320, 50)           //背景大按钮的大小

#define kAvatarCornerRadius         3.0
#define kAnimationViewInterval      0.3

#define kImageEffectButtonRect     CGRectMake(10.0f, 10.0f, 44.0f, 44.0f) //图片处理scrollView中button大小
#define kImageEffectLabelRect      CGRectMake(2.0f, 55.0f, 60.0f, 20.0f)  //图片处理scrollView中Label大小
#define kImageEffectSubViewRect    CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)   //图片处理scrollView中View大小
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kImageEffectButtonTagBase  1024
#define kDraggableFrameMaxHeight  410.0                                   //图片剪切时的最大高度
#define kDraggableFrameMaxWidth   320.0                                   //图片剪切时的最大宽度
#define kImageProcessMaxWidth     320.0                                   //图片处理页面图片的最大高度
#define kImageProcessMaxHeight    368.0                                   //图片处理页面图片的最大高度
#define kScrollViewPointY         75                                      //图片处理页面ScrollViews的Y坐标
#define kScrollViewLabelPointY    55                                      //图片处理页面ScrollView中Label的Y坐标
#define kScrollViewLabelWidth     60                                      //图片处理页面ScrollView中Label的高度
#define kScrollViewLabelHeight    20                                      //图片处理页面ScrollView中Label的宽度
#define kScrollViewButtonPointY   10                                      //图片处理页面ScrollView中Button的Y坐标
#define kScrollViewButtonWidth    44                                      //图片处理页面ScrollView中Button的宽度
#define kScrollViewButtonHeight   44                                      //图片处理页面ScrollView中Button的高度
#define kScrollViewLabelWordSize  14.0f                                   //图片处理页面ScrollView中Label中的字体的大小
#define kImgViewCenter            CGPointMake(160, 228)

#pragma mark - For Message
//Message Define


#pragma mark - For Contact
//Contact Define


#pragma mark - For Myprofile 
//Myprofile Define
#define kFontOfTime                       14
#define kFontOfButton                     12
#define kFontOfText                       18
#define kHeightOfRows                     60
#define kDeleteTag                        1000
#define kClearTag                         1001
#define ksDefaultcapacity                 10
#define kNumberOfSection                  4			//详细资料要求只显示4项
#define kHeaderRowHeight                  290.0

#define kNumberOfHeaderSection            6
#define kSectionNumOfHeader               1
#define NumberOfComponents                2

#define kHeaderLabelTag                   6001
#define kLabelTag                         6002
#define kDatePickerTag                    6003
#define kImageActionSheet                 6004
#define kBirthdayActionSheet              6005
#define kSelectCareerActionSheet          6006
#define kChangeImageActionSheet           6007
#define kCareerPickerTag                  6008

#define kPickerCareerComponent            0
#define kPickerCareerDetailedComponent    1

#define kLimitText                        30
#define kPhoneNumberLimitLength           24
#define kChineseFont                      12
#define kEnglishFont                      12
#define kTextFieldFont                    14

#define kFont20                           20            
#define kFont17                           17
#define kFont11                           11
#define kFont16                           16
#define kFont15                           15
#define kFont12                           12
#define kTitleTextColor                   33.0/255
#define kTextColor                        66.0/255
#define kTextLabelAlpha                   1.0
#define kChineseStatusIconFrame           285
#define kEnglishStatusIconFrame           288

#define kNumberLabelTag                   8001
#define kTextLabelTag                     8002
#define kStatusActionSheetTag             8003
#define kHeaderImageActionSheetTag        8004
#define kLoginIndicatorTag                8005
#define kHeaderLabelTags                  8006
#define kNewBackgroundImageTag            8007
#define kNewUnreaderLabelTag              8008

#define kSectionCounts                    1
#define kRowCounts                        6
#define kRowHeight                        45
#define kSectionHeaderHeight              160
#define kMyProfileTab                     3
#define kSignatureRowIndex                0
#define kTopicRowIndex                    4
#define kDraftRowIndex                    5

#define kAlertHiddenInTime                3.0f


#define kStartIndex                       0
#define kheaderImageSize                  100
#define kSizeOfNumberLabel                CGRectMake(8, 4, 10, 10)
#define kSizeOfImageLabel                 CGRectMake(50, 1, 22, 22)
#define kSizeOfToolBar                    CGRectMake(0, 0, 320, 50)
#define kSizeOfButton                     CGRectMake(0, 0, 67, 31)
#define kSizeOfTableviewBefore            CGRectMake(0, 0, 320, 372)
#define kSizeOfTableviewAfter             CGRectMake(0, 0, 320, 416)
#define kIndicatorCenter                  CGPointMake(142.0f, 73.0f)
#define kNumberOnButtonFrame              CGRectMake(0, 5, 75, 20)
#define kTextOnButtonFrame                CGRectMake(0, 25, 75, 20)
#define kLoginStatueFrame		          CGPointMake(245, 40)
#define kSignatureLabelFrame              CGRectMake(85, 13, 160, 20)
#define kEnglishSignatureLabelFrame       CGRectMake(130, 13, 160, 20)
#define kTopicLabelFrame                  CGRectMake(85, 11, 200, 20)
#define kEnglishTopicLabelFrame           CGRectMake(100, 11, 200, 20)
#define kDraftLabelFrame                  CGRectMake(85, 13, 200, 20)
#define kHeaderEditLabelFrame             CGRectMake(0, 45, 60, 15)

#pragma mark - For More 
//Application Define
#define kBackupIndicatorTag               5001
#define kBackupLabelTag                   5002
#define kBackupAlertTag                   5003
#define kRecoverAlertTag                  5004
#define kFinishAlertTag		              5005

#define kSectionNumbers                   1
#define kRowNumbersListview3              3     
#define kRowNumbersListview2              2
#define kRowNumbersListview1              1
#define kFontSizes                        12
#define kHeightOfRowss                    102
#define kHeightOfView                     416
#define kPhotoSize                        CGSizeMake(64.f,64.f)
#define kButtonSize                       CGRectMake(0,0,64,64)
#define kLabelSize                        CGRectMake(-16,68,95,25)
#define ALPHA                             1.
#define kSettingSectionCount              3
#define kFontSubtitle                     12
#define kFontTitle                        16.0
#define kSwitchButtonHeight               30
#define kSettingListTableRowHeight        50
#define kSettingListTableRowHeightOther   55
#define kSettingListTableRowHeightSpecial 60
#define kSwitchButtonWidth                100
#define RED                               220.
#define GREEN                             223.
#define BLUE                              229.
#define RGB                               255
#define kNumberOfSectionsInTableView      2
#define kSizeOfFont                       16.0
#define kHeightForRowAtIndexPath          50
#define kAnimationCenter                  142.f, 73.f
#define MAXNUMBER                         100.0
#define MINNUMBER                         0.0
#define MIDDLEVALUE                       50.0
#define NUMBEROFROW                       4
#define NumberOfRowsInSection             2
#define NUMBEROFSECTION                   1
#define WIDTH                             260
#define HEIGHT                            50
#define kSizeOfCutButton                  CGRectMake(235.0f, 10.0f, 60.0f, 30.0f)
#define kSizeOfLabel                      CGRectMake(230.,16.,50.,20.)
#define kRequestTimeDelay                 1.2f
#define kSuccessTimeDelay                 0.5f

#define kTextHide                         0
#define kTextShow                         100
#define KStartTag                         1000
#define kSyncAccountListTableRowHeight    60
#define kSyncAccountSectionCount          1
#define syncSnsNumber                     5
#define kUnSynchronized                   0
#define kSynchronized                     1

#define kFontSizes14                      14
#define kFontSize17                       17
//#define kFontSize16                       16

#define KDelButtonX                       0
#define KDelButtonY                       0
#define KDelButtonWidth                   52
#define KDelButtonHeight                  31

#pragma mark - For Settings

//Private Setting Define
#define kSectionNumInSetting          6   //隐私设置主页面有6个分区
#define kSectionNumber                1   //隐私设置3个子页面都只有一个分区
#define kRowsNumInSetting             1   //隐私设置主页面每个分区只有一行
#define kRowsNumberInContact          3   //联系人公开页面有三行
#define kRowsNumberInCard             3   //名片公开页面有三行
#define kRowsNumberInMicroblog        2   //微博公开页面有两行
#define kRowOfSection_0               0   //子页面分区中的第一行
#define kRowOfSection_1               1   //子页面分区中的第二行
#define kRowOfSection_2               2   //子页面分区中的第三行
#define kHeightForRow                 44  //每个cell的高度
#define kSwitch_x                     205 //开关的横坐标位置
#define kSwitch_y                     9   //开关的纵坐标位置
#define kWordSize                     16.0  //字号
#define kNumOfLinesInCell_0           0   //文字过多时换行显示
#define kSectionForMicroblog          3   //隐私设置主页面微博公开行号
#define kSectionForCard               4   //隐私设置主页面名片公开行号
#define kSectionForContactWay         5   //隐私设置主页面联系方式公开行号
#define kAlertSize                    CGRectMake(20, 200, 280, 100) 
#define kAlertMessageLabelSize        CGRectMake(10, 10, 260, 40)

//For Login
#define kWindowWidth                  320.0f
#define kWindowHeight                 460.0f
#define kGuideImgHeight               275.0f
#define kStartPointY                  0.0f
#define kNumberOfGuidePage            4
#define Register_View_Point           CGPointMake(0, 480)
#define kRegView                      CGRectMake(0, 0, 320, 460)            //注册页面的view
#define kAlertIndicatorCenter         CGPointMake(160.f, 305.f)             //登陆我聊页面中转圈控件的中心
#define kLoginTextFrame               CGRectMake(10.f, 250.f, 300.f,30.f)   //“正在登陆请稍候⋯”的文字
#define kSendMessageIndicator         CGRectMake(70, 70, 20, 20)            //发送验证短信时的转圈控件
#define kCheckPhoneNumAlert           CGRectMake(20, 200, 280,100)          //验证手机号页面Alert框大小
#define kCheckPhoneNumMsgLabel        CGRectMake(20, 10, 240, 40)           //验证手机号页面Alert框中MessageLabel大小 
#define kCheckPhoneNumIndicator       20                                    //验证手机号页面Alert框中转圈动画纵坐标
#define kCompleteRegAlert             CGRectMake(20, 200, 280,100)          //完成注册页面Alert框大小
#define kCompleteRegMsgLabel          CGRectMake(10, 10, 260, 40)           //完成注册页面Alert框中MessageLabel大小
#define kCompleteRegIndicator         20                                    //完成注册页面Alert框中转圈动画纵坐标

#define kDefaultTableFontPointSize    16.0

#define FileIsExists(filePath) [[NSFileManager defaultManager] fileExistsAtPath:filePath]






