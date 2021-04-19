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
    public var currPage: JMBookPage
    let pageView = JMReadView(frame: CGRect.zero)
    let bookTitle = JMBookTitleView() // 标题
    let battery = JMBatteryView() // 电池
    
    public init(_ page: JMBookPage) {
        self.currPage = page
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        battery.progress.text = "16%" // bookModel.readRate()
        bookTitle.title.text = "天下刀宗" // bookModel.currTitle()
        battery.batteryColor = UIColor.darkText
        
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
        
        view.addSubview(bookTitle)
        bookTitle.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
        
        view.addSubview(battery)
        battery.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(view.snp.bottom)
            }
        }
        
        pageView.reDrewText(content: currPage.attribute)
    }
    
    /// 设置当前页
    public func loadPage(page: JMBookPage) {
        pageView.reDrewText(content: page.attribute)
    }
    
    deinit {
        battery.fireTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


