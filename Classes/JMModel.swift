//
//  JMModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation
import EPUBKit
import RxSwift
import RxRelay
import RxCocoa

// 图书数据模型
class JMEpubWapper<T> {
    let item: T
    init(_ item: T) {
        self.item = item
    }
}

class JMEpubVModel: NSObject, VMProtocol {
    let disposeBag = DisposeBag()
    let models = BehaviorRelay<[JMEpubWapper<EPUBSpineItem>]>(value: [])
    var sections = BehaviorRelay<[JMEpubWapper<EPUBDocument>]>(value: [])
    
    struct JMInput {
        let path: BehaviorRelay<String>
        init(path: String) {
            self.path = BehaviorRelay<String>(value: path)
        }
    }
    
    struct JMOutput {
        let openBook = PublishSubject<Bool>()
        var refresh = BehaviorRelay<JMEpubStatus>(value: .OpenInit)
        let items: Driver<[JMEpubWapper<EPUBSpineItem>]>
        
        init(items: Driver<[JMEpubWapper<EPUBSpineItem>]>) {
            self.items = items
        }
    }
    
    func transform(input: JMInput) -> JMOutput {
        let output = JMOutput(items: models.asDriver())
        output.refresh.accept(.Opening("正在打开图书"))
        input.path.asObservable().subscribe(onNext: { (path) in
            do{
                let url = URL(fileURLWithPath: path)
                let document = try EPUBParser().parse(documentAt: url)
                
                let spineItems = document.spine.items.map { return JMEpubWapper($0) }
                self.models.accept(spineItems)
                
                self.sections.accept([JMEpubWapper(document)])
                
                print(url.lastPathComponent)
                output.refresh.accept(.OpenSuccess("打开成功"))
            }catch {
                output.refresh.accept(.OpenFail("解析图书失败"))
                print("⚠️⚠️⚠️⚠️⚠️打开 \(error.localizedDescription)失败⚠️⚠️⚠️⚠️⚠️")
            }
        })
        .disposed(by: self.disposeBag)
        return output
    }
}

extension JMEpubVModel {
    
}

