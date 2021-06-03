//
//  JMParserError.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/23.
//

import Foundation

public enum JMParserError {
    case unzipFailed(reason: Error)
    case containerMissing
    case contentPathMissing
    case tableOfContentsMissing
}

// MARK: - LocalizedError
extension JMParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unzipFailed:
            return "解压文件时发生错误❌❌❌"
        case .containerMissing:
            return "找不到container.xml文件"
        case .contentPathMissing:
            return "找不到content文件路径"
        case .tableOfContentsMissing:
            return "找不到oc.ncx文件"
        }
    }

    public var failureReason: String? {
        switch self {
        case .unzipFailed:
            return "压缩包无法解压缩"
        case .containerMissing:
            return "container.xml文件缺失"
        case .contentPathMissing:
            return "无法找到container.xml文件"
        case .tableOfContentsMissing:
            return "toc中无法找到spine文件ID"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .unzipFailed:
            return "解压.epub文件失败🆘🆘🆘"
        case .containerMissing:
            return "container.xml 文件缺失❗️❗️❗️"
        case .contentPathMissing:
            return "container.xml 路径不正确❗️❗️❗️"
        case .tableOfContentsMissing:
            return "TOC 解析错误🆘🆘🆘"
        }
    }
}

