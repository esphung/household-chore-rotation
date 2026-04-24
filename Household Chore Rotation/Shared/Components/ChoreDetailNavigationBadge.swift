//
//  ChoreDetailNavigationBadge.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct ChoreDetailNavigationBadge<Destination: View>: View {
	let chore: Chore
	let badgeColor: Color
	@ViewBuilder private let destination: (Chore) -> Destination

	private var backgroundColor: Color {
		badgeColor.opacity(0.10)
	}

	private var borderColor: Color {
		badgeColor.opacity(0.25)
	}

	private var badgeLabel: some View {
		HStack(spacing: 4) {
			Image(systemName: "info.circle.fill")
				.font(.caption.weight(.semibold))
			ThemedText(
				"Details",
				type: .captionSemibold,
				style: .custom(AnyShapeStyle(badgeColor))
			)
		}
		.foregroundStyle(badgeColor)
		.padding(.horizontal, 8)
		.padding(.vertical, 5)
		.background(backgroundColor)
		.overlay(
			Capsule()
				.stroke(borderColor, lineWidth: 1)
		)
		.clipShape(Capsule())
	}

	init(
		chore: Chore,
		badgeColor: Color = .blue,
		@ViewBuilder destination: @escaping (Chore) -> Destination
	) {
		self.chore = chore
		self.badgeColor = badgeColor
		self.destination = destination
	}

	var body: some View {
		NavigationLink {
			destination(chore)
		} label: {
			badgeLabel
		}
		.buttonStyle(.plain)
		.frame(minWidth: 78)
	}
}

#Preview {
	let store = ChoreStore(chores: [
		Chore(title: "Dishes", schedule: .daily)
	])

	NavigationStack {
		if let chore = store.allChores.first {
			ChoreDetailNavigationBadge(chore: chore) { selectedChore in
				ChoreDetailView(choreStore: store, chore: selectedChore)
			}
		} else {
			ThemedText("No chore", type: .body, style: .secondary)
		}
	}
}
