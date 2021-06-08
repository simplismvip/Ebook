//
//  JMChapterView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/8.
//

import UIKit
import ZJMKit

final class JMChapterView: JMBookBaseView {
    private let s_width = UIScreen.main.bounds.size.width - 60
    private var dataSource = [JMBookCharpter]()
    private var currCharter = 0
    private var config: JMBookConfig?
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(JMBookChapterCell.self, forCellReuseIdentifier: "kReuseCellIdentifier")
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    public func updateChartper(_ items: [JMBookCharpter], _ title: String, _ currCharter: Int) {
        if dataSource.isEmpty || dataSource.count != items.count {
            dataSource = items
            tableView.reloadData()
            self.currCharter = currCharter
        }
    }
    
    public func reverse() {
        dataSource.reverse()
        tableView.reloadData()
    }

    override func changeBkgColor(config: JMBookConfig) {
        super.changeBkgColor(config: config)
        self.config = config
        tableView.backgroundColor = config.subViewBkgColor()
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMChapterView: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource[indexPath.row]
        if let title = item.charpTitle {
            let height = JMBookTools.contentHight(text: title, textID: item.idref, maxW: s_width, font: UIFont.jmAvenir(15)) + 20
            return (height > 44) ? height : 44
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "kReuseCellIdentifier")
        if cell == nil { cell = JMBookChapterCell(style: .default, reuseIdentifier: "kReuseCellIdentifier") }
        let newCell = cell as! JMBookChapterCell
        newCell.setup(dataSource[indexPath.row],currCharter)
        if let config = self.config {
            newCell.changeBkgColor(config: config)
        }
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.location.chapter == currCharter {
            jmRouterEvent(eventName: kEventNameDidSelectChapter, info: nil)
        }else {
            jmRouterEvent(eventName: kEventNameDidSelectChapter, info: model as MsgObjc)
        }
    }
}

// MARK: -- Cell
class JMBookChapterCell: JMBaseTableViewCell {
    private let index = UILabel()
    private let lock = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.menuBkg
        selectionStyle = .none
        index.lineBreakMode = .byWordWrapping
        index.numberOfLines = 0
        index.translatesAutoresizingMaskIntoConstraints = false
        index.textColor = UIColor.charterTextColor
        index.font = UIFont.jmAvenir(15)
        lock.jmConfigLabel(alig: .right, font: .jmAvenir(12), color: .gray)
        
        contentView.addSubview(index)
        contentView.addSubview(lock)
        
        index.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-60)
            make.height.equalTo(self)
            make.bottom.equalTo(snp.bottom)
        }
        
        lock.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20)
            make.height.equalTo(self)
            make.bottom.equalTo(snp.bottom)
        }
    }

    func setup(_ item: JMBookCharpter, _ currCharter: Int) {
        index.text = item.charpTitle
        lock.text = "免费"
        if item.location.chapter == currCharter {
            index.textColor = UIColor.menuSelColor
        }else {
            index.textColor = UIColor.charterTextColor
        }
    }
    
    func changeBkgColor(config: JMBookConfig) {
        index.textColor = config.textColor()
        lock.textColor = config.textColor()
        backgroundColor = config.subViewBkgColor()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️") }
}
