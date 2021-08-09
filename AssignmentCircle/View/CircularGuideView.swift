//
//  CircularGuideView.swift
//  AssignmentCircle
//
//  Created by Fujino Suita on 2021/08/07.
//

import UIKit

final class CircularGuideView: UIView {
    enum Const {
        static let lineWidth: CGFloat = 1
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(
            arcCenter: .init(x: rect.midX, y: rect.midY),
            radius: rect.width / 2 - Const.lineWidth,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        UIColor.white.setStroke()
        path.lineWidth = Const.lineWidth
        path.stroke()
    }
}
