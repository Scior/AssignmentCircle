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
        static let iconCount = 6
    }

    private var iconViews: [UserIconImageView] = []
    private let circularGuideView = CircularGuideView()
    private let calculator = CicularViewPositionCaluculator(
        circleRadius: Const.circleRadius,
        iconCount: Const.iconCount,
        speed: 0.1
    )
    private let imageURLs: [String] = [
        "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user1.png?alt=media",
        "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user2.png?alt=media",
        "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user3.png?alt=media",
        "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user4.png?alt=media",
        "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user5.png?alt=media",
        "https://firebasestorage.googleapis.com/v0/b/android-technical-exam.appspot.com/o/user6.png?alt=media"
    ]

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

        for (index, url) in imageURLs.enumerated() {
            let imageView = UserIconImageView(size: 50) { [weak self] sender in
                self?.handlePan(sender, index: index)
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
            calculator.change(mode: .manual)
        case .changed:
            let translation = sender.translation(in: view)

            calculator.updateAngle(by: translation, index: index)
        default:
            if calculator.isClockwise {
                calculator.change(mode: .clockwise)
            } else {
                calculator.change(mode: .counterclockwise)
            }
        }
    }
}

