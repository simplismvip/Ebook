//
//  JMReadPageContrller.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import UIKit
import ZJMKit
import SnapKit

public class JMReadPageContrller: JMBaseController {
    public weak var delegate: JMReadProtocol?
    // 数据源
    private var dataSource = [JMReadController(), JMReadController()]
    let bookModel: JMBookModel
    let topLeft = JMReadItemView()
    let topRight = JMReadItemView()
    let bottom = JMReadItemView()
    
    let set = JMMenuSetView() // 设置
    let light = JMMenuLightView() // 亮度
    let play = JMMeunPlayVIew() // 播放
    let progress = JMMeunProgress() // 进度
    let topContainer = UIView() // 亮度
    let bottomContainer = UIView() // 亮度
    let chapter = JMChapterContainer() // 左侧目录
    
    let bookTitle = JMBookTitleView() // 标题
    let battery = JMBatteryView() // 电池
    let toast = JMMenuToastView() // toast
    let margin: CGFloat = 10
    let s_width = UIScreen.main.bounds.size.width
    
    // 第N章-N小节-N页，表示当前读到的位置
    public let cPage = JMBookIndex(0, 0)
    let speech: JMSpeechParse
    
    /// 状态
    var currType = JMMenuViewType.ViewType_NONE
    
    public override var prefersStatusBarHidden: Bool {
        return currType == .ViewType_NONE
    }
    
    // 翻页控制器
    private var pageVC: UIPageViewController?
    
    // 调用初始化
    public init (_ bookModel: JMBookModel) {
        self.bookModel = bookModel
        let speechModel = JMSpeechModel()
        self.speech = JMSpeechParse(speechModel)
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
        registerEventPlay()
        registerJumpEvent()
        updateProgress()
    }
    
    private func initdatas() {
        battery.progress.text = bookModel.readRate()
        bookTitle.title.text = bookModel.currTitle()
        updateProgress()
        if let word = bookModel.currCharpter()?.word() {
            // 正常人阅读一分钟约300字，一秒钟5个字
            let time = (word / 5).jmCurrentTime
            battery.title.text = "本章共\(word)字，读完约\(time)"
        }
    }
    
    private func setupFristPageView() {
        if let page = bookModel.currPage(),
           let pageView = useingPageView() {
            pageView.loadPage(page)
            pageVC?.setViewControllers([pageView], direction: .reverse, animated: true, completion: nil)
            initdatas()
        }
    }
    
    // 点击自动处理翻页，上一页，下一页
    private func nextPageView(_ isNext: Bool) -> JMReadController? {
        if let page = isNext ? bookModel.nextPage() : bookModel.prevPage() {
            let pageView = useingPageView()
            pageView?.loadPage(page)
            return pageView
        }else {
            print("😀😀😀After 字符长度为空")
            return nil
        }
    }
    
    // 查找正在使用的View
    private func useingPageView(_ using: Bool = false) -> JMReadController? {
        for pageView in dataSource {
            if (pageVC?.viewControllers?.contains(pageView) ?? false) == using {
                return pageView
            }
        }
        return nil
    }

    private func setupPageVC() {
        var style: UIPageViewController.TransitionStyle = .scroll
        var orientation: UIPageViewController.NavigationOrientation = .horizontal
        if bookModel.config.flipType() == .HoriCurl {
            style = .pageCurl
            orientation = .horizontal
        }else if bookModel.config.flipType() == .VertCurl {
            style = .pageCurl
            orientation = .vertical
        }else if bookModel.config.flipType() == .HoriScroll {
            style = .scroll
            orientation = .horizontal
        }else if bookModel.config.flipType() == .VertScroll {
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
    
    // 重新计算分页
    private func reCalculationPage() {
        // 获取当前页的第一段文字
        if let targetPage = bookModel.currPage()?.attribute.string, targetPage.count > 10 {
            // 重新修改字体，计算页数
            bookModel.reCountCharpter()
            // 完成后遍历所有页对比前获取的页数，定位到阅读页
            let text = String(targetPage.prefix(10))
            if let page = bookModel.newPageLoc(text: text),
               let pageView = useingPageView(true) {
                pageView.loadPage(page)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        battery.fireTimer()
    }
}

// TODO: -- PageView Delegate --
extension JMReadPageContrller: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    // 往回翻页时触发
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = delegate?.currentReadVC(false) {
            return vc
        }else {
            print("😀😀😀Before")
            return nextPageView(false)
        }
    }
    
    // 往后翻页时触发
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = delegate?.currentReadVC(true) {
            return vc
        }else {
            print("😀😀😀After")
            return nextPageView(true)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            print("😀😀😀completed")
            initdatas()
        }else {
            hideWithType()
//            print("😀😀😀completed none")
//            if let page = previousViewControllers.first as? JMReadController {
//                bookModel.indexPath.chapter = page.currPage.chapter
//                bookModel.indexPath.section = page.currPage.section
//                bookModel.indexPath.page = page.currPage.page
//            }
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        print("😀😀😀will")
    }
}

// TODO: -- Register Event --
extension JMReadPageContrller {
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
                print("点击左侧1/4翻页")
            }else {
                self?.hideWithType()
            }
        }, next: false)
        
        
        jmRegisterEvent(eventName: kEventNameMenuActionBack, block: { [weak self](_) in
            self?.battery.fireTimer()
            self?.navigationController?.popViewController(animated: true)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionShare, block: { [weak self](_) in
            if let book = self?.bookModel {
                JMBookDataBase.insertData(isTag: true, book: book)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionProgress, block: { [weak self](_) in
            self?.hideWithType()
            self?.showWithType(type: .ViewType_PROGRESS)
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuActionMore, block: { [weak self](_) in
            
            
        }, next: false)
                
        jmRegisterEvent(eventName: kEventNameMenuActionDayOrNight, block: { [weak self](model) in
            if let item = model as? JMReadMenuItem {
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
            self?.toast.isHidden = true
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
                    self?.pageVC?.setViewControllers([pageView], direction: .forward, animated: true, completion: nil)
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
        
        // 滑动滑杆跳到指定章节
        jmRegisterEvent(eventName: kEventNameMenuActionTargetCharpter, block: { [weak self](value) in
            self?.toast.isHidden = true
            if let target = value as? Int, target < (self?.bookModel.contents.count ?? 0) {
                self?.hideWithType()
                self?.bookModel.indexPath.chapter = target
                self?.bookModel.indexPath.page = 0
                if let page = self?.bookModel.currPage(),
                   let pageView = self?.useingPageView() {
                    pageView.loadPage(page)
                    self?.pageVC?.setViewControllers([pageView], direction: .forward, animated: true, completion: nil)
                }
            }
        }, next: false)
    }
    
    func registerSubMenuEvent() {
        // 修改背景颜色
        jmRegisterEvent(eventName: kEventNameMenuPageBkgColor, block: { [weak self](item) in
            if let color = (item as? JMReadMenuItem)?.bkgColor {
                self?.bookModel.config.config.bkgColor = color
                if let controllers = self?.dataSource {
                    for vc in controllers {
                        vc.view.backgroundColor = UIColor.jmHexColor(color)
                    }
                }
            }
            
        }, next: false)
        
        // 设置翻页
        jmRegisterEvent(eventName: kEventNameMenuPageFlipType, block: { [weak self](item) in
            if let typeStr = (item as? JMReadMenuItem)?.identify.rawValue {
                self?.bookModel.config.config.flipType = JMFlipType.typeFrom(typeStr)
                if let page = self?.bookModel.currPage(), let pageView = self?.useingPageView() {
                    self?.pageVC?.view.removeFromSuperview()
                    self?.pageVC?.removeFromParentViewController()
                    self?.setupPageVC()
                    pageView.loadPage(page)
                    self?.pageVC?.setViewControllers([pageView], direction: .reverse, animated: true, completion: nil)
                }
            }
            
        }, next: false)
        
        // 设置翻页
        jmRegisterEvent(eventName: kEventNameMenuSliderValueChange, block: { [weak self](value) in
            if let fontSize = value as? CGFloat {
                self?.toast.updateToast(("字体大小\(Int(fontSize))"))
                self?.toast.isHidden = false
                self?.bookModel.config.config.fontSize = fontSize
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
                }else {
                    if speech.synthesizer.isPaused {
                        self?.speech.resume()
                    }else {
                        if let page = self?.bookModel.currPage(), page.attribute.length > 10 {
                            self?.speech.readImmediately(page.attribute, clear: false)
                        }
                    }
                }
            }
        }, next: false)
        
        // 上一页
        jmRegisterEvent(eventName: kEventNameMenuPlayBookPrev, block: { [weak self](item) in
            self?.prevPage()
        }, next: false)
        
        // 下一页
        jmRegisterEvent(eventName: kEventNameMenuPlayBookNext, block: { [weak self](value) in
            self?.nextPage()
        }, next: false)
        
        // 听书实时返回range刷新文字
        jmReciverMsg(msgName: kMsgNamePlayBookRefashText) { [weak self](msg) -> MsgObjc? in
            if let characterRange = msg as? NSRange, let usePage = self?.useingPageView(true) {
                print(characterRange)
                usePage.pageView.refreshText(range: characterRange)
            }
            return nil
        }
        
        // 听书实时返回range刷新文字
        jmReciverMsg(msgName: kMsgNamePlayBookEnd) { (msg) -> MsgObjc? in
            if let characterRange = msg as? NSRange {
                print(characterRange)
            }
            return nil
        }
    }
}

// MARK: -- 手动处理翻页，上一章/页，下一章/页。 --
extension JMReadPageContrller {
    // 下一章节
    private func nextCharpter() {
        hideWithType()
        if let page = bookModel.nextCharpter(), let pageView = useingPageView() {
            pageView.loadPage(page)
            pageVC?.setViewControllers([pageView], direction: .forward, animated: true, completion: nil)
        }else {
            JMTextToast.share.jmShowString(text: "已经是最后一章", seconds: 1)
        }
    }
    
    // 上一章节
    private func prevCharpter() {
        hideWithType()
        if let page = bookModel.prevCharpter(), let pageView = useingPageView() {
            pageView.loadPage(page)
            pageVC?.setViewControllers([pageView], direction: .forward, animated: true, completion: nil)
        }else {
            JMTextToast.share.jmShowString(text: "已经是第一章", seconds: 1)
        }
    }
    
    // 下一页
    private func nextPage() {
        if let page = bookModel.nextPage(), let pageView = useingPageView() {
            pageView.loadPage(page)
            pageVC?.setViewControllers([pageView], direction: .forward, animated: true, completion: nil)
        }else {
            JMTextToast.share.jmShowString(text: "已经是最后一页", seconds: 1)
        }
    }
    
    // 上一页
    private func prevPage() {
        if let page = bookModel.prevPage(), let pageView = useingPageView() {
            pageView.loadPage(page)
            pageVC?.setViewControllers([pageView], direction: .forward, animated: true, completion: nil)
        }else {
            JMTextToast.share.jmShowString(text: "已经是最后一页", seconds: 1)
        }
    }
}
