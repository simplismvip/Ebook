//
//  JMReadController.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit

final class JMPageController: JMBaseController {
    private var currPage: JMBookPage?
    private let pageView = JMPageView(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.top.equalTo(view.snp.top).offset(30)
                make.bottom.equalTo(view.snp.bottom).offset(-20)
            }
        }
        
        let tapGes = UITapGestureRecognizer()
        tapGes.addTarget(self, action: #selector(tapGestureAction(_:)))
        tapGes.delegate = self
        tapGes.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func tapGestureAction(_ gesture: UIGestureRecognizer) {
        jmRouterEvent(eventName: kEventNameMenuActionTapAction, info: nil)
    }
    
    /// 设置当前页
    public func loadPage(_ page: JMBookPage) {
        pageView.reDrewText(content: page.attribute)
        currPage = page
    }
    
    /// 设置当前页
    public func refresh(_ range: NSRange) {
        pageView.refreshText(range: range)
    }
}

extension JMPageController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: gestureRecognizer.view)
        let s_width = UIScreen.main.bounds.size.width
        if point.x > s_width/4 && point.x < s_width/4*3 {
            return true
        }else {
            jmRouterEvent(eventName: kEventNameMenuActionTapLeft, info: nil)
            return false
        }
    }
}
