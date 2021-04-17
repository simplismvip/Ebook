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
    let bookModel: JMBookModel
    let topLeft = JMReadItemView()
    let topRight = JMReadItemView()
    let bottom = JMReadItemView()
    
    let set = JMMenuSetView() // 设置
    let light = JMMenuLightView() // 亮度
    let play = JMMeunPlayVIew() // 播放
    let battery = JMBatteryView() // 电池
    
    let topContainer = UIView() // 亮度
    let bottomContainer = UIView() // 亮度
    let chapter = JMChapterView() // 左侧目录
    
    let margin: CGFloat = 10
    let s_width = UIScreen.main.bounds.size.width
    // 第N章-N小节-N页，表示当前读到的位置
    public let cPage = JMBookIndex(0, 0, 0)
    
    /// 状态
    var currType = JMMenuViewType.ViewType_NONE
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.isDoubleSided = true
        return pageVC
    }()
    
    /// 调用初始化
    public init (_ bookModel: JMBookModel) {
        self.bookModel = bookModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        
        view.backgroundColor = UIColor.white
        
        setupviews()
        loadDats()
        registerMenuEvent()
        
        let tapGes = UITapGestureRecognizer()
        tapGes.delegate = self
        tapGes.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGes)
        tapGes.addTarget(self, action: #selector(topgesture(_:)))
        pageViewController.setViewControllers([getCurrentReadView()], direction: .reverse, animated: true, completion: nil)
    }
    
    @objc func topgesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        tapActionSwitchMenu(point.x)
    }
    
    func getCurrentReadView() -> JMReadController {
        let indexPath = JMBookIndex(0, 0, 0)
        let page = JMReadController(cPage: indexPath)
        let pagrAttr = bookModel[bookModel.indexPath]
        page.pageView.reDrewText(content: pagrAttr)
        return page
    }
}

// TODO: -- PageView Delegate --
extension JMReadPageContrller: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    // 往回翻页时触发
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let vc = delegate?.currentReadVC() {
            return vc
        }else {
            print("😀😀😀Before")
            if let pagrAttr = bookModel.prevPage(), pagrAttr.length > 10 {
                let indexPath = JMBookIndex(0, 0, 0)
                let page = JMReadController(cPage: indexPath)
                page.pageView.reDrewText(content: pagrAttr)
                return page
            }else {
                print("😀😀😀Before 字符长度为空")
                return nil
            }
        }
    }
    
    // 往后翻页时触发
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = delegate?.currentReadVC() {
            return vc
        }else {
            print("😀😀😀After")
            if let pagrAttr = bookModel.nextPage(), pagrAttr.length > 0 {
                let indexPath = JMBookIndex(0, 0, 0)
                let page = JMReadController(cPage: indexPath)
                page.pageView.reDrewText(content: pagrAttr)
                return page
            }else {
                print("😀😀😀After 字符长度为空")
                return nil
            }
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            print("😀😀😀completed")
        }else {
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


extension JMReadPageContrller: UIGestureRecognizerDelegate {
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view === view {
            return true
        }
        return false
    }
}
