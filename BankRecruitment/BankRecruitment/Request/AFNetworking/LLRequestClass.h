//
//  LLRequestClass.h
//  ZhiLi
//
//  Created by 夏建清 on 2017/1/10.
//  Copyright © 2017年 xia jianqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLRequestClass : NSObject
//发起POST请求直接调用
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure;

//发起GET请求直接调用
+ (void)getWithURL:(NSString *)url success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取数据类别
 */
+ (void)requestGetTypeByIType:(NSString *)IType success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 开机广告图片
 */
+ (void)requestBootScrollPicsBysuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 登录
 */
+ (void)requestLoginByPhone:(NSString *)phone Password:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 重设密码
 */
+ (void)requestResetPassWordByPassword:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 修改昵称
 */
+ (void)requestmodifyNameByPet:(NSString *)Pet success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 短信验证码
 */
+ (void)requestSMSByPhone:(NSString *)phone type:(NSString *)type success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 注册
 */
+ (void)requestRegisterByPhone:(NSString *)phone Password:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 找回密码
 */
+ (void)requestFindPasswordByPhone:(NSString *)phone Password:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取所有广告
 */
+ (void)requestGetAllAdBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取试卷
 */
+ (void)requestdoGetExaminByTypeInfo:(NSString *)TypeInfo Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取首页目录提纲
 */
+ (void)requestdoGetFirstBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取模考试题目录提纲
 */
+ (void)requestdoGetMockOutlineByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 根据试卷提纲获取已经做的试题列表(已做练习明细)
 */
+ (void)requestdoGetOutlineTitleHisByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 刷新题纲及子题纲信息
 */
+ (void)requestdoGetFreOutlineByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取试卷试题列表
 */
+ (void)requestGetExamTitleByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取试卷试题列表  返回前50条数据，是没做的或错的试题
 */
+ (void)requestGetExamTitleExByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 根据试卷提纲获取试题列表
 */
+ (void)requestGetOutlineTitleByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 根据试卷提纲获取试题列表
 action=doOutlineTitleEx&uid=25&OID=324&NPage=1&tCount=10
 */
+ (void)requestGetOutlineTitleExByOID:(NSString *)OID tCount:(int)tCount Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取题目信息
 http://120.26.198.113/bshApp/AppAction?action=doGetTitles&idlist=[{"TitleID":"35"},{"TitleID":"36"},{"TitleID":"38"},{"TitleID":"39"}]
 */
//+ (void)requestGetExamDetailsByTitleList:(NSArray *)titleList Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取试卷题目明细信息
 http://120.26.198.113/bshApp/AppAction?action=doGetExaminTitles&uid=0&idlist=[{"ID":"5"},{"ID":"6"},{"ID":"7"}]
 */
+ (void)requestGetExamDetailsByTitleList:(NSArray *)titleList Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取智能练习、组卷的题目列表明细信息
 http://120.26.198.113/bshApp/AppAction?action=doGetPractTitles&uid=0&idlist=[{"ID":"5"},{"ID":"6"},{"ID":"7"}]
 */
+ (void)requestGetIntelligentExamDetailsByTitleList:(NSArray *)titleList Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 试卷提交答题卡
 */
+ (void)requestSubmitExamResultBySlist:(NSMutableArray *)slist Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 智能练习、智能组卷提交答题卡
 */
+ (void)requestSubmitIntelligentExerciseResultBySlist:(NSMutableArray *)slist Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 收藏信息提交
 */
+ (void)requestPutFavoriteByLinkID:(NSString *)LinkID FType:(NSString *)FType Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 取消收藏信息
 */
+ (void)requestDeleteFavoriteByLinkID:(NSString *)LinkID FType:(NSString *)FType Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取收藏列表
 */
+ (void)requestGetFavoriteListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 提交笔记
 */
+ (void)requestPutNoteByID:(NSString *)ID Note:(NSString *)Note Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取笔记
 */
+ (void)requestGetNoteByID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 删除笔记
 */
+ (void)requestDeleteNoteByID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取笔记题目
 */
+ (void)requestGetNoteTitlesBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 学生提交试题纠错信息
 */
+ (void)requestPutExaminTitleErrByID:(NSString *)ID intro:(NSString *)intro Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 学生提交智能纠错信息
 */
+ (void)requestPutPractTitleErrByID:(NSString *)ID intro:(NSString *)intro Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取错题信息
 */
+ (void)requestGetErrorExamsByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取视频分类
 */
+ (void)requestGetVideoTypeBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取视频目录
 */
+ (void)requestGetVideoCatalogListByType:(NSString *)VType Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取视频列表
 */
+ (void)requestGetVideoListByCatalog:(NSString *)Catalog Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 首页广告（视频）跳转到第二页 使用ID 获取类型和章节
 */
+ (void)requestGetADVideoCatalogListByID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取直播课列表
 */
+ (void)requestGetAllLiveListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取直播课课程表
 */
+ (void)requestGetLiveScheduleListByLID:(NSString *)LID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取会员课程日程
 */
+ (void)requestGetUserLiveScheduleListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取会员已经购买的直播课列表
 */
+ (void)requestGetUserBuyedLiveListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取直播课教室
 */
+ (void)requestGetLiveClassRoomBySID:(NSString *)SID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取直播课老师信息
 */
+ (void)requestGetLiveTecherInfoByLID:(NSString *)LID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取当前收费类项目，是/否已经支付
 */
+ (void)requestGetDoIsPayByid:(NSString *)ID type:(NSString *)type Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取支付sign
 */
+ (void)requestGetPayInfoBytype_pay:(NSString *)type_pay type:(NSString *)type ID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 支付成功 向后台回传
 */
+ (void)requestSendPaySuccessById:(NSString *)Id LinkID:(NSString *)LinkID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 提交支付信息  价格为零时，添加到已购买的数据库
 */
+ (void)requestSendZeroPaySuccessByLinkID:(NSString *)LinkID PType:(NSString *)PType Abstract:(NSString *)Abstract Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 提交支付信息  苹果内购，添加到已购买的数据库
 */
+ (void)requestSendApplePaySuccessByLinkID:(NSString *)LinkID Fee:(NSString *)Fee PType:(NSString *)PType Abstract:(NSString *)Abstract Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 新建智能练习取题
 */
+ (void)requestGetPractIntelligentExerciseListByQPoint:(NSString *)QPoint Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 新建智能组卷取题
 */
+ (void)requestGetIntelligentExamListByContent:(NSString *)Content Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取历史智能
 */
+ (void)requestGetHistoryIntelligentListSuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取智能练习、组卷的题目列表
 */
+ (void)requestGetHistoryPractTitleListByPID:(NSString *)PID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取历史智能组卷
 */
+ (void)requestGetHisExPractListSuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取APP参数 获取首页做题n题：FirstCnt  首页提纲n题：OutlineCnt   ；客户端限制取得的数量显示出来
 */
+ (void)requestGetParamBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取订购信息
 */
+ (void)requestGetPurchListByPType:(NSString *)PType Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取数据报告
 */
+ (void)requestGetDataReportByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 题库搜题
 */
+ (void)requestGetSearchListByKeyWord:(NSString *)KeyWord NPage:(int)NPage Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 提交消息令牌
 */
+ (void)requestdoPutMsgTokenBytoken:(NSString *)token Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 根据ID获取获取明细
 */
+ (void)requestdoGetAdvDetailBytitle:(NSString *)title path:(NSString *)path Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取所有模考大赛信息
 */
+ (void)requestdoGetAllMockBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取模考报名信息
 */
+ (void)requestdoGetMockSignBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 提交模考报名信息
 帐号ID  ：uid
 报名时间：sDate
 模考ID  ：MockID
 省      ：Province
 市      ：City
 银行分类：Bank
 分行    ：subBank
 报考职位：job
 */
+ (void)requestdoPutMockSignByDict:(NSDictionary *)dict Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 根据课程的ID获取直播课的详细信息
 */
+ (void)requestdoGetLiveInfoBySID:(NSString *)SID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 我的消息列表
 */
+ (void)requestGetMyMessageByNPage:(int)NPage tCount:(int)tCount Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 招聘列表
 http://120.26.198.113/bshApp/AppAction?action=doGetInfo&KeyWord=&NPage=1&tCount=10
 */
+ (void)requestGetZhaopinByNPage:(int)NPage tCount:(int)tCount Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 增改收货地址
 */
+ (void)requestPutAddressByName:(NSString *)Name Tel:(NSString *)Tel Addr:(NSString *)Addr Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 查询收货地址
 */
+ (void)requestGetAddressBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 根据试卷提纲获取已经做的试题列表(已做练习明细)
 */
+ (void)requestGetOutlineTitleHisByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 上传直播课日志
 */
+ (void)requestUploadLiveScheduleLogBySID:(NSString *)SID Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 每日签到接口
 */
+ (void)requestSignAppSuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取打卡记录
 */
+ (void)requestGetSignAppListSuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 根据时间段，获取所有的每日一练
 */
+ (void)requestGetExamDayBybegin:(NSString *)begin end:(NSString *)end Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取游客号
 */
+ (void)requestGetVisitorSuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 游客转正
 */
+ (void)requestUpdateVisitorByVid:(NSString *)vid uid:(NSString *)uid Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 获取资讯
 Type：资讯类别名称（可为空）
 NPage：页数  从0 开始
 tCount：一页多少条
 */
+ (void)requestGetNewsByType:(NSString *)Type NPage:(int)NPage Success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 首页获取模块
 */
+ (void)requestGetFirstPageModuleBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 微信注册
 unionid：微信唯一ID
 nickname：微信昵称
 */
+ (void)requestRegisterWXByunionid:(NSString *)unionid nickname:(NSString *)nickname success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
苹果登录
unionid：苹果唯一ID
nickname：苹果昵称
*/
+ (void)requestRegisterAppleByunionid:(NSString *)unionid nickname:(NSString *)nickname success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 微信登录 注册手机号码
 mobile：手机号码
 uid：由微信注册接口 传回来的UID
 */
+ (void)requestCheckWXBymobile:(NSString *)mobile uid:(NSString *)uid success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
获取首页招聘信息
*/
+ (void)requestdoGetApplicationBySuccess:(HttpSuccess)success failure:(HttpFailure)failure;
@end

