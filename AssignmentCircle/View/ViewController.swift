//
//  ViewController.swift
//  AssignmentCircle
//
//  Created by Fujino Suita on 2021/08/07.
//

import UIKit

final class ViewController: UIViewController {
    private enum Const {
        static let circleRadius: CGFloat = UIScreen.main.bounds.width * 0.4
        static let iconSize: CGFloat = UIScreen.main.bounds.width * 0.16
        static let imageURLs: [String] = [
            "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user1.png?alt=media",
            "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user2.png?alt=media",
            "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user3.png?alt=media",
            "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user4.png?alt=media",
            "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user5.png?alt=media",
            "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user6.png?alt=media"
        ]
    }

    private var iconViews: [UserIconImageView] = []
    private let circularGuideView = CircularGuideView()
    private let calculator = CicularViewPositionCalculator(
        circleRadius: Const.circleRadius,
        iconCount: Const.imageURLs.count,
        speed: 0.1
    )

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        view.addSubview(circularGuideView)
        circularGuideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circularGuideView.widthAnchor.constraint(equalToConstant: (Const.circleRadius + CircularGuideView.Const.lineWidth) * 2),
            circularGuideView.heightAnchor.constraint(equalTo: circularGuideView.widthAnchor),
            circularGuideView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularGuideView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        for (index, url) in Const.imageURLs.enumerated() {
            let imageView = UserIconImageView(size: Const.iconSize) { [weak self] sender in
                self?.handlePan(sender, index: index)
            } longPressHandler: { [weak self] sender in
                self?.handleLongPress(sender)
            }
            imageView.center = view.center
            if let url = URL(string: url) {
                imageView.configure(url: url)
            }

            view.addSubview(imageView)
            iconViews.append(imageView)
        }

        let displayLink = CADisplayLink(target: self, selector: #selector(updateIcons(_:)))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: .main, forMode: .common)
    }

    @objc private func updateIcons(_ displayLink: CADisplayLink) {
        for (index, imageView) in iconViews.enumerated() {
            imageView.transform = calculator.calculateAffineTransform(for: index)
        }
        calculator.advance()
    }

    private func handlePan(_ sender: UIPanGestureRecognizer, index: Int) {
        switch sender.state {
        case .began:
            calculator.stopRotating()
        case .changed:
            let translation = sender.translation(in: view)

            calculator.updateAngle(by: translation, index: index)
        default:
            calculator.startRotating()
        }
    }

    private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            calculator.stopRotating()
        case .ended:
            calculator.startRotating()
        default:
            break
        }
    }
}

