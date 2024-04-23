//
//  ConsoleWindow.swift
//
//
//  Created by Lukas on 4/22/24.
//

import Combine
import UIKit

internal final class ConsoleWindow: UIWindow {
    
    private let viewModel: ConsoleViewModel
    private let interactiveView = UIView()
    private let bubbleView = BubbleView()
    
    init(windowScene: UIWindowScene, publisher: AnyPublisher<Bool, Never>) {
        viewModel = ConsoleViewModel(.production, publisher: publisher)
        super.init(windowScene: windowScene)
        let rootViewController = ConsoleViewController(viewModel: viewModel, interactiveView: interactiveView, bubbleView: bubbleView)
        self.rootViewController = rootViewController
        bubbleView.prepare(parentView: rootViewController.view)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if viewModel.windowState == .closed {
            return bubbleView.frame.contains(point) ? super.hitTest(point, with: event) : nil
        } else {
            return interactiveView.frame.contains(point) ? super.hitTest(point, with: event) : nil
        }
    }
}

// MARK: - UI
extension ConsoleWindow {
    
    private func setupUI() {
        backgroundColor = .clear
        windowLevel = .alert + 1
    }
}
