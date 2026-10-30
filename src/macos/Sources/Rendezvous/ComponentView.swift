// ComponentView.swift
// Spacecraft component view

import SwiftUI

/// Spacecraft component view
struct ComponentView: View {
    let component: ComponentProperties

    var body: some View {
        VStack {
            Image(systemName: component.type.iconName)
                .font(.system(size: 24))
                .foregroundColor(component.type.color)

            Text(component.name)
                .font(.caption)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: 60, height: 80)
        .background(component.type.color.opacity(0.7))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}