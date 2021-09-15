//
//  ViewController.swift
//  JMEpubReader
//
//  Created by simplismvip on 02/01/2021.
//  Copyright (c) 2021 simplismvip. All rights reserved.
//

import UIKit
import JMEpubReader
import SnapKit
import ZJMKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [EbookModel]()
    var bookModel: JMBookParse?
    var flipCount = 0
    let adView = UIView(frame: CGRect.Rect(0, 0, 0, 64))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = [["title":"天下刀宗","type":"epub"],
         ["title":"没有你，什么都不甜蜜","type":"epub"],
         ["title":"每天懂一点好玩心理学","type":"epub"],
         ["title":"民调局异闻", "type":"txt"]]
        dataSource.append(contentsOf: items.map { return EbookModel($0["title"]!, $0["type"]!) })
        adView.backgroundColor = UIColor.red
    }
}

extension ViewController: JMBookParserProtocol {
    func commentBook(_ bookid: String) {
    
    }
    
    func midReadPageVC(_ after: Bool) -> UIViewController? {
        return nil
        
//        flipCount = after ? (flipCount + 1) : (flipCount - 1)
//        return (flipCount % 5 == 0) ? JMEpubViewController() : nil
    }
    
    func startOpeningBook(_ desc: String) {
        Toast.toast(desc)
    }
    
    func openBookSuccess(_ bottomView: UIView) {
        Toast.toast("😀😀😀打开 \(bottomView.description)成功")
    }
    
    func openBookFailed(_ desc: String) {
        Toast.toast(desc)
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
            let view = UIView()
            view.backgroundColor = UIColor.red
            bookModel = JMBookParse(path)
            bookModel?.delegate = self
            bookModel?.pushReader(pushVC: self)
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
        JMBookToast.toast(text)
    }
}
