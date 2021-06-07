//
//  JMDefineEventName.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import UIKit

let kReuseCellIdentifier = "com.folioreader.Cell.ReuseIdentifier"
let kReadMenuEventNameNone = "com.folioreader.Cell.ReuseIdentifier"

public let kEventNameWebTapGestureAction = "kEventNameWebTapGestureAction"

// TODO: ----- menuView上基本消息名称
/// 点击中部1/2切换显示隐藏状态
public let kEventNameMenuActionTapAction = "kEventNameMenuActionTapAction"
/// 点击左侧1/4翻页
public let kEventNameMenuActionTapLeft = "kEventNameMenuActionTapLeft"
/// 点击右侧1/4翻页
public let kEventNameMenuActionTapRight = "kEventNameMenuActionTapRight"
/// 向左⬅️轻扫翻页
public let kEventNameMenuActionSwipeLeft = "kEventNameMenuActionSwipeLeft"
/// 向右👉轻扫翻页
public let kEventNameMenuActionSwipeRight = "kEventNameMenuActionSwipeRight"
/// 返回
public let kEventNameMenuActionBack = "kEventNameMenuActionBack"
/// 分享
public let kEventNameMenuActionShare = "kEventNameMenuActionShare"
/// 添加书签🔖
public let kEventNameMenuActionAddTag = "kEventNameMenuActionAddTag"
/// 听书
public let kEventNameMenuActionListenBook = "kEventNameMenuActionListenBook"
/// 进度
public let kEventNameMenuActionProgress = "kEventNameMenuActionProgress"
/// 下一章
public let kEventNameMenuActionNextCharpter = "kEventNameMenuActionNextCharpter"
/// 上一章
public let kEventNameMenuActionPrevCharpter = "kEventNameMenuActionPrevCharpter"
/// 跳到指定章
public let kEventNameMenuActionTargetCharpter = "kEventNameMenuActionTargetCharpter"
/// 更多
public let kEventNameMenuActionMore = "kEventNameMenuActionMore"
/// 目录
public let kEventNameMenuActionBookCatalog = "kEventNameMenuActionBookCatalog"
/// 夜间模式
public let kEventNameMenuActionDayOrNight = "kEventNameMenuActionDayOrNight"
/// 亮度
public let kEventNameMenuActionBrightness = "kEventNameMenuActionBrightness"
/// 亮度系统亮度
public let kEventNameMenuBrightnessSystem = "kEventNameMenuBrightnessSystem"
/// 亮度护眼模式
public let kEventNameMenuBrightnessCareEye = "kEventNameMenuBrightnessCareEye"
/// 亮度滑杆
public let kEventNameMenuActionBrightSliderValue = "kEventNameMenuActionBrightSliderValue"
/// 设置更多
public let kEventNameMenuActionSettingMore = "kEventNameMenuActionSettingMore"

/// 翻页类型
public let kEventNameMenuPageFlipType = "kEventNameMenuPageFlipType"

/// 字体类型
public let kEventNameMenuFontType = "kEventNameMenuFontType"
/// 字体大小滑杆
public let kEventNameMenuFontSizeSlider = "kEventNameMenuFontSizeSlider"
/// 滑杆改变值大小
public let kEventNameMenuSliderValueChange = "kEventNameMenuSliderValueChange"
/// 颜色
public let kEventNameMenuPageBkgColor = "kEventNameMenuPageBkgColor"
/// 播放进度
public let kEventNameMenuPlayBookRate = "kEventNameMenuPlayBookRate"
/// 播放暂停
public let kEventNameMenuPlayBookPlay = "kEventNameMenuPlayBookPlay"
/// 播放开始
public let kEventNameMenuPlayBookPrev = "kEventNameMenuPlayBookPrev"
/// 播放停止
public let kEventNameMenuPlayBookNext = "kEventNameMenuPlayBookNext"
/// 设置播放风格
public let kEventNameMenuPlayBookStyle = "kEventNameMenuPlayBookStyle"

/// 横向滚动
public let kEventNameMenuPageHoriScroll = "kEventNameMenuPageHoriScroll"
/// 横向翻页
public let kEventNameMenuPageHoriCurl = "kEventNameMenuPageHoriCurl"
/// 竖向滚动
public let kEventNameMenuPageVeriScroll = "kEventNameMenuPageVeriScroll"
/// 竖向翻页
public let kEventNameMenuPageVeriCurl = "kEventNameMenuPageVeriCurl"
/// 点击目录
public let kEventNameDidSelectChapter = "kEventNameDidSelectChapter"

// MARK: ----- Msg
/// 开始解析
public let kMsgNameStartOpeningBook = "kMsgNameStartOpeningBook"
/// 打开成功
public let kMsgNameOpenBookSuccess = "kMsgNameOpenBookSuccess"
/// 打开失败
public let kMsgNameOpenBookFail = "kMsgNameOpenBookFail"

/// 展示目录
public let kEventNameMenuShowCharter = "kEventNameMenuShowCharter"
/// 展示书签
public let kEventNameMenuShowCharterTag = "kEventNameMenuShowCharterTag"

/////////////////////////////// kEvent Msg /////////////////////////////////////////////////
/// 听书刷新阅读进度
public let kMsgNamePlayBookRefashText = "kMsgNamePlayBookRefashText"
/// 开始听书
public let kMsgNamePlayBookStarting = "kMsgNamePlayBookStarting"
/// 结束听书
public let kMsgNamePlayBookEnd = "kMsgNamePlayBookEnd"
/// 听书下一页
public let kMsgNamePlayBookNextPage = "kMsgNamePlayBookNextPage"
