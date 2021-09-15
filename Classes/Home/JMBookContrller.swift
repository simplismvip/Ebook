//
//  JMReadPageContrller.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import UIKit
import ZJMKit
import SnapKit

public class JMBookContrller: JMBaseController {
    public weak var delegate: JMReadProtocol?
    // 数据源
    let bookModel: JMBookModel
    let topLeft = JMMenuItemView()
    let topRight = JMMenuItemView()
    let bottom = JMMenuItemView()
    
    let set = JMMenuSetView() // 设置
    let light = JMMenuLightView() // 亮度
    let play = JMMeunPlayVIew() // 播放
    let progress = JMMeunProgress() // 进度
    let topContainer = UIView() // 亮度
    let bottomContainer = UIView() // 亮度
    let chapter = JMChapterContainer() // 左侧目录
    let maskView = JMBookMaskView()
    let bookTitle = JMBookTitleView() // 标题
    let comment = UIButton(type: .system)
    let battery = JMBatteryView() // 电池
    let s_width = UIScreen.main.bounds.size.width
    private var starttime: TimeInterval = 0 // 阅读时长
    
    // 第N章-N小节-N页，表示当前读到的位置
    public let cPage = JMBookIndex(0, 0)
    // 朗读
    private let speech: JMBookSpeech
    /// 状态
    var currType = JMMenuViewType.ViewType_NONE
    
    /// 状态栏
    public override var prefersStatusBarHidden: Bool {
        return currType == .ViewType_NONE
    }
    
    /// 状态栏
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return (bookModel.config.bkgColor == .BkgWhite) ? .default : .lightContent
    }
    
    // 翻页控制器
    private var pageVC: UIPageViewController?
    
    // 调用初始化
    public init (_ bookModel: JMBookModel) {
        self.bookModel = bookModel
        let speechModel = JMSpeechModel()
        self.speech = JMBookSpeech(speechModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        associatRouter()
        setupPageVC()
        setupviews()
        loadDats()
        setupFristPageView()
        registerMenuEvent()
        registerSubMenuEvent()
        registerLightMenuEvent()
        registerEventPlay()
        registerJumpEvent()
        updateProgress()
        updateItemStatus()
        maskView.brightness(bookModel.config.brightness())
        starttime = Date.jmCurrentTime
        
        comment.jmAddAction { [weak self](_) in
            self?.jmRouterEvent(eventName: kEventNameMenuActionBack, info: nil)
        }
        
//        view.addSubview(maskView)
//        maskView.snp.makeConstraints { (make) in
//            make.edges.equalTo(view)
//        }
    }
    
    private func initdatas() {
        battery.progress.text = bookModel.readRate()
        bookTitle.title.text = bookModel.currTitle()
        updateProgress()
        if let word = bookModel.currCharpter()?.word() {
            // 小说阅读一分钟约600字，一秒钟10个字
            let time = (word / 10).jmCurrentTime
            battery.title.text = "本章共\(word)字，读完约\(time)"
        }
    }
    
    private func setupFristPageView() {
        if let page = bookModel.currPage() {
            let pageView = useingPageView()
            pageView.loadPage(page)
            flipPage(pageView, direction: .reverse)
            initdatas()
        } else {
            Logger.error("❌❌❌❌发生严重错误")
        }
    }
    
    // 点击自动处理翻页，上一页，下一页
    private func nextPageView(_ isNext: Bool) -> JMPageController? {
        if let page = isNext ? bookModel.nextPage() : bookModel.prevPage() {
            let pageView = useingPageView()
            pageView.loadPage(page)
            return pageView
        }else {
            Logger.debug("😀😀😀After 字符长度为空")
            return nil
        }
    }
    
    // 查找正在使用的View
    // using: 是否重用
    private func useingPageView(_ using: Bool = false) -> JMPageController {
        if using {
            return pageVC?.viewControllers?.first as! JMPageController
        }
        
        let pageViwe = JMPageController()
        let color = bookModel.config.config.bkgColor
        pageViwe.view.backgroundColor = UIColor.jmHexColor(color.rawValue)
        return pageViwe
    }

    private func setupPageVC() {
        initdatas()
        var style: UIPageViewController.TransitionStyle = .scroll
        var orientation: UIPageViewController.NavigationOrientation = .horizontal
        if bookModel.config.flipType() == .PFlipHoriCurl {
            style = .pageCurl
            orientation = .horizontal
        }else if bookModel.config.flipType() == .PFlipVertCurl {
            style = .pageCurl
            orientation = .vertical
        }else if bookModel.config.flipType() == .PFlipHoriScroll {
            style = .scroll
            orientation = .horizontal
        }else if bookModel.config.flipType() == .PFlipVertScroll {
            style = .scroll
            orientation = .vertical
        }
        
        let pageVC = UIPageViewController(transitionStyle: style, navigationOrientation: orientation, options: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        view.insertSubview(pageVC.view, at: 0)
        addChildViewController(pageVC)
        self.pageVC = pageVC
    }
    
    // 翻页
    private func flipPage(_ pageView: JMPageController, direction: UIPageViewController.NavigationDirection) {
        pageVC?.setViewControllers([pageView], direction: direction, animated: true, completion: nil)
        initdatas()
    }
    
    // 重新计算分页
    private func reCalculationPage() {
        // 获取当前页的第一段文字
        if let targetPage = bookModel.currPage()?.string {
            // 完成后遍历所有页对比前获取的页数，定位到阅读页
            let text = String(targetPage.prefix(10))
            // 当前位置
            let cLoc = bookModel.currLocation(target: text)
            if let page = bookModel.newPageLoc(location: cLoc, text: text) {
                useingPageView(true).loadPage(page)
            }
        }
    }
    
    // 关联router
    private func associatRouter() {
        let router = JMRouter()
        jmSetAssociatedMsgRouter(router: router)
        speech.jmSetAssociatedMsgRouter(router: router)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        // 保存当前进度
        JMBookDataBase.insertData(isTag: false, book: bookModel)
        bookModel.config.codeConfig()
        speech.stop()
        let endtime = Date.jmCurrentTime - starttime
        JMBookDataBase.insertReadTime(bookid: bookModel.bookId, time: Int(endtime))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        battery.fireTimer()
    }
}

// TODO: -- PageView Delegate --
extension JMBookContrller: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    // 往回翻页时触发
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = delegate?.currentReadVC(false) {
            return vc
        } else {
            Logger.debug("😀😀😀Before")
            return nextPageView(false)
        }
    }
    
    // 往后翻页时触发
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = delegate?.currentReadVC(true) {
            return vc
        }else {
            Logger.debug("😀😀😀After")
            return nextPageView(true)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            Logger.debug("😀😀😀completed")
            // 保存当前进度
            JMBookDataBase.insertData(isTag: false, book: bookModel)
            initdatas()
        } else {
            hideWithType()
            Logger.debug("😀😀😀completed none")
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        Logger.debug("😀😀😀will")
    }
}

// TODO: -- Register Event --
extension JMBookContrller {
    func registerMenuEvent() {
        jmRegisterEvent(eventName: kEventNameMenuActionTapAction, block: { [weak self](_) in
            if self?.currType == .ViewType_NONE {
                self?.showWithType(type: .ViewType_TOP_BOTTOM)
            }else {
                self?.hideWithType()
            }
            self?.setNeedsStatusBarAppearanceUpdate()
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionTapLeft, block: { [weak self](_) in
            if self?.currType == .ViewType_NONE {
                Logger.debug("点击左侧1/4翻页")
            }else {
                self?.hideWithType()
            }
        }, next: false)
        
        
        jmRegisterEvent(eventName: kEventNameMenuActionBack, block: { [weak self](_) in
            self?.battery.fireTimer()
            self?.navigationController?.popViewController(animated: true)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionProgress, block: { [weak self](_) in
            self?.hideWithType()
            self?.showWithType(type: .ViewType_PROGRESS)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionAddTag, block: { [weak self](_) in
            if let book = self?.bookModel {
                JMBookToast.toast("添加书签成功",delay: 1)
                JMBookDataBase.insertData(isTag: true, book: book)
            }
        }, next: false)
           
        jmRegisterEvent(eventName: kEventNameMenuActionShare, block: { [weak self](_) in
            self?.jmShareImageToFriends(shareID: "分享图书📖到", image: nil, completionHandler: { _, _ in
                Logger.debug("分享成功")
            })
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionDayOrNight, block: { [weak self](model) in
            if let item = model as? JMMenuItem {
                self?.view.backgroundColor = item.isSelect ? UIColor.jmRGB(60, 60, 60) : UIColor.white
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionListenBook, block: { [weak self](_) in
            self?.hideWithType()
            self?.showWithType(type: .ViewType_PLAY)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBrightness, block: { [weak self](_) in
            self?.hideWithType()
            self?.showWithType(type: .ViewType_LIGHT)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionSettingMore, block: { [weak self](_) in
            self?.hideWithType()
            self?.showWithType(type: .ViewType_SET)
        }, next: false)
        
        // 滑动滑杆修改字体
        jmRegisterEvent(eventName: kEventNameMenuFontSizeSlider, block: { [weak self](value) in
            JMBookToast.hide()
            self?.reCalculationPage()
        }, next: false)
        
        // 显示左侧目录
        jmRegisterEvent(eventName: kEventNameMenuActionBookCatalog, block: { [weak self](_) in
            if let tocItems = self?.bookModel.contents {
                self?.hideWithType()
                self?.showChapter(items: tocItems.filter { ($0.charpTitle?.count ?? 0) > 0 })
            }
        }, next: false)
    }
    
    // 这个方法处理书籍章节转跳
    func registerJumpEvent() {
        // 点击左侧目录转跳
        jmRegisterEvent(eventName: kEventNameDidSelectChapter, block: { [weak self](value) in
            self?.hideWithType()
            if let charpter = value as? JMBookCharpter { // 如果是空说明选中当前章节，不操作
                self?.bookModel.indexPath.chapter = charpter.location.chapter
                self?.bookModel.indexPath.page = 0
                if let page = self?.bookModel.currPage(),
                   let pageView = self?.useingPageView() {
                    pageView.loadPage(page)
                    self?.flipPage(pageView, direction: .forward)
                }
            } else if let charpterTag = value as? JMChapterTag {
                // 当前位置
                let cLoc = self?.bookModel.currLocation(target: charpterTag.text) ?? charpterTag.location
                if let page = self?.bookModel.newPageLoc(location: cLoc, text: charpterTag.text) {
                    self?.useingPageView(true).loadPage(page)
                }
            }
        }, next: false)
        
        // 下一章
        jmRegisterEvent(eventName: kEventNameMenuActionNextCharpter, block: { [weak self](_) in
            self?.nextCharpter()
        }, next: false)
        
        // 上一章
        jmRegisterEvent(eventName: kEventNameMenuActionPrevCharpter, block: { [weak self](_) in
            self?.prevCharpter()
        }, next: false)
        
        // 滑动滑杆跳到指定页数
        jmRegisterEvent(eventName: kEventNameMenuActionTargetCharpter, block: { [weak self](value) in
            JMBookToast.hide()
            if let pageIndex = value as? Int {
                self?.hideWithType()
                self?.bookModel.indexPath.page = pageIndex
                if let page = self?.bookModel.currPage(),
                   let pageView = self?.useingPageView() {
                    pageView.loadPage(page)
                    self?.flipPage(pageView, direction: .forward)
                }
            }
        }, next: false)
    }
    
    func registerLightMenuEvent() {
        jmRegisterEvent(eventName: kEventNameMenuBrightnessSystem, block: { [weak self](_) in
            self?.maskView.brightness(1.0)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuBrightnessCareEye, block: { [weak self](_) in
            self?.maskView.brightness(0.7)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBrightSliderValue, block: { [weak self](value) in
            if let brightness = value as? CGFloat {
                self?.maskView.brightness(brightness)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionBrightSliderEnd, block: { [weak self](_) in
            if let items = self?.light.allItems() {
                for item in items {
                    if item.identify == .PLightSys || item.identify == .PLightCus {
                        item.isSelect = false
                    }
                }
            }
        }, next: false)
    }
    
    func registerSubMenuEvent() {
        // 修改背景颜色
        jmRegisterEvent(eventName: kEventNameMenuPageBkgColor, block: { [weak self](item) in
            if let color = (item as? JMMenuItem)?.identify {
                self?.bookModel.config.config.bkgColor = color
                self?.reCalculationPage()
                if let childVCS = self?.pageVC?.childViewControllers {
                    for childVc in childVCS {
                        childVc.view.backgroundColor = UIColor.jmHexColor(color.rawValue)
                    }
                }
                if let config = self?.bookModel.config {
                    self?.updateAllItemsBkg(config: config)
                }
            }
        }, next: false)
        
        // 设置翻页
        jmRegisterEvent(eventName: kEventNameMenuPageFlipType, block: { [weak self](item) in
            if let typeStr = (item as? JMMenuItem)?.identify {
                self?.bookModel.config.config.flipType = typeStr
                if let page = self?.bookModel.currPage(), let pageView = self?.useingPageView() {
                    self?.pageVC?.view.removeFromSuperview()
                    self?.pageVC?.removeFromParentViewController()
                    self?.setupPageVC()
                    pageView.loadPage(page)
                    self?.flipPage(pageView, direction: .reverse)
                }
            }
        }, next: false)
        
        // 修改字体大小
        jmRegisterEvent(eventName: kEventNameMenuSliderValueChange, block: { [weak self](value) in
            if let fontSize = value as? CGFloat {
                JMBookToast.toast(("字体大小\(Int(fontSize))"))
                self?.bookModel.config.config.fontSize = fontSize
            } else if let toastText = value as? String {
                JMBookToast.toast(toastText)
            }
        }, next: false)
        
        // 修改字体
        jmRegisterEvent(eventName: kEventNameMenuFontType, block: { [weak self](item) in
            if let fontName = (item as? JMMenuItem)?.identify {
                self?.bookModel.config.config.fontName = fontName
                self?.reCalculationPage()
            }
        }, next: false)
        
    }
    
    // MARK: -- 听书 --
    func registerEventPlay() {
        // 播放 暂停
        jmRegisterEvent(eventName: kEventNameMenuPlayBookPlay, block: { [weak self](item) in
            if let speech = self?.speech {
                if speech.play {
                    self?.speech.pause()
                } else {
                    if speech.synthesizer.isPaused {
                        self?.speech.resume()
                    } else {
                        if let page = self?.bookModel.currPage() {
                            self?.speech.readImmediately(page, clear: false)
                        }
                    }
                }
            }
        }, next: false)
        
        // 上一页（手动点击）
        jmRegisterEvent(eventName: kEventNameMenuPlayBookPrev, block: { [weak self](_) in
            if let prev = self?.prevPage(), prev, let page = self?.bookModel.currPage() {
                self?.speech.readImmediately(page, clear: false)
            }
        }, next: false)
        
        // 下一页（手动点击）
        jmRegisterEvent(eventName: kEventNameMenuPlayBookNext, block: { [weak self](_) in
            if let next = self?.nextPage(), next, let page = self?.bookModel.currPage() {
                self?.speech.readImmediately(page, clear: false)
            }
        }, next: false)
        
        // 播放下一页（发送msg）
        jmReciverMsg(msgName: kMsgNamePlayBookEnd) { [weak self](_) -> MsgObjc? in
//            if let next = self?.nextPage(), next, let page = self?.bookModel.currPage() {
//                self?.speech.readImmediately(page, clear: false)
//            }
            return nil
        }
        
        // 听书实时返回range刷新文字
        jmReciverMsg(msgName: kMsgNamePlayBookRefashText) { [weak self](msg) -> MsgObjc? in
            if let characterRange = msg as? NSRange {
                Logger.debug(characterRange)
                self?.useingPageView(true).refresh(characterRange)
            }
            return nil
        }
    }
}

// MARK: -- 手动处理翻页，上一章/页，下一章/页。 --
extension JMBookContrller {
    // 下一章节
    @discardableResult
    private func nextCharpter() -> Bool {
        hideWithType()
        if let page = bookModel.nextCharpter() {
            let pageView = useingPageView()
            pageView.loadPage(page)
            flipPage(pageView, direction: .forward)
            return true
        } else {
            JMTextToast.share.jmShowString(text: "已经是最后一章", seconds: 1)
            return false
        }
    }
    
    // 上一章节
    @discardableResult
    private func prevCharpter() -> Bool {
        hideWithType()
        if let page = bookModel.prevCharpter() {
            let pageView = useingPageView()
            pageView.loadPage(page)
            flipPage(pageView, direction: .forward)
            return true
        } else {
            JMTextToast.share.jmShowString(text: "已经是第一章", seconds: 1)
            return false
        }
    }
    
    // 下一页
    @discardableResult
    private func nextPage() -> Bool {
        if let page = bookModel.nextPage() {
            let pageView = useingPageView()
            pageView.loadPage(page)
            flipPage(pageView, direction: .forward)
            return true
        } else {
            JMTextToast.share.jmShowString(text: "已经是最后一页", seconds: 1)
            return false
        }
    }
    
    // 上一页
    @discardableResult
    private func prevPage() -> Bool {
        if let page = bookModel.prevPage() {
            let pageView = useingPageView()
            pageView.loadPage(page)
            flipPage(pageView, direction: .forward)
            return true
        } else {
            JMTextToast.share.jmShowString(text: "已经是最后一页", seconds: 1)
            return false
        }
    }
}
