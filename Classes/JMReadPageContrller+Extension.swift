//
//  JMReadPageContrller+Extension.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/30.
//

import UIKit

// TODO: -- UI Method --
extension JMReadPageContrller {
    func setupUI() {
        view.addSubview(bookTitle)
        view.addSubview(colleView)
        view.addSubview(page)
        view.addSubview(activity)
        view.addSubview(menuView)
        menuView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        activity.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.centerX.centerY.equalTo(view)
        }
        
        bookTitle.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
            make.height.equalTo(34)
        }
        
        page.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(28)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }else {
                make.bottom.equalTo(view.snp.bottom)
            }
        }
        
        colleView.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.top.equalTo(bookTitle.snp.bottom)
            make.bottom.equalTo(page.snp.top)
        }
        
        configUI()
    }
    
    func configUI() {
        view.backgroundColor = UIColor.white
        bookTitle.text = "朝鲜战争：李奇微回忆录"
        page.text = "114"
        bookTitle.jmConfigLabel(alig: .center, font: UIFont.jmBold(20), color: UIColor.jmHexColor("#333333"))
        page.jmConfigLabel(alig: .center, font: UIFont.jmBold(20), color: UIColor.jmHexColor("#333333"))
        
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.color = UIColor.gray
    }
}

// TODO: -- RxSwift Method --
extension JMReadPageContrller {
    
    func binder() {
        let input = JMEpubVModel.JMInput(path: "/Users/jl/Desktop/EPUB/TianXiaDaoZong.epub")
        let output = vmodel.transform(input: input)
        output.refresh.bind(to: rx.isLoading).disposed(by: disposeBag)
        output.items.asObservable()
            .bind(to: colleView.rx.items(cellIdentifier: kReuseCellIdentifier, cellType: JMReadPageView.self)) { [weak self](row, model, cell) in
                self?.bookTitle.text = row.description
            }
            .disposed(by: disposeBag)
        colleView.rx.setDelegate(self).disposed(by: disposeBag)
        
        rx.viewWillAppear.asObservable().subscribe { [weak self](_) in
            self?.navigationController?.setNavigationBarHidden(true, animated: false)
        }.disposed(by: disposeBag)
        
        rx.viewWillDisappear.asObservable().subscribe { [weak self](_) in
            self?.navigationController?.setNavigationBarHidden(false, animated: false)
        }.disposed(by: disposeBag)
    }
}
