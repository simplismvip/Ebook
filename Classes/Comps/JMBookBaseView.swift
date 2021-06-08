//
//  JMBookBaseView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/8.
//

import ZJMKit

class JMBookBaseView: JMBaseView {
    func changeBkgColor(config: JMBookConfig) {
        backgroundColor = config.subViewBkgColor()
    }
}
