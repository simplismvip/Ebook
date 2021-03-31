//
//  JMReadItemView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import ZJMKit
import RxSwift
import RxCocoa

final class JMReadItemView: JMBaseView {
    private var models = [JMReadMenuItem]()
    private var margin: CGFloat = 5
    private let disposeBag = DisposeBag()
    
    final public func updateViews(_ items: [JMReadMenuItem]) {
        self.models = items
        
        for (index, model) in items.enumerated() {
            let btn = UIButton(type: .system)
            btn.layer.cornerRadius = 10
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.white.cgColor
            
            btn.tag = index + 200
            addSubview(btn)
            btn.setImage(model.image?.image, for: .normal)
            btn.setTitle(model.title, for: .normal)
            btn.setTitleColor(model.titleColor, for: .normal)
//            btn.backgroundColor = UIColor.hexString("")
            btn.jmAddAction { [weak self](_) in
                self?.jmRouterEvent(eventName: model.event, info: model)
                model.isSelect.onNext(true)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let count = CGFloat(self.subviews.count)
        let width = (self.bounds.size.width - (count+1) * margin) / count
        for (index, view) in self.subviews.enumerated() {
            view.frame = CGRect.Rect( margin + (margin + width) * CGFloat(index), 0, width, self.jmHeight)
            (view as? UIButton)?.jmImagePosition(style: .top, spacing: 10)
        }
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
