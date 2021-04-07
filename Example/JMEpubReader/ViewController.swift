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

    @IBOutlet weak var book1: UIImageView!
    var bookModel: JMBookParse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        push(JMReadPageContrller())
        view.transition(.kCATransitionOglFlip)
    }
    
    @IBAction func test1(_ sender: Any) {
        view.transition(.kCATransitionCube)
    }
    
    @IBAction func test2(_ sender: Any) {
        view.transition(.kCATransitionPageCurl)
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
}

class JMEpubViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }

}

struct Toast {
    static func toast(_ text: String) {
        JMTextToast.share.jmShowString(text: text, seconds: 2)
    }
}
