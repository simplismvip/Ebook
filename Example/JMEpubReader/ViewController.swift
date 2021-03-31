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

class ViewController: UIViewController {

    @IBOutlet weak var book1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let vc = JMReadPageContrller()
        push(vc)
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


