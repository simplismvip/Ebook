//
//  JMReadController.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit

final public class JMReadController: JMBaseController {
    // 当前页
    public var currPage: JMBookPage?
    public var isShow: Bool = false
    let pageView = JMReadView(frame: CGRect.zero)

//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        isShow = true
//    }
//    
//    public override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        isShow = false
//    }
    
    public override func viewDidLoad() {
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
    }
    
    /// 设置当前页
    public func loadPage(_ page: JMBookPage) {
        isShow = true
        currPage = page
        pageView.reDrewText(content: page.attribute)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.randomElement()?.location(in: view) {
            let s_width = UIScreen.main.bounds.size.width
            if point.x < s_width/4 {
                jmRouterEvent(eventName: kEventNameMenuActionTapLeft, info: nil)
            }else if point.x > s_width/4 && point.x < s_width/4*3 {
                jmRouterEvent(eventName: kEventNameMenuActionTapAction, info: nil)
            }else {
                jmRouterEvent(eventName: kEventNameMenuActionTapRight, info: nil)
            }
        }
    }
}


