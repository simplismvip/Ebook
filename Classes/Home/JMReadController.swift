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
    let pageView = JMReadView(frame: CGRect.zero)
    let bookTitle = JMBookTitleView() // 标题
    let battery = JMBatteryView() // 电池
    
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
    }
    
    /// 设置当前页
    public func loadPage(_ page: JMBookPage) {
        currPage = page
        pageView.reDrewText(content: page.attribute)
    }
    
    deinit {
        battery.fireTimer()
    }
}


