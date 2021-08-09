//
//  CicularViewPositionCalculator.swift
//  AssignmentCircle
//
//  Created by Fujino Suita on 2021/08/07.
//

import CoreGraphics
import Foundation

final class CicularViewPositionCalculator {
    // MARK: - Properties

    enum Mode {
        /// 時計回り
        case clockwise
        /// 反時計回り
        case counterclockwise
        /// 自動でアニメーションしない
        case manual
    }

    private let circleRadius: CGFloat
    private let iconCount: Int
    private let speed: CGFloat
    private let unitAngle: CGFloat

    private var angle: CGFloat
    private var transformCache: [CGAffineTransform] = []
    private var previousTime: Date?
    private var mode: Mode = .clockwise
    private var isClockwise: Bool = true

    // MARK: - Lifecycle

    init(circleRadius: CGFloat, iconCount: Int, speed: CGFloat, angle: CGFloat = 0) {
        self.circleRadius = circleRadius
        self.iconCount = iconCount
        self.speed = speed
        self.angle = angle
        self.unitAngle = .pi * 2 / CGFloat(iconCount)
    }

    // MARK: - Methods

    /// 円上のn番目のアイテムの位置を計算して、中心からの移動量で返す.
    /// - Parameter index: アイテムのindex(0-based)
    /// - Returns: translationのみ入った`CGAffineTransform`
    func calculateAffineTransform(for index: Int) -> CGAffineTransform {
        let defaultAngle: CGFloat = unitAngle * CGFloat(index)
        let angle = defaultAngle + self.angle

        return .init(translationX: circleRadius * cos(angle), y: circleRadius * sin(angle))
    }

    /// 回転アニメーションをmodeに応じた方向に進める.
    /// 回転量は前回からの時間の経過によって変化させる.
    func advance() {
        if let previousTime = previousTime {
            let diffAngle = CGFloat(Date().timeIntervalSince(previousTime)) * speed
            switch mode {
            case .clockwise:
                angle += diffAngle
            case .counterclockwise:
                angle -= diffAngle
            case .manual:
                break
            }
        }
        previousTime = Date()
    }

    /// 回転を開始する. `isClockwise`に応じて回転方向を決める.
    func startRotating() {
        if isClockwise {
            self.mode = .clockwise
        } else {
            self.mode = .counterclockwise
        }
    }

    /// Modeを`manual`に変更して回転を停止する. その時点での座標をキャッシュする.
    func stopRotating() {
        guard self.mode != .manual else {
            return
        }

        self.mode = .manual
        transformCache = (0..<iconCount).map(calculateAffineTransform(for:))
    }

    /// Modeを変更する. `manual`を指定した場合その時点での座標をキャッシュする.
    /// - Parameter mode: アニメーションのモード
    func change(mode: Mode) {
        guard self.mode != mode else {
            return
        }

        self.mode = mode
        if mode == .manual {
            transformCache = (0..<iconCount).map(calculateAffineTransform(for:))
        }
    }

    /// 与えられた位置に一番近い円周上の点に、アイテムを配置させるようにangleを変化させる.
    /// 前回のangleからの差で、回転方向を判定する.
    /// - Parameters:
    ///   - translation: 現在のviewからの移動量
    ///   - index: アイテムのindex(0-based)
    func updateAngle(by translation: CGPoint, index: Int) {
        guard mode == .manual, transformCache.indices.contains(index) else {
            return assertionFailure("Out of range")
        }

        let previousAngle = angle
        let transform = transformCache[index]
        let diffX = translation.x + transform.tx
        let diffY = translation.y + transform.ty
        let newAngle = atan2(diffY, diffX) - unitAngle * CGFloat(index)
        angle = newAngle

        let diffAngle = newAngle - previousAngle
        // 指を離した瞬間などに起きやすい、細かい動きは無視する. (閾値を変えることで感度を調整できる)
        if cos(diffAngle) < 1 - 1e-4 {
            isClockwise = sin(diffAngle) > 0
        }
    }
}
