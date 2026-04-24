//
//  ChoreCompletionButton.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct ChoreCompletionButton: View {
		let isCompleted: Bool
		let action: () -> Void

		var body: some View {
				Button(action: action) {
						Label(
								isCompleted ? "Undo" : "Complete",
								systemImage: isCompleted
										? "arrow.uturn.backward.circle.fill"
										: "checkmark.circle.fill"
						)
						.font(.subheadline.weight(.semibold))
				}
				.buttonStyle(.borderedProminent)
				.tint(isCompleted ? .white.opacity(0.25) : .white.opacity(0.9))
				.foregroundStyle(isCompleted ? .white.opacity(0.7) : .blue)
		}
}

#Preview {
		HStack(spacing: 16) {
				ChoreCompletionButton(isCompleted: false) {}
				ChoreCompletionButton(isCompleted: true) {}
		}
		.padding()
		.background(Color.blue)
}
