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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(size: CGFloat, panHandler: @escaping (UIPanGestureRecognizer) -> Void) {
        self.size = size
        self.panHandler = panHandler
        super.init(frame: .init(origin: .zero, size: .init(width: size, height: size)))

        isUserInteractionEnabled = true
        backgroundColor = .gray
        layer.cornerRadius = size / 2

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        addGestureRecognizer(panGestureRecognizer)
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
}
