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

    public override func viewDidLoad() {
        super.viewDidLoad()
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
}


