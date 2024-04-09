//
//  JMMenuItem.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit

public class JMMenuItem {
    var title: String?
    var image: String?

    var event: String = kReadMenuEventNameNone
    var type: JMMenuType = JMMenuType.nonetype
    var identify: JMMenuStyle = .nonetype
    
    var border: Bool = false // 选中是否显示border
    
    /// 是否是设置背景模型
    var borderWidth: CGFloat?
    var cornerRadius: CGFloat?
    
    var borderColor: UIColor?
    var titleColor: UIColor?
    
    var isSelect: Bool = false {
        willSet { didSelectAction?(newValue) }
    }
    var didSelectAction: ((Bool)->())?
    
    init(title: String? = nil, image: String? = nil, event: String, type: JMMenuType, identify: JMMenuStyle, border: Bool = false, borderWidth: CGFloat? = nil, cornerRadius: CGFloat? = nil, borderColor: UIColor? = nil, titleColor: UIColor? = nil, isSelect: Bool = false) {
        self.title = title
        self.image = image
        self.event = event
        self.type = type
        self.identify = identify
        self.border = border
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.titleColor = titleColor
        self.isSelect = isSelect
    }
}

extension JMMenuItem {
    static var topLeft: [JMMenuItem] {
        let item = JMMenuItem(image: "ebook_back",
                              event: "kEventNameMenuActionBack",
                              type: .TopLeft,
                              identify: .TopLeft)
        return [item]
    }
    
    static var topRight: [JMMenuItem] {
        let item1 = JMMenuItem(image: "epub_tag",
                              event: "kEventNameMenuActionAddTag",
                              type: .TopRight,
                              identify: .TRightTag)
        
        let item2 = JMMenuItem(image: "epub_share",
                              event: "kEventNameMenuActionShare",
                              type: .TopRight,
                              identify: .TRightShare)
        return [item1, item2]
    }
    
    
    static var bottom: [JMMenuItem] {
        let item1 = JMMenuItem(image: "epub_chapter",
                              event: "kEventNameMenuActionBookCatalog",
                              type: .MainBottom,
                              identify: .MainBotCatalog)
        
        let item2 = JMMenuItem(image: "epub_progress",
                              event: "kEventNameMenuActionProgress",
                              type: .MainBottom,
                              identify: .MainBotDayNight)
        let item3 = JMMenuItem(image: "epub_bkg",
                              event: "kEventNameMenuActionBrightness",
                              type: .MainBottom,
                              identify: .MainBotBright)
        
        let item4 = JMMenuItem(image: "epub_set",
                              event: "kEventNameMenuActionSettingMore",
                              type: .MainBottom,
                              identify: .MainBotSetting)
        
        return [item1, item2, item3, item4]
    }
    
    static var charters: [JMMenuItem] {
        let item1 = JMMenuItem(title: "目录",
                              event: "kEventNameMenuShowCharter",
                              type: .CharterTag,
                              identify: .Charter,
                               isSelect: true)
        
        let item2 = JMMenuItem(title: "书签",
                              event: "kEventNameMenuShowCharterTag",
                              type: .CharterTag,
                              identify: .CharterTag,
                               isSelect: true)
        return [item1, item2]
    }
    
//    menu_light_type
    static var lights: [JMMenuItem] {
        let item1 = JMMenuItem(title: "目录",
                              event: "kEventNameMenuShowCharter",
                              type: .CharterTag,
                              identify: .Charter,
                               isSelect: true)
        
        let item2 = JMMenuItem(title: "书签",
                              event: "kEventNameMenuShowCharterTag",
                              type: .CharterTag,
                              identify: .CharterTag,
                               isSelect: true)
        return [item1, item2]
    }
    
//    menu_bkgcolor
    static var bkgs: [JMMenuItem] {
        let item1 = JMMenuItem(event: "kEventNameMenuPageBkgColor",
                              type: .BkgColor,
                              identify: .BkgBlack)
        
        let item2 = JMMenuItem(event: "kEventNameMenuPageBkgColor",
                               type: .BkgColor,
                               identify: .BkgGray)
        
        let item3 = JMMenuItem(event: "kEventNameMenuPageBkgColor",
                              type: .BkgColor,
                              identify: .BkgBrown)
        
        let item4 = JMMenuItem(event: "kEventNameMenuPageBkgColor",
                               type: .BkgColor,
                               identify: .BkgLightGray)
        
        let item5 = JMMenuItem(event: "kEventNameMenuPageBkgColor",
                              type: .BkgColor,
                              identify: .BkgBlueGray)
        
        let item6 = JMMenuItem(event: "kEventNameMenuPageBkgColor",
                               type: .BkgColor,
                               identify: .BkgWhite)
        return [item1, item2, item3, item4, item5, item6]
    }
    
//    menu_flip_type
    static var flips: [JMMenuItem] {
        let item1 = JMMenuItem(title: "滚动",
                              event: "kEventNameMenuPageFlipType",
                              type: .PageFlip,
                              identify: .PFlipHoriScroll)
        
        let item2 = JMMenuItem(title: "翻页",
                              event: "kEventNameMenuPageFlipType",
                              type: .PageFlip,
                              identify: .PFlipHoriCurl)
        let item3 = JMMenuItem(title: "竖直",
                              event: "kEventNameMenuPageFlipType",
                              type: .PageFlip,
                              identify: .PFlipVertScroll)
        return [item1, item2, item3]
    }
    
    //    menu_font_type
    static var fonts: [JMMenuItem] {
        let item1 = JMMenuItem(title: "系统",
                              event: "kEventNameMenuFontType",
                              type: .PageFont,
                              identify: .SystemFont)
        
        let item2 = JMMenuItem(title: "楷体",
                              event: "kEventNameMenuFontType",
                              type: .PageFont,
                              identify: .PFont1)
        let item3 = JMMenuItem(title: "妹子体",
                              event: "kEventNameMenuFontType",
                              type: .PageFont,
                              identify: .PFont2)
        
        let item4 = JMMenuItem(title: "悠然体",
                              event: "kEventNameMenuFontType",
                              type: .PageFont,
                              identify: .PFont3)
        return [item1, item2]
    }
//    menu_play
    static var plays: [JMMenuItem] {
        let item1 = JMMenuItem(image: "epub_play_prev",
                              event: "kEventNameMenuPlayBookPrev",
                              type: .PlayOrPause,
                              identify: .PlayPrev)
        
        let item2 = JMMenuItem(image: "epub_play_p",
                              event: "kEventNameMenuPlayBookPlay",
                              type: .PlayOrPause,
                              identify: .PlayOrPause)
        let item3 = JMMenuItem(image: "epub_play_next",
                              event: "kEventNameMenuPlayBookNext",
                              type: .PlayOrPause,
                              identify: .PlayNext)
        return [item1, item2, item3]
    }
    
    
//    menu_playrate
    static var playrates: [JMMenuItem] {
        let item1 = JMMenuItem(title: "0.5X",
                              event: "kEventNameMenuPlayBookRate",
                              type: .PlayRate,
                              identify: .PlayRate)
        
        let item2 = JMMenuItem(title: "1X",
                              event: "kEventNameMenuPlayBookRate",
                              type: .PlayRate,
                              identify: .PlayRate1)
        let item3 = JMMenuItem(title: "1.5X",
                              event: "kEventNameMenuPlayBookRate",
                              type: .PlayRate,
                              identify: .PlayRate2)
        let item4 = JMMenuItem(title: "2.0X",
                              event: "kEventNameMenuPlayBookRate",
                              type: .PlayRate,
                              identify: .PlayRate3)
        return [item1, item2, item3, item4]
    }
}

@propertyWrapper
struct JMMenuSelect {
    private var status: Bool = false
    private var projectValue: Bool = false
    
    var wrappedValue: Bool {
        set {
            projectValue = newValue
            status = newValue
        }
        get { return status }
    }
}
