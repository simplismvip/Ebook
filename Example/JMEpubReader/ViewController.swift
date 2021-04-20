//
//  ViewController.swift
//  JMEpubReader
//
//  Created by simplismvip on 02/01/2021.
//  Copyright (c) 2021 simplismvip. All rights reserved.
//

import UIKit
import EPUBKit
import JMEpubReader
import SnapKit
import ZJMKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [EbookModel]()
    var bookModel: JMBookParse?
    var flipCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        let items = [["title":"TianXiaDaoZong","type":"epub"],
         ["title":"没有你，什么都不甜蜜","type":"epub"],
         ["title":"每天懂一点好玩心理学","type":"epub"],
         ["title":"mdjyml", "type":"txt"]]
        dataSource.append(contentsOf: items.map { return EbookModel($0["title"]!, $0["type"]!) })
    }
    
    func register() {
        let router = JMRouter()
        jmSetAssociatedMsgRouter(router: router)
        jmReciverMsg(msgName: kMsgNameStartOpeningBook) { (msg) -> MsgObjc? in
            if let text = msg as? String {
                Toast.toast(text)
            }
            return nil
        }
        
        jmReciverMsg(msgName: kMsgNameOpenBookSuccess) { [weak self](bookModel) -> MsgObjc? in
            if let model = bookModel as? JMBookModel {
                Toast.toast("😀😀😀打开 \(model.title)成功")
                let vc = JMReadPageContrller(model)
                vc.delegate = self
                self?.push(vc)
            }
            return nil
        }
        
        jmReciverMsg(msgName: kMsgNameOpenBookFail) { (msg) -> MsgObjc? in
            if let text = msg as? String {
                Toast.toast(text)
            }
            return nil
        }
    }
    
    @IBAction func openBooks(_ sender: Any) {
        
    }
}

extension ViewController: JMReadProtocol {
    // 返回需要展示的
    func currentReadVC(_ forward: Bool) -> UIViewController? {
        if forward {
            flipCount += 1
            return (flipCount % 5 == 0) ? JMEpubViewController() : nil
        }else {
            return nil
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "kReuseCellIdentifier")
        if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: "kReuseCellIdentifier") }
        cell?.textLabel?.text = dataSource[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if let path = Bundle.main.path(forResource: model.name, ofType: model.type) {
            bookModel = JMBookParse(path)
            if let router = self.msgRouter {
                bookModel?.jmSetAssociatedMsgRouter(router: router)
                bookModel?.startRead()
            }
        }
    }
}

struct EbookModel {
    let name: String
    let type: String
    
    init(_ name: String, _ type: String) {
        self.name = name
        self.type = type
    }
}

class JMEpubViewController: UIViewController {
    let imagev = UIImageView(image: UIImage(named: "00002"))
    let tips = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imagev)
        view.addSubview(tips)
        view.backgroundColor = UIColor.white
        imagev.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.view.jmWidth)
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY)
        }
        
        tips.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(44)
            make.top.equalTo(imagev.snp.bottom).offset(20)
        }
        
        tips.jmConfigLabel(alig: .center, font: UIFont.jmMedium(20), color: UIColor.jmRGB(230, 230, 230))
        tips.text = "点击可继续翻页"
    }

}

struct Toast {
    static func toast(_ text: String) {
        JMTextToast.share.jmShowString(text: text, seconds: 2)
    }
}
