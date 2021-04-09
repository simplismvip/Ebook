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
    let bookModel: JMBookModel
    
    let topLeft = JMReadItemView()
    let topRight = JMReadItemView()
    let bottom = JMReadItemView()
    
    let set = JMMenuSetView() // 设置
    let light = JMMenuLightView() // 亮度
    let play = JMMeunPlayVIew() // 播放
    
    let topContainer = UIView() // 亮度
    let bottomContainer = UIView() // 亮度
    let chapter = JMChapterView() // 左侧目录
    
    let margin: CGFloat = 10
    let s_width = UIScreen.main.bounds.size.width
    
    /// 状态
    var currType = JMMenuViewType.ViewType_NONE
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .vertical, options: nil)
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
        pageViewController.setViewControllers([getCurrentReadView()], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func topgesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        tapActionSwitchMenu(point.x)
    }
    
    func getCurrentReadView() -> JMReadController {
        let page = JMReadController()
        let pagrAttr = bookModel[bookModel.indexPath]
        page.pageView.reDrewText(content: pagrAttr)
        return page
    }
}

// TODO: -- PageView Delegate --
extension JMReadPageContrller: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let page = JMReadController()
        let pagrAttr = bookModel.nextPage()
        page.pageView.reDrewText(content: pagrAttr)
        return page
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let page = JMReadController()
        let pagrAttr = bookModel.prevPage()
        page.pageView.reDrewText(content: pagrAttr)
        return page
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
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
