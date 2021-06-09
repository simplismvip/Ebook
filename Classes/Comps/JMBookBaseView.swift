//
//  JMBookBaseView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/8.
//

import ZJMKit

public class JMBookBaseView: JMBaseView {
    var config: JMBookConfig?
    func changeBkgColor(config: JMBookConfig) {
        self.config = config
        backgroundColor = config.subViewColor()
    }
}
