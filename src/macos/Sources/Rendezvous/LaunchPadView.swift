// LaunchPadView.swift
// Launch pad scene with build button

import SwiftUI

struct LaunchPadView: View {
    let onBuildRocket: () -> Void

    var body: some View {
        ZStack {
            // Sky gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.3),
                    Color.blue.opacity(0.6),
                    Color.blue.opacity(0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                // Launch pad
                ZStack {
                    // Ground
                    Rectangle()
                        .fill(Color.green.opacity(0.8))
                        .frame(height: 150)

                    // Launch pad platform
                    Rectangle()
                        .fill(Color.gray.opacity(0.9))
                        .frame(width: 300, height: 20)
                        .offset(y: -10)

                    // Support structure
                    Rectangle()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 40, height: 80)
                        .offset(x: -80, y: -50)

                    Rectangle()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 40, height: 80)
                        .offset(x: 80, y: -50)

                    // Center tower
                    Rectangle()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 60, height: 100)

                    // Doors
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 25, height: 60)
                        .offset(x: -12, y: -20)

                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 25, height: 60)
                        .offset(x: 12, y: -20)
                }

                Spacer()

                // Build Rocket button
                Button(action: onBuildRocket) {
                    Text("BUILD ROCKET")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .buttonStyle(GradientButtonStyle())

                Spacer()
                    .frame(height: 50)
            }

            // Title
            VStack {
                Text("RENDEZVOUS")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                Text("v0.1.0")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .offset(y: 10)

                Spacer()
            }
        }
    }
}

// MARK: - Gradient Button Style
struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}