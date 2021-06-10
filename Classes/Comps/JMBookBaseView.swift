//
//  JMBookBaseView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/8.
//

import ZJMKit

public class JMBookBaseView: JMBaseView {
    func changeBkgColor(config: JMBookConfig) {
        backgroundColor = config.subViewColor()
        for view in subviews {
            if view.isKind(of: UIButton.self) {
                (view as? UIButton)?.tintColor = config.textColor()
            } else if view.isKind(of: UILabel.self) {
                (view as? UILabel)?.textColor = config.textColor()
            } else if view.isKind(of: UISlider.self) {
                let slider = view as? UISlider
                slider?.minimumTrackTintColor = config.selectColor()
                slider?.maximumTrackTintColor = config.textColor()
            } else if view.isKind(of: JMMenuItemView.self) {
                (view as? JMMenuItemView)?.refreshViews()
            }
        }
    }
}
