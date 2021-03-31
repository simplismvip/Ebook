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
        collectionView.backgroundColor = UIColor.red
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binder()
        registerMenuEvent()
    }
}

extension JMReadPageContrller: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.jmWidth, height: collectionView.jmHeight)
        if #available(iOS 11.0, *) {
            let orientation = UIDevice.current.orientation
            if orientation == .portrait || orientation == .portraitUpsideDown {
                if JMReadConfig.share.scrollDirection == .horizontal {
                    size.height = size.height - view.safeAreaInsets.bottom
                }
            }
        }
        return size
    }
}
