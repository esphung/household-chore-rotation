//
//  ScreenSelectionView.swift
//  Household Chore Rotation
//
//  Created by GitHub Copilot on 4/22/26.
//

import SwiftUI

struct ScreenSelectionView: View {
	private enum Destination {
		case home
		case test
	}

	private struct ScreenOption: Identifiable {
		let id: String
		let title: String
		let subtitle: String
		let systemImage: String
		let accentColor: Color
		let destination: Destination
	}

	private var options: [ScreenOption] {
		[
			ScreenOption(
				id: "home",
				title: "Home Screen",
				subtitle: "View and rotate current chores",
				systemImage: "house.fill",
				accentColor: .teal,
				destination: .home
			),
			ScreenOption(
				id: "test",
				title: "Test Screen",
				subtitle: "Validate state and actions",
				systemImage: "hammer.fill",
				accentColor: .blue,
				destination: .test
			),
		]
	}

	var body: some View {
		NavigationStack {
			VStack(spacing: 16) {
				ForEach(options) { option in
					NavigationLink {
						destinationView(for: option.destination)
					} label: {
						selectionCard(
							title: option.title,
							subtitle: option.subtitle,
							systemImage: option.systemImage,
							accentColor: option.accentColor
						)
					}
					.buttonStyle(.plain)
				}

				Spacer(minLength: 0)
			}
			.padding(20)
			.navigationTitle("Choose a Screen")
		}
	}

	@ViewBuilder
	private func destinationView(for destination: Destination) -> some View {
		switch destination {
		case .home:
			HomeView()
		case .test:
			TestView()
		}
	}

	private func selectionCard(
		title: String,
		subtitle: String,
		systemImage: String,
		accentColor: Color
	) -> some View {
		HStack(spacing: 14) {
			Image(systemName: systemImage)
				.font(.title3.weight(.semibold))
				.frame(width: 38, height: 38)
				.background(accentColor.opacity(0.15))
				.foregroundStyle(accentColor)
				.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

			VStack(alignment: .leading, spacing: 3) {
				Text(title)
					.font(.headline)
				Text(subtitle)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}

			Spacer()

			Image(systemName: "chevron.right")
				.font(.footnote.weight(.bold))
				.foregroundStyle(.secondary)
		}
		.padding(16)
		.background(Color(.secondarySystemBackground))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
	}
}

#Preview {
	ScreenSelectionView()
		.environment(ChoreStore(chores: ["Dishes", "Vacuum", "Laundry", "Trash"]))
}
