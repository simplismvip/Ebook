//
//  JMReadPageContrller.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import UIKit
import ZJMKit
import SnapKit
import RxCocoa
import RxSwift

public class JMReadPageContrller: JMBaseController {
    let menuView = JMReadMenuContainer()
    let vmodel = JMEpubVModel()
    let disposeBag = DisposeBag()
    
    lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.isDoubleSided = true
        return pageVC
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        
        view.backgroundColor = UIColor.white
        view.addSubview(menuView)
        menuView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        binder()
        registerMenuEvent()
        
        let tapGes = UITapGestureRecognizer()
        tapGes.delegate = self
        tapGes.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGes)
        tapGes.addTarget(self, action: #selector(topgesture(_:)))
    }
    
    @objc func topgesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        menuView.tapActionSwitchMenu(point.x)
    }
}

// TODO: -- PageView Delegate --
extension JMReadPageContrller: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return JMReadController()
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return JMReadController()
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}


extension JMReadPageContrller: UIGestureRecognizerDelegate {
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            return true
        }else {
            return false
        }
    }
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view === view, gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            return true
        }
        return false
    }
}
