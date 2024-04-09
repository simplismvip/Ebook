//
//  JMBookSpeech.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/17.
//

import Foundation
import AVFoundation

public class JMSpeechModel {
    public var preDelay: TimeInterval = 0.0
    public var postDelay: TimeInterval = 0.0
    public var rate: Float = 0.52
    public var pitch: Float = 1.0
    public var volume: Float = 1.0
    public var lang: String = "zh-CN"
}

final public class JMBookSpeech: NSObject {
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
                JMLogger.error("error")
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
            JMLogger.error("error")
        }
    }
    
    public func readImmediately(_ page: JMBookPage, clear: Bool) {
        synthesizer.stopSpeaking(at: .immediate)
        if !synthesizer.isSpeaking {
            let attri = page.attribute
            let utterance = createUtter(attri)
            synthesizer.speak(utterance)
        } else {
            play = false
            JMLogger.error("播放完成")
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

extension JMBookSpeech: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
//        jmSendMsg(msgName: kMsgNamePlayBookRefashText, info: characterRange as MsgObjc)
        let rangeStr = utterance.attributedSpeechString.attributedSubstring(from: characterRange)
//        JMLogger.debug(utterance.attributedSpeechString)
//        JMLogger.debug(characterRange)
        JMLogger.debug(rangeStr)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        JMLogger.debug("didStart")
        play = true
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        play = false
    }
}
