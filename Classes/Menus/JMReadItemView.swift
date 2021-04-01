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
    public var margin: CGFloat = 5
    internal var models = [JMReadMenuItem]()
    private let disposeBag = DisposeBag()
    
    final public func updateViews(_ items: [JMReadMenuItem]) {
        self.models = items
        for (index, model) in items.enumerated() {
            let btn = UIButton(type: .custom)
            btn.tag = index + 200
            addSubview(btn)
            configItem(btn, model)
            
            btn.jmAddAction { [weak self](sender) in
                if let items = self?.models {
                    for item in items {
                        if item === model, let select = try? model.isSelect.value() {
                            model.isSelect.onNext(!select)
                        }else {
                            item.isSelect.onNext(false)
                        }
                    }
                }
                
                self?.jmRouterEvent(eventName: model.event, info: model)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let count = CGFloat(self.subviews.count)
        let width = (self.bounds.size.width - (count+1) * margin) / count
        for (index, view) in self.subviews.enumerated() {
            view.frame = CGRect.Rect( margin + (margin + width) * CGFloat(index), 0, width, self.jmHeight)
            if models[view.tag - 200].type == .MainBottom, let target = view as? UIButton {
                target.jmImagePosition(style: .top, spacing: 10)
            }
        }
    }
    
    func configItem(_ btn: UIButton, _ model: JMReadMenuItem) {
        switch model.type {
        case .BkgColor:
            if let colorStr = model.bkgColor {
                btn.layer.cornerRadius = 10
                btn.backgroundColor = UIColor(rgba: colorStr)
                model.isSelect.asObserver().subscribe (onNext:{ (select) in
                    btn.layer.borderWidth = select ? 1 : 0
                    btn.layer.borderColor = UIColor.red.cgColor
                }).disposed(by: disposeBag)
            }
            
        case .MainBottom:
            btn.setTitle(model.title, for: .normal)
            btn.setTitleColor(UIColor.jmRGB(31, 31, 31), for: .normal)
            btn.titleLabel?.font = UIFont.jmRegular(10)
            btn.setImage(model.image?.image?.origin, for: .normal)
            
        case .TopLeft, .TopRight:
            btn.setImage(model.image?.image?.origin, for: .normal)
            
        case .PageFont, .PageFlip, .PageLight, .PlayRate, .PlayStyle:
            btn.setTitle(model.title, for: .normal)
            model.isSelect.asObserver().subscribe (onNext:{ (select) in
                btn.setTitleColor(select ? UIColor(rgba: "#66B3FF") : UIColor.white, for: .normal)
                btn.titleLabel?.font = select ? UIFont.jmMedium(20) : UIFont.jmRegular(17)
            }).disposed(by: disposeBag)
        
        case .PlayOrPause:
            if model.identify == .PlayOrPause {
                model.isSelect.asObserver()
                    .map { $0 ? "pause-icon" : "play-icon" }
                    .map { $0.image?.origin }
                    .bind(to: btn.rx.image()).disposed(by: disposeBag)
            }else {
                btn.setImage(model.image?.image?.origin, for: .normal)
            }
            
        case .nonetype:
            print("")
        }
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
