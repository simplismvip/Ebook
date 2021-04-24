//
//  JMReadConfig.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import UIKit
import ZJMKit

public enum JMDirection: Int {
    case vertical
    case horizontal
    case horizontalWithVerticalContent
    case defaultVertical

    /// 当前滚动方向
    /// - Returns: 返回UICollectionView的滚动方向
    func scrollDirection() -> UICollectionView.ScrollDirection {
        switch self {
        case .vertical, .defaultVertical:
            return .vertical
        case .horizontal, .horizontalWithVerticalContent:
            return .horizontal
        }
    }
    
    func index() -> Int {
        switch self {
        case .vertical, .defaultVertical:
            return 0
        case .horizontal, .horizontalWithVerticalContent:
            return 1
        }
    }
}

public class JMReadConfig: NSObject {
    static let share: JMReadConfig = { return JMReadConfig() }()
    
    // MARK: Colors
    /// Base header custom TintColor
    open var tintColor = UIColor(rgba: "#6ACC50")

//    /// Menu background color
//    open var menuBackgroundColor = BehaviorSubject(value: UIColor.white)
//
//    /// Menu separator Color
//    open var menuSeparatorColor = BehaviorSubject(value: UIColor(rgba: "#D7D7D7"))
//
//    /// Menu text color
//    open var menuTextColor = BehaviorSubject(value: UIColor(rgba: "#767676"))
//
//    /// Menu text color
//    open var menuTextColorSelected = BehaviorSubject(value: UIColor(rgba: "#6ACC50"))
//
//    // Day mode nav color
//    open var daysModeNavBackground = BehaviorSubject(value: UIColor.white)
//
//    // Day mode nav color
//    open var nightModeNavBackground = BehaviorSubject(value: UIColor(rgba: "#131313"))
//
//    /// Night mode background color
//    open var nightModeBackground = BehaviorSubject(value: UIColor(rgba: "#131313"))
//
//    /// Night mode menu background color
//    open var nightModeMenuBackground = BehaviorSubject(value: UIColor(rgba: "#1E1E1E"))
//
//    /// Night mode separator color
//    open var nightModeSeparatorColor = BehaviorSubject(value: UIColor(white: 0.5, alpha: 0.2))
//
//    /// Media overlay or TTS selection color
//    open lazy var mediaOverlayColor = self.tintColor
//
//    // MARK: Custom actions
//
//    /// 设置默认隐藏导航栏和底部状态视图
//    /// hide the navigation bar and the bottom status view
//    public var hideBars = BehaviorSubject(value: true)
//
//    /// 设置滚动方向
//    open var scrollDirection: JMDirection = .horizontal
//
//    /// Enable or disable hability to user change scroll direction on menu.
//    open var canChangeScrollDirection = BehaviorSubject(value: true)
//
//    /// Enable or disable hability to user change font style on menu.
//    open var canChangeFontStyle = BehaviorSubject(value: true)
//
//    /// 点击屏幕是否允许因此导航栏
//    open var shouldHideNavigationOnTap = BehaviorSubject(value: true)
//
//    /// 是否允许分享选项，否则隐藏所有分享按钮
//    /// Allow sharing option, if `false` will hide all sharing icons and options
//    open var allowSharing = BehaviorSubject(value: true)
//
//    /// Enable TTS (Text To Speech)
//    open var enableTTS = BehaviorSubject(value: true)
//
//    /// 是否展示标题在导航栏
//    open var displayTitle = BehaviorSubject(value: false)
//
//    /// 隐藏进度指示条
//    open var hidePageIndicator = BehaviorSubject(value: false)
//
//    /// 去保存位置打开书时
//    /// Go to saved position when open a book
//    open var loadSavedPositionForCurrentBook = BehaviorSubject(value: true)
//
//    // MARK: Quote image share
//
//    /// 自定义引用logo
//    /// Custom Quote logo
//    open var quoteCustomLogoImage = "icon-logo".image
//
//    /// Enable or disable default Quote Image backgrounds
//    open var quotePreserveDefaultBackgrounds = BehaviorSubject(value: true)

    // MARK: Localized strings

    /// Localizes Highlight title
    open var localizedHighlightsTitle = NSLocalizedString("Highlights", comment: "")

    /// Localizes Content title
    open var localizedContentsTitle = NSLocalizedString("Contents", comment: "")

    /// Use the readers `UIMenuController` which enables the highlighting etc. The default is `true`. If set to false it's possible to modify the shared `UIMenuController` for yourself. Note: This doesn't disable the text selection in the web view.
    open var useReaderMenuController = true

    /// Used to distinguish between multiple or different reader instances. The content of the user defaults (font settings etc.) depends on this identifier. The default is `nil`.
    open var identifier: String?

    /// Localizes Highlight date format. This is a `dateFormat` from `NSDateFormatter`, so be careful 🤔
    open var localizedHighlightsDateFormat = "MMM dd, YYYY | HH:mm"
    open var localizedHighlightMenu = NSLocalizedString("高亮", comment: "")
    open var localizedDefineMenu = NSLocalizedString("字典", comment: "")
    open var localizedPlayMenu = NSLocalizedString("播放", comment: "")
    open var localizedPauseMenu = NSLocalizedString("暂停", comment: "")
    open var localizedFontMenuNight = NSLocalizedString("Night", comment: "")
    open var localizedPlayerMenuStyle = NSLocalizedString("Style", comment: "")
    open var localizedFontMenuDay = NSLocalizedString("Day", comment: "")
    open var localizedLayoutHorizontal = NSLocalizedString("Horizontal", comment: "")
    open var localizedLayoutVertical = NSLocalizedString("Vertical", comment: "")
    open var localizedReaderOnePageLeft = NSLocalizedString("1 页", comment: "")
    open var localizedReaderManyPagesLeft = NSLocalizedString("页", comment: "")
    open var localizedReaderManyMinutes = NSLocalizedString("分", comment: "")
    open var localizedReaderOneMinute = NSLocalizedString("1 分", comment: "")
    open var localizedReaderLessThanOneMinute = NSLocalizedString("不到一分钟", comment: "")
    open var localizedShareWebLink: URL? = nil
    open var localizedShareChapterSubject = NSLocalizedString("查看这一章", comment: "")
    open var localizedShareHighlightSubject = NSLocalizedString("笔记来源", comment: "")
    open var localizedShareAllExcerptsFrom = NSLocalizedString("所有摘录", comment: "")
    open var localizedShareBy = NSLocalizedString("by", comment: "")
    open var localizedCancel = NSLocalizedString("取消", comment: "")
    open var localizedShare = NSLocalizedString("分享", comment: "")
    open var localizedChooseExisting = NSLocalizedString("相册", comment: "")
    open var localizedTakePhoto = NSLocalizedString("拍照", comment: "")
    open var localizedShareImageQuote = NSLocalizedString("分享为照片", comment: "")
    open var localizedShareTextQuote = NSLocalizedString("分享为文本", comment: "")
    open var localizedSave = NSLocalizedString("保存", comment: "")
    open var localizedHighlightNote = NSLocalizedString("笔记", comment: "")

    public convenience init(withIdentifier identifier: String) {
        self.init()
        self.identifier = identifier
    }

    /**
     Simplify attibution of values based on direction, basically is to avoid too much usage of `switch`,
     `if` and `else` statements to check. So basically this is like a shorthand version of the `switch` verification.

     For example:
     ```
     let pageOffsetPoint = readerConfig.isDirection(CGPoint(x: 0, y: pageOffset), CGPoint(x: pageOffset, y: 0), CGPoint(x: 0, y: pageOffset))
     ```

     As usually the `vertical` direction and `horizontalContentVertical` has similar statements you can basically hide the last
     value and it will assume the value from `vertical` as fallback.
     ```
     let pageOffsetPoint = readerConfig.isDirection(CGPoint(x: 0, y: pageOffset), CGPoint(x: pageOffset, y: 0))
     ```

     - parameter vertical:                  Value for `vertical` direction
     - parameter horizontal:                Value for `horizontal` direction
     - parameter horizontalContentVertical: Value for `horizontalWithVerticalContent` direction, if nil will fallback to `vertical` value

     - returns: The right value based on direction.
     */
//    func isDirection<T> (_ vertical: T, _ horizontal: T, _ horizontalContentVertical: T) -> T {
//        switch self.scrollDirection {
//        case .vertical, .defaultVertical:       return vertical
//        case .horizontal:                       return horizontal
//        case .horizontalWithVerticalContent:    return horizontalContentVertical
//        }
//    }
}
