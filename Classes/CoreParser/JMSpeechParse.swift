//
//  JMSpeechParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/17.
//

import Foundation
import AVFoundation
import ZJMKit

public class JMSpeechModel {
    public var preDelay: TimeInterval = 0.0
    public var postDelay: TimeInterval = 0.0
    public var rate: Float = 0.52
    public var pitch: Float = 1.0
    public var volume: Float = 1.0
    public var lang: String = "zh-CN"
}

final public class JMSpeechParse: NSObject {
    private var queue = [JMBookPage]()
    private var playIndex: Int = 0
    private var utterance: AVSpeechUtterance?
    private var audioSession =  AVAudioSession()
    public var synthesizer = AVSpeechSynthesizer()
    public var play = false {
        willSet {
            if newValue {
                jmSendMsg(msgName: kMsgNamePlayBookStarting, info: nil)
            } else {
                jmSendMsg(msgName: kMsgNamePlayBookEnd, info: nil)
            }
        }
    }
    public let model: JMSpeechModel
    public var duckOthers = true {
        willSet {
            do {
                if newValue {
                    try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
                }else {
                    try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
                }
            } catch {
                print("error")
            }
        }
    }
    
    public init(_ model: JMSpeechModel) {
        self.model = model
        self.duckOthers = true
        super.init()
        synthesizer.delegate = self
        do {
            try audioSession.setActive(true)
        } catch  {
            print("error")
        }
    }
    
    public func readImmediately(_ pages: [JMBookPage], clear: Bool) {
        if pages.isEmpty {
            return
        }
        
        queue.removeAll()
        queue.append(contentsOf: pages)
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = createUtter(queue[playIndex].attribute)
        synthesizer.speak(utterance)
    }
    
    public func play(nextPage: Bool) {
        synthesizer.stopSpeaking(at: .immediate)
        nextPage ? (playIndex += 1) : (playIndex -= 1)
        if !play && !synthesizer.isSpeaking && playIndex < queue.count && playIndex > -1 {
            let attri = queue[playIndex].attribute
            let utterance = createUtter(attri)
            synthesizer.speak(utterance)
            jmSendMsg(msgName: kMsgNamePlayBookNextPage, info: nil)
        } else {
            playIndex = 0
            play = false
            print("播放完成")
        }
    }
    
    public func resume() {
        play = true
        synthesizer.continueSpeaking()
    }
    
    public func stop() {
        play = false
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    public func pause() {
        play = false
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    private func createUtter(_ attri: NSAttributedString) ->AVSpeechUtterance {
        let utterance = AVSpeechUtterance(attributedString: attri)
        utterance.rate = model.rate
        utterance.voice = AVSpeechSynthesisVoice(language: model.lang)
        utterance.preUtteranceDelay = model.preDelay
        utterance.postUtteranceDelay = model.postDelay
        utterance.pitchMultiplier = model.pitch
        return utterance
    }
}

extension JMSpeechParse: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
//        jmSendMsg(msgName: kMsgNamePlayBookRefashText, info: characterRange as MsgObjc)
//        let rangeStr = utterance.attributedSpeechString.attributedSubstring(from: characterRange)
//        print(utterance.attributedSpeechString)
//        print(characterRange)
//        print(rangeStr)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart")
//        queue.removeFirst()
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if playIndex < queue.count {
            play(nextPage: true)
            jmSendMsg(msgName: kMsgNamePlayBookNextPage, info: nil)
        } else {
            play = false
            jmSendMsg(msgName: kMsgNamePlayBookEnd, info: nil)
        }
    }
}
