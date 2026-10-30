// Camera.swift
// Camera system for zoomable, panning view

import Foundation
import SwiftUI

class Camera: ObservableObject {
    @Published var centerX: Double = 0
    @Published var centerY: Double = 0
    @Published var zoom: Double = 1.0

    // Smooth zoom interpolation
    @Published private var targetZoom: Double = 1.0
    @Published private var targetCenterX: Double = 0
    @Published private var targetCenterY: Double = 0

    private var animating: Bool = false
    private var animationTimer: Timer?

    // Zoom ranges
    static let minZoom: Double = 0.00005   // Solar system scale
    static let maxZoom: Double = 100.0     // Ground level detail

    init() {
        targetZoom = zoom
        targetCenterX = centerX
        targetCenterY = centerY
    }

    /// Set camera to follow a point smoothly
    func lookAt(_ x: Double, _ y: Double) {
        targetCenterX = x
        targetCenterY = y
        if !animating {
            animateToTarget()
        }
    }

    /// Zoom in (toward center of screen)
    func zoomIn(factor: Double = 1.5) {
        targetZoom = min(targetZoom * factor, Camera.maxZoom)
        if !animating {
            animateToTarget()
        }
    }

    /// Zoom out
    func zoomOut(factor: Double = 1.5) {
        targetZoom = max(targetZoom / factor, Camera.minZoom)
        if !animating {
            animateToTarget()
        }
    }

    /// Set exact values (for initial state)
    func set(centerX: Double, centerY: Double, zoom: Double) {
        self.centerX = centerX
        self.centerY = centerY
        self.zoom = zoom
        targetCenterX = centerX
        targetCenterY = centerY
        targetZoom = zoom
    }

    private func animateToTarget() {
        animating = true
        let startX = centerX
        let startY = centerY
        let startZoom = zoom
        let duration: Double = 0.3
        let startTime = Date().timeIntervalSince1970

        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            let elapsed = Date().timeIntervalSince1970 - startTime
            let t = min(elapsed / duration, 1.0)
            let ease = 1.0 - pow(1.0 - t, 3) // ease-out cubic

            self.centerX = startX + (self.targetCenterX - startX) * ease
            self.centerY = startY + (self.targetCenterY - startY) * ease
            self.zoom = startZoom + (self.targetZoom - startZoom) * ease

            if t >= 1.0 {
                self.animating = false
                self.animationTimer?.invalidate()
                self.animationTimer = nil
            }
        }
    }

    /// Convert world coordinates to screen coordinates
    func worldToScreen(worldX: Double, worldY: Double, canvasWidth: CGFloat, canvasHeight: CGFloat) -> CGPoint {
        let screenX = (worldX - centerX) * zoom * 1000 + canvasWidth / 2
        let screenY = -(worldY - centerY) * zoom * 1000 + canvasHeight / 2
        return CGPoint(x: screenX, y: screenY)
    }

    /// Convert screen coordinates to world coordinates
    func screenToWorld(screenX: CGFloat, screenY: CGFloat, canvasWidth: CGFloat, canvasHeight: CGFloat) -> CGPoint {
        let worldX = (screenX - canvasWidth / 2) / (zoom * 1000) + centerX
        let worldY = -(screenY - canvasHeight / 2) / (zoom * 1000) + centerY
        return CGPoint(x: worldX, y: worldY)
    }

    /// Check if a world point is visible on screen
    func isVisible(worldX: Double, worldY: Double, canvasWidth: CGFloat, canvasHeight: CGFloat) -> Bool {
        let screen = worldToScreen(worldX: worldX, worldY: worldY, canvasWidth: canvasWidth, canvasHeight: canvasHeight)
        return screen.x >= -100 && screen.x <= canvasWidth + 100 &&
               screen.y >= -100 && screen.y <= canvasHeight + 100
    }
}
