//////////////////////////////////////////////////////////////////////////  
///                         COPYRIGHT NOTICE  
///
/// Copyright (c) 2011, CIeNET Technologies  
/// All rights reserved.  
///  
/// @file  TextConstant.h
/// @brief  全局文本常量定义.
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
#import "ARCMacro.h"
#define RELEASE_OBJECT(obj) {[obj RELEASE]; obj=nil;}

#pragma mark - For Dynamic 
//Dynamic Define

#define kTextUid              @"uid"
#define kTextPageNo           @"pageno"
#define kTextMode             @"mode"
#define kTextAndroid          @"android"
#define kTextItemCount        @"itemcount"
#define kTextName             @"name"
#define kTextLink             @"link"
#define kTextModule           @"module"
#define kTextBlogCellView     @"BlogCellView"
#define kTextLogoImage        @"LogoImage"
#define kTextBlogImage        @"BlogImage"
#define kTextViewerID         @"viewerID"
#define kTextFeedId           @"feedId"
#define kTextResultCode       @"resultCode"
#define kTextCache            @"Cache"
#define kTextRequestId        @"requestId"
#define kTextCallbackPageUrl  @"callbackPageUrl"
#define kTextCallbackImgUrl   @"callbackImgUrl"

#define kKeyFeedId            @"feedID"
#define kKeyRspData           @"rspData"

#define kCameraimage                 @"cameraimage"
#define kType                 @"type"
#define kFilePath             @"filePath"
#define kDescription          @"description"
#define kPublicImage          @"public.image"
#define kPosition             @"position"
#define kZeroResult           @"zZeroResult"
#define kSuperContentType     @"contentType"
#define kSuperPicture         @"picture"
#define kSuperVideoClips      @"videoClips"
#define kTopicInfo            @"topicInfo"
//For Draft
#define ksTime                @"time"
#define ksDraft               @"draft"
#define ksHelvetica           @"Helvetica"
#define kspurple              @"purple"
#define ksmicroblogType       @"microblogType"
#define kspublish             @"publish"
#define ksforward             @"forward"
#define kscomment             @"comment"
#define ksSaveDraft           @"savedDrafts"
#define kAutoSaveDraft        @"zAutoSaveDraft"
#define kPubFailSaveDraft     @"zPubFailSaveDraft"
#define kFwdFailSaveDraft     @"zFwdFailSaveDraft"
#define kCmtFailSaveDraft     @"zCmtFailSaveDraft"

// For Google Map API JSON Tag
#define kNameJSONTag          @"name"
#define kGeometryJSONTag      @"geometry"
#define kLocationJSONTag      @"location"
#define kLatJSONTag           @"lat"
#define kLngJSONTag           @"lng"



#pragma mark - For Message 
//Message Define
#define KMsgHoldSpeekTag    @"holdspeek"
#define KMsgRecordingTag    @"recording"
#define kMsgAudioMotionTag  @"audioMotion"


#pragma mark - For Contact
//Contact Define


#pragma mark - For Myprofile 
//Myprofile Define


#pragma mark - For More 
//More Define



#pragma mark - For Setting

//Privite Setting Define
//隐私设置页面字符串
#define sBack                     @"mBack"
#define sDone                     @"Done"
#define sRemoveMicroblogView      @"MicroblogPublic View remove"
#define sRemoveCardView           @"CardPublic View remove"
#define sRemoveContactView        @"ContactPublic View remove"
#define sSettingAlert             @"SettingAlert"
#define sSucceed                  @"Succeed"
#define sSettingSuccess           @"SettingSuccess"
#define sFailed                   @"Failed"
#define sSettingFailed            @"SettingFailed"
#define sNetworkError             @"TipsNtwkErr"
#define sFriendListPublic         @"friendListPublic"
#define sMyLocationPublic         @"myLocationPublic"
#define sReceiveStrangerCalls     @"receiveStrangerCalls"
#define sViewMyBlog               @"viewMyBlog"
#define sCardPublic               @"cardPublic"
#define sContactWayPublic         @"contactWayPublic"
#define sYES                      @"YES"
#define sNO                       @"NO"
#define sPrivateSettingIdentifier @"PrivateSettingIdentifier"
#define sFriendList               @"FriendList"
#define sLocationDetails          @"LocationDetails"
#define sStrangerChat             @"StrangerChat"
#define sMicroblogVisible         @"MicroblogVisible"
#define sAll                      @"All"
#define sFriends                  @"Friends"
#define sTopics                   @"Topics"
#define sOnlyMe                   @"OnlyMe"
#define sCardVisible              @"CardVisible"
#define sPrivateSetting           @"PrivateSetting"
#define sCardPublicIdentifier     @"CardPublicIdentifier"
#define sContactPublicIdentifier  @"ContactPublicIdentifier"
#define sMicroblogIdentifier      @"MicroblogIdentifier"

#define sPrivacyInfo              @"PrivacyInfo"
#define sPrivacyValue             @"PrivacyValue"
#define sType                     @"Type"                                                                                             
#define sViewId                   @"&viewId="       
#define sPrivacySettingsInfoRsp   @"PrivacySettingsInfoRsp"                       
#define sFriendstatus             @"friendstatus"             
#define sLocationinfst            @"locationinfst"              
#define sStrangesessionst         @"strangesessionst" 
#define sBlogstatus               @"blogstatus"
#define sCardinfstatus            @"cardinfstatus"              
#define sContactstatus            @"contactstatus"             
#define sUserId                   @"userId="      
#define sPswd                     @"&pswd="     
#define sNetworkId                @"&netWorkID="          
#define sAccId                    @"&accId="      
#define sAccPwd                   @"&accPwd="       
#define sConfigPlist              @"config.plist" 
#define sConfig                   @"config"
#define sCurrentSetting           @"CurrentSetting"
#define sSyncAccountInfo          @"SyncAccountInfo"


//For Microblog
#define mAddDescription             @"zAddDescription"
#define mRetake                     @"zRetake"
#define mChoose                     @"zChoose"       
#define mUse                        @"zUse"    
#define mAddPosition                @"zAddPosition"                           
#define mShare                      @"zShare"       
#define mCancel                     @"zCancel"         
#define mImageProcess               @"zImageProcess"              //图片处理
#define mPhotoProcess               @"zPhotoProcess"              //照片处理
#define mEditButton                 @"EditButton"           
#define mEprettyButton              @"EprettyButton"              
#define mFrameButton                @"zFrameButton"
#define mLocationButton             @"zLocationButton"              
#define mOriginalImage              @"zOriginalImage"
#define mBlackWhite                 @"zBlackWhite"
#define mCartoon                    @"zCartoon"
#define mMemory                     @"zMemory"
#define mScanLine                   @"zScanLine"
#define mBopo                       @"zBopo"
#define mSepia                      @"zSepia"
#define mPosterize                  @"zPosterize"
#define mSaturate                   @"zSaturate"
#define mBrightness                 @"zBrightness"
#define mGamma                      @"zGamma"
#define mContrast                   @"zContrast"
#define mBias                       @"zBias"
#define mNone                       @"zNone"        
#define mWhiteFrame                 @"zWhiteFrame"        
#define mBlackFrame                 @"zBlackFrame"        
#define mSemicircle                 @"zSemicircle"        
#define mFilm                       @"zFilm"        
#define mPlacemarkError             @"zPlacemarkError"                                         


//For Setting
#define  ksSyntorenren              @"sSyntorenren"
#define  ksSyntokaixin              @"sSyntokaixin"
#define  ksSyntoTencent             @"sSyntoTencent"
#define  ksSyntoSina                @"sSyntoSina"
#define  ksnotsupported             @"notsupported"
#define  ksSynctencent              @"sSynctencent"
#define  ksSynckaixin               @"sSynckaixin"
#define  ksRenren                   @"sRenRen"
#define  ksKaixin                   @"sKaixin"
#define  ksSinaBlog                 @"sSinaBlog"
#define  kssUnlock                  @"sUnlock"
#define  ksSynchronized             @"sSynchronized"
#define  ksUnsynchronized           @"sUnsynchronized"
#define  ksSynTableTitle            @"sSynTableTitle"
#define  ksActionsheetTitle         @"sActionsheetTitle"
#define  ksSynchronizeAccount       @"sSynchronizeAccount"
#define  ksSuccess                  @"sSuccess"
#define  kSuccessMark               @"success"
#define  ksFail                     @"sFail"
#define  kLowQualityStr             @"sLowQuality"
#define  kMidQualityStr             @"sMiddleQuality"
#define  kHighQualityStr            @"sHighQuality"
#define  kOriginalQualityStr        @"sOriginalQuality"
#define  CHINESE                    @"Chinese"
#define  ENGLISH                    @"English"
#define  APPLELANGUAGE              @"AppleLanguages"
#define  LANGUAGE                   @"language"
#define  kAddBlacklist              @"cAddBlack"
#define  ksCut                      @"sCut"
#define  kInBlackLists              @"sInBlack"
#define  kBlackLists                @"sBlackLists"
#define  kisDeleting                @"isDeleting"
#define  kMicroblogImageQuality     @"microblogimageQuality"
#define  kMessageImageQuality       @"messageimageQuality"
#define  kSimpleTableIdenty         @"SimpleTableIdentifier"
#define  kRemindMethod              @"sRemindMethod" 
#define  kMicroBlogImageSet         @"microBlogImageSet"
#define  kMessageImageSet           @"messageImageSet"
#define  kAddLink                   @"mAddLink"
#define  kPrivate                   @"mPrivate"
#define  kSynchronismNum            @"mSynchronismNum"
#define  kBlackList                 @"cBlackList"
#define  kLanguageSetting           @"LanguageSetting"
#define  kSetting                   @"Setting"
#define  kSettingCellIdenty         @"SettingCellIdentifier"
#define  kDetail                    @"sDetail"
#define  kSynchronism               @"sSynchronism"
#define  kBlacklistTips             @"sBlacklistTips"
#define  ksChinese                  @"sChinese"
#define  ksEnglish                  @"sEnglish"
#define  ksSystem                   @"sSystem"
#define  ksChinesesimplifiedFont    @"zh-Hans"
#define  ksChineseTraditionFont     @"zh-Hant"
#define  ksEnglishFont              @"en"
#define  ksInfoRemind               @"sInfoRemind"
#define  ksPrivateAccount           @"sPrivateAccount"
#define  ksCommon                   @"sCommon"
#define  kcdevelop                  @"cdevelop"
#define  ksIKnow                    @"cIknow"
#define  ksAddSuccess               @"sAddSuccess"
#define  LANGUAGEPROFILE            @"config.plist"
#define  AVAILABLELANGUAGEFLAG      @"AvailableLanguage"
#define	 CURRENTLANGUAGEFLAG        @"CurrentSetting"
#define  LANGUAGE                   @"language"
#define  Sina                       @"sina"
#define  Tencent                    @"tencent"
#define  Renren                     @"renren"
#define  Kaixin                     @"kaixin"
#define  SinaMark                   @"Sina"
#define  TencentMark                @"Tencent"
#define  RenrenMark                 @"Renren"
#define  KaixinMark                 @"Kaixin"
//For MyProfile 
#define MyProfileTitle              @"mMyProfileTitle"
#define  kmBack                     @"mBack"
#define  ksCancel                   @"Cancel"
#define  ksSOK                      @"sOK"
#define  ksClear                    @"sClear"
#define  ksDelete                   @"zDelete"
#define  ksEdit                     @"zEdit"
#define  ksDrafts                   @"sdraft"

#define  ksContacts                 @"contacts"
#define  ksWilldelete               @"willdelete"
#define  ksSureclear                @"ssureclear"
#define  kDraftCell                 @"DraftCell"
#define  kDraftCellIdenty           @"DraftCellIdentifier"
#define  kLeftParentheses           @"("
#define  kRightParentheses          @")"

//For Login
#define kNext                       @"next"
#define kFinish                     @"sFinish"
#define kWait                       @"Waitting" 
#define kSignRegister               @"signRegister"
#define kPassWord                   @"PassWord"         
#define kNickName                   @"nicknameTxt"                            
#define kSex                        @"sexTxt"    
#define kFinishReg                  @"finishReg"          
#define kSetPassword                @"regPwdHint"             
#define kSetNickName                @"enterNickTips"            
#define kMale                       @"sexMale"     
#define kFemale                     @"sexFemale"       
#define kNickNameError              @"NicknameInputError"  
#define kNameRestrict               @"nameRestrict"
#define kAccountRestrict            @"accountRestrict"
#define kInitalize                  @"initalize"          
#define kSMale                      @"1"  
#define kSFemale                    @"2"
#define kGuideOneTxt                @"GuideOneTxt"
#define kGuideTwoTxt                @"GuideTwoTxt"
#define kGuideThreeTxt              @"GuideThreeTxt"
#define kGuideFourTxt               @"GuideFourTxt"
#define kFirstMicroBlog             @"zFirstMicroBlog"
#define kChooseCountry              @"ChooseCountry"
#define kCountryName                @"CountryName"
#define kPlist                      @"plist"      
#define kSelectCountry              @"HintSelectCountry"              
#define kRemoveCtrySelectView       @"selectcountry View remove"                            
#define kCtrySelectDisappear        @"countrySelection disappear" 
#define kAccout                     @"Accout"                            
#define kPassword                   @"PassWord"         
#define mOK                         @"mOK"   
#define kLoginLabel                 @"loginingLabel"             
#define sAccount                    @"account"        
#define sPassword                   @"password"         
#define kChangePassword             @"mChangePassword" 
#define kChangeAccount              @"mChangeAccount"
#define kChooseCtryController       @"ChooseCountryViewController"                   
#define kCountryNum                 @"CountryNumber"
#define kCountry                    @"country"
#define kCtryName                   @"countryName"          
#define kResizeKeyboard             @"ResizeForKeyboard"                            
#define kChecking                   @"Makingsure"           
#define kAvailability               @"Availability"             
#define kCancel                     @"cCancel"       
#define kProtocol                   @"UserProtocolViewController"           
#define kPassSex                    @"passSex"        
#define kSelectSexRemove            @"selectsex View remove"           
#define kSexSelectionDisappear      @"sexSelection disappear"                      
#define kReset                      @"mReset"
#define kTXTnewVersionFind          @"newVersionFind"
#define kTXTnewForceVersionFind     @"newForceVersionFind"
#define knewVersionCancel           @"newVersionCancel"
#define knewVersionUpdate           @"newVersionUpdate"
#define knewVersionNextTime         @"newVersionNextTime"
#define knewVersionUpdateNow        @"newVersionUpdateNow"
#define knumIsRegistered            @"numIsRegistered"
#define kpwdRestrict                @"pwdRestrict"
#define kpwdLength                  @"pwdLength"
#define kPWdNotEmpty                @"PWdNotEmpty"
#define kNameContent                @"nameContent"
#define kNameShort                  @"nameShort"
#define kBothShort                  @"bothShort"
#define kPwdcontent                 @"pwdcontent"

#pragma mark login http resquest fields
//for login tpf request
#define kRqDicUid                   @"uid"
#define kRqDicType                  @"type"
#define kRqDicPassword              @"password"
#define kRqDicVersioninfo           @"version_info"
#define kRqDicEnginever             @"engine_version"
#define kRqDicEngineid              @"engine_id"
#define kRqDicScreen                @"Screen"

#define kRqDictReturnCode           @"returnCode"
#define kRqDictMsg                  @"msg"
#define kRqDictDsmId                @"dsmId"
#define kRqDictNewengine            @"new_engine"
#define kRqDictStatus               @"status"
#define kRqDictVersion              @"version"
#define kRqDictUrl                  @"url"

//返回的升级信息字段含义
#define kRqHasNewVersion            @"0"
#define kRqMustUpdateVersion        @"3"
#define kRqNoNewVersion             @"1"
#define kRqSystemError              @"-1"

//手机号，需要带“+”号和国家码
#define kRqValueTypeMobileNumber    @"0"
#define kRqValueTypeEmail           @"9"
#define kRqValueTypeDSMID           @"10"
#define kRqValueEngineId            @"iPhone_dsm_waka"
#define kRqValueScreen              @"640*960"

//自拍页面
#define kPhotoNum                   @"photoNum"
#define kPhotoInterval              @"photoInterval"
#define kSpeedSlow                  @"speedSlow"
#define kSpeedMid                   @"speedMid"
#define kSpeedFast                  @"speedFast"
#define kNumIOS5_1246               @" 1         2          4          6"
#define kNumIOS4_1246               @" 1             2              4             6"
#define kPhotograph                 @"Photograph"
#define kSettingFrame               CGPointMake(113.0f, 360.0f)
#define kaSwitch                    @"aSwitch"









