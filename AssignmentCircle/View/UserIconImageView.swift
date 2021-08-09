//
//  UserIconImageView.swift
//  AssignmentCircle
//
//  Created by Fujino Suita on 2021/08/07.
//

import UIKit

final class UserIconImageView: UIImageView {
    private let size: CGFloat
    private let panHandler: (UIPanGestureRecognizer) -> Void
    private let longPressHandler: (UILongPressGestureRecognizer) -> Void

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        size: CGFloat,
        panHandler: @escaping (UIPanGestureRecognizer) -> Void,
        longPressHandler: @escaping (UILongPressGestureRecognizer) -> Void
    ) {
        self.size = size
        self.panHandler = panHandler
        self.longPressHandler = longPressHandler
        super.init(frame: .init(origin: .zero, size: .init(width: size, height: size)))

        isUserInteractionEnabled = true
        backgroundColor = .gray
        contentMode = .scaleAspectFill
        layer.cornerRadius = size / 2

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0
        longPressGestureRecognizer.delegate = self
        addGestureRecognizer(longPressGestureRecognizer)
    }

    func configure(url: URL) {
        guard let imageData = try? Data(contentsOf: url) else {
            return
        }

        image = .init(data: imageData)
    }

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        panHandler(sender)
    }

    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        longPressHandler(sender)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension UserIconImageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
