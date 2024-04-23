//
//  ConsoleViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class ConsoleViewModel: Echoable {
    
    @Published private(set) var isActivePublisher: AnyPublisher<Bool, Never>
    private(set) var pasteboard: Pasteboard
    
    internal init(_ environment: Environment, publisher: AnyPublisher<Bool, Never>) {
        pasteboard = switch environment {
        case .production:
            SystemPasteboard.shared
        case .test:
            MockPasteboard.shared
        }
        isActivePublisher = publisher
    }
}

// MARK: - Methods
extension ConsoleViewModel {
    
    var fullLogs: String {
        Buffer.shared.fullLogs
    }
}

// MARK: - Action
extension ConsoleViewModel {
    
    internal enum Action {
        case divider
        case clear
        case copy
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .divider:
            let log = Log(text: "==========", level: .info)
            Buffer.shared.send(.append(log: log))
        case .clear:
            Buffer.shared.send(.clear)
        case .copy:
            pasteboard.string = fullLogs
        }
    }
}

// MARK: - Enums
extension ConsoleViewModel {
    
    internal enum Environment {
        case production
        case test
    }
}
