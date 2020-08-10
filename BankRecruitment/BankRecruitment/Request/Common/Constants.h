//
//  Constants.h
//  iPhoneDSM
//
//  Created by Yang Zhao on 7/5/11.
//  Copyright 2011 Hua Wei. All rights reserved.
//

#define kPI                         3.1415926
#define kImageCompressRatio         0.04
#define kCornerToRadius             6.0

#define kFontSize18                 18.0f
#define kFontSize16                 16.0f
#define kFontSize14                 14.0f
#define kFontSize13                 13.0f
#define kFontSize12                 12.0f
#define kFontSize11                 11.0f

#define kTopGapHeight               10.0f       // 上边距
#define kLeftGapWidth               10.0f       // 左边距
#define kCustomGapHeight            10.0f       // 元素间距
#define kGapHeightOffset            5.0f
#define kContentTextWidth           300.0f      // 默认文本显示宽度
#define kCellContentMargin          5.0f

#define kCellNickHeight             20.0f
#define kCellCustomGapHeight        10.0f
#define kContentLabelPosX           10.0f
#define kContentLabelWidth          300.0f

#define kTimeLabelPosX              10.0f
#define kTimeLabelPosX              10.0f
#define kTimeLabelWidth             90.0f

#define kSourceLabelPosX            80.0f
#define kSourceLabelWidth           90.0f
#define kSourceLabelHeight          15.0f
#define kCommentNumLabelHeight      10.0f

#define kRtNumLabelPosX             240.0f
#define kRtNumLabelWidth            30.0f
#define kRtNumLabelHeight           10.0f

#define kForwardImageViewPosX       222.0f
#define kSmalImageViewWidth         11.0f // 13
#define kSmalImageViewHeight        11.0f // 12
#define kCommentContentPosX         60.0f
#define kCommentContentWidth        240.0f
#define kReplyImageWidth            11.0
#define kReplyImageHeight           11.0

#define kMBlogContentPicWidth       300.0f
#define kMBlogContentRightGap       310.0f
#define kMBlogContentRtPicWidth     270.0f

#define kMBlogForwardTextWidth      270.0f

#define kRtContentOffsetPosY        5.0f        // 调整转发文本在背景图片的Y方向的偏移

#define kMBlogRtContentPosX         25.0f       // 回复文本的内容X

#define kCommentLabWidth            150.0f
#define kCommentLabHeight           20.0f

#define kBackgroundColor [UIColor colorWithRed:241.0/255.0 green:232.0/255.0 blue:210.0/255.0 alpha:1.0]

// For SelectedContactViewControllerDelegate
#define kUid                        @"uid"
#define kFullName                   @"fullname"
#define kIsSelectedContact          @"isSelectedContact"
#define kContactInfoArray           @"contactInfoArray"

#define kTagDownload_Path           @"path"
#define kTagDownload_Name           @"name"
#define kTagDownload_Link           @"link"
#define kTagDownload_Module         @"module"
#define kTagDownload_Observer       @"observer"

#define kMBlogContentPortrait       @"MBlogContentPortrait"
#define kMBlogContentPic            @"MBlogContentPic"
#define kMBlogContentRtPic          @"MBlogContentRtPic"
#define kMBlogContentSmallPic       @"MBlogContentSmallPic"
#define kMBlogContentRtSmallPic     @"MBlogContentRtSmallPic"

#define kMBlogContentCmPortrait     @"MBlogContentCommentPortrait"
#define kFirstRegTips               @"zFirstRegTips"
#define kPeopleAroundModuleName     @"Around_People_Header"
#define kmDynamic                   @"mDynamic"
// 保存字典标志
#define kTagTitle @"title"
#define kTagImage @"image"
#define kTagDescription @"description"

#pragma mark - View constants

#define kMutableCapability          4           // 表的默认粒度
#define kCommentNumPerPage          15          // 每页显示的评论数

#define kItemCountPerPage           10
#define kUpdateActionCellHeight     50
#define kMaxCachePageNum            1
#define kLoadTimeoutValue           120