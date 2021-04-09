//
//  JMReadController.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit
import RxCocoa
import RxSwift

final public class JMReadController: JMBaseController {
    let pageView = JMReadView(frame: CGRect.zero)
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(view.snp.top)
                make.bottom.equalTo(view.snp.bottom)
            }
        }
    }
}


