// AssemblyView.swift
// Spacecraft assembly bay with vertical stack builder

import SwiftUI

struct AssemblyView: View {
    @StateObject private var componentManager = ComponentManager()
    @State private var assembly = SpacecraftAssembly()
    @State private var selectedComponentId: String? = nil
    @State private var dragSource: ComponentProperties? = nil
    @State private var showInfo: Bool = false

    var onLaunch: () -> Void
    var onBack: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button(action: onBack) {
                        Text("← BACK")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(6)
                    }

                    Spacer()

                    Text("ASSEMBLY BAY")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.cyan)

                    Spacer()

                    Button(action: { showInfo.toggle() }) {
                        Text("i")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(width: 28, height: 28)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.9))

                // Main content
                Text("Build your rocket here")
                    .foregroundColor(.white)
                    .padding()

                Button(action: onLaunch) {
                    Text("LAUNCH")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .frame(width: 1200, height: 800)
    }
}