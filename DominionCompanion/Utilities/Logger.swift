//
//  Logger.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation

class Logger {
    static let shared = Logger()
    
    private let formatter = DateFormatter()
    
    init() {
        formatter.dateFormat = "MM-dd-YYYY HH:mm:ss"
    }
    
    var level: Level = .telemetry
    
    func t(_ message: String) {
        log(level: .telemetry, message: message)
    }
    
    func d(_ message: String) {
        log(level: .debug, message: message)
    }
    
    func i(_ message: String) {
        log(level: .info, message: message)
    }
    
    func w(_ message: String) {
        log(level: .warning, message: message)
    }
    
    func e(_ message: String) {
        log(level: .error, message: message)
    }
    
    private func log(level: Level, message: String) {
        guard level.shouldLog(at: self.level) else { return }
        print("[\(formatter.string(from: Date()))][\(level.rawValue)]: \(message)")
    }
    
}

enum Level: String {
    case telemetry
    case debug
    case info
    case warning
    case error
    
    func shouldLog(at currentLevel: Level) -> Bool {
        switch self {
        case .telemetry:
            return currentLevel == .telemetry
        case .debug:
            return currentLevel == .telemetry || currentLevel == .debug
        case .info:
            return [Level.telemetry, Level.debug, Level.info].contains(currentLevel)
        case .warning:
            return currentLevel != .error
        case .error:
            return true
        }
    }
}
