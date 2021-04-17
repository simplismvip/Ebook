//
//  JMReadController.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit

final public class JMReadController: JMBaseController {
    // 第N章-N小节-N页，表示当前读到的位置
    public let currPage: JMBookIndex
    
    let pageView = JMReadView(frame: CGRect.zero)
    
    public init(cPage: JMBookIndex) {
        self.currPage = cPage
        super.init(nibName: nil, bundle: nil)
        
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


