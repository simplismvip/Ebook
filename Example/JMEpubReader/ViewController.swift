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

class ViewController: UIViewController, JMReadProtocol {

    @IBOutlet weak var book1: UIImageView!
    var bookModel: JMBookParse?
    var flipCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        "htmlStr".decodingHTMLEntities()
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

    @IBAction func openDefault(_ sender: Any) {

    }
    
    @IBAction func test1(_ sender: Any) {
        
    }
    
    @IBAction func test2(_ sender: Any) {
        
    }
    
    @IBAction func openBooks(_ sender: Any) {
        if let path = Bundle.main.path(forResource: "TianXiaDaoZong", ofType: "epub") {
            bookModel = JMBookParse(path)
            
            if let router = self.msgRouter {
                bookModel?.jmSetAssociatedMsgRouter(router: router)
                bookModel?.startRead()
            }
        }
    }
    
    func openDefault() {
        do{
            let path = "/Users/jl/Desktop/EPUB/TianXiaDaoZong.epub"
            let url = URL(fileURLWithPath: path)
            let document = try EPUBParser().parse(documentAt: url)
            if let cover = document.cover {
                book1.image = UIImage(data: try Data(contentsOf: cover))
            }
            print(url.lastPathComponent)
        }catch {
            print("⚠️⚠️⚠️⚠️⚠️打开 \(error.localizedDescription)失败⚠️⚠️⚠️⚠️⚠️")
        }
    }
    
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

class JMEpubViewController: UIViewController {
    let imagev = UIImageView(image: UIImage(named: "00002"))
    let tips = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imagev)
        view.addSubview(tips)
        
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
