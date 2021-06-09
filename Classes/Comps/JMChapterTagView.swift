//
//  JMChapterTagView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/21.
//

import UIKit
import ZJMKit

struct JMChapterTag {
    var text: String
    var timeStr: String
    var charter: Int = 0
    var location: Int = 0
}

final class JMChapterTagView: JMBookBaseView {
    private let s_width = UIScreen.main.bounds.size.width - 60
    private var dataSource = [JMChapterTag]()
    private var bkgColor: UIColor = UIColor.menuBkg
    private var textColor: UIColor = UIColor.charterTextColor
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(JMChapterTagCell.self, forCellReuseIdentifier: "kReuseCellIdentifier")
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
    
    public func updateChartper(_ items: [JMChapterTag]) {
        if dataSource.isEmpty || dataSource.count != items.count {
            dataSource = items
            tableView.reloadData()
        }
    }
    
    override func changeBkgColor(config: JMBookConfig) {
        super.changeBkgColor(config: config)
        bkgColor = config.subViewColor()
        textColor = config.textColor()
        tableView.backgroundColor = bkgColor
        tableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMChapterTagView: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource[indexPath.row]
        let height =  JMBookTools.contentHight(text: item.text, textID: item.timeStr, maxW: s_width, font: UIFont.jmAvenir(15)) + 30
        return (height > 44) ? height : 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "kReuseCellIdentifier")
        if cell == nil { cell = JMChapterTagCell(style: .default, reuseIdentifier: "kReuseCellIdentifier") }
        let newCell = cell as! JMChapterTagCell
        newCell.setup(dataSource[indexPath.row], config: config)
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jmRouterEvent(eventName: kEventNameDidSelectChapter, info: dataSource[indexPath.row] as MsgObjc)
    }
}


// MARK: -- Cell
class JMChapterTagCell: JMBaseTableViewCell {
    private let textL = UILabel()
    private let timeL = UILabel()
    private let charter = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textL.numberOfLines = 0
        textL.jmConfigLabel(font: .jmAvenir(15), color: UIColor.charterTextColor)
        timeL.jmConfigLabel(alig: .right, font: .jmAvenir(12), color: .gray)
        charter.jmConfigLabel(font: .jmAvenir(12), color: .gray)
        
        contentView.addSubview(charter)
        contentView.addSubview(textL)
        contentView.addSubview(timeL)
        
        textL.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            make.top.equalTo(contentView).offset(6)
            make.bottom.equalTo(snp.bottom).offset(-20)
        }
        
        charter.snp.makeConstraints { (make) in
            make.left.equalTo(textL)
            make.height.equalTo(20)
            make.bottom.equalTo(snp.bottom)
        }
        
        timeL.snp.makeConstraints { (make) in
            make.right.equalTo(textL)
            make.height.equalTo(20)
            make.bottom.equalTo(snp.bottom)
        }
    }

    func setup(_ item: JMChapterTag, config: JMBookConfig?) {
        textL.text = item.text
        timeL.text = item.timeStr.jmFormatTspString("yyyy/MM/dd HH:mm:ss")
        charter.text = "第\(item.charter)章"
        
        textL.textColor = config?.textColor()
        timeL.textColor = config?.textColor()
        charter.textColor = config?.textColor()
        backgroundColor = config?.subViewColor()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️") }
}

