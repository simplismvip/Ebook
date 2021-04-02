//
//  JMReadPageContrller.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import UIKit
import ZJMKit
import SnapKit
import RxCocoa
import RxSwift

public class JMReadPageContrller: JMBaseController {
    internal let menuView = JMReadMenuContainer()
    public let bookTitle = UILabel()
    public let page = UILabel()
    public let activity = UIActivityIndicatorView()
    let vmodel = JMEpubVModel()
    let disposeBag = DisposeBag()
    
    lazy var colleView: JMBaseCollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.scrollDirection = JMReadConfig.share.scrollDirection.scrollDirection()
        let collectionView = JMBaseCollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(JMReadPageView.self, forCellWithReuseIdentifier: kReuseCellIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate(10)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binder()
        addGesture()
        registerMenuEvent()
    }

}

extension JMReadPageContrller {
    func addGesture() {
//        let swipLeft = UISwipeGestureRecognizer()
//        swipLeft.direction = .left
//        view.addGestureRecognizer(swipLeft)
//        swipLeft.rx.event.bind(to: menuView.rx.leftSwipe).disposed(by: disposeBag)
//
//        let swipRight = UISwipeGestureRecognizer()
//        swipRight.direction = .right
//        view.addGestureRecognizer(swipRight)
//        swipRight.rx.event.bind(to: menuView.rx.rightSwipe).disposed(by: disposeBag)
        
//        let tapGes = UITapGestureRecognizer()
//        tapGes.delegate = self
//        tapGes.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tapGes)
//        tapGes.rx.event.bind(to: menuView.rx.tapGesture).disposed(by: disposeBag)
//        menuView.showOrHide.bind(to: menuView.rx.hideOrShow).disposed(by: disposeBag)
        
        jmRegisterEvent(eventName: kEventNameWebTapGestureAction, block: { [weak self](x) in
            if let x = x as? CGFloat {
                self?.menuView.tapActionSwitchMenu(x)
                print(x)
            }
        }, next: false)
    }
}

extension JMReadPageContrller: UIGestureRecognizerDelegate {
    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            return true
        }else {
            return false
        }
    }
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
