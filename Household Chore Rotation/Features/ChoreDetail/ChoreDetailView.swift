//
//  ChoreDetailView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct ChoreDetailView: View {
	@Bindable var choreStore: ChoreStore
	let chore: Chore

	private var route: AppRoute {
		.choreDetail(choreID: chore.id)
	}

	private var liveChore: Chore? {
		choreStore.allChores.first(where: { $0.id == chore.id })
	}

	private var choreIndex: Int? {
		choreStore.allChores.firstIndex(where: { $0.id == chore.id })
	}

	private var choreStatus: ChoreStore.ChoreStatus? {
		guard let choreIndex else { return nil }
		return choreStore.status(for: choreIndex)
	}

	private var choreStatusText: String {
		choreStatus?.rawValue ?? "Unknown"
	}

	private var choreStatusColor: Color {
		choreStatus?.cardBadgeColor(isLightBackground: true) ?? .gray
	}

	private var scheduleBadgeColor: Color {
		liveChore?.schedule.badgeColor ?? .gray
	}

	private var detailCard: some View {
		VStack(alignment: .leading, spacing: 14) {
			if let liveChore {
				ThemedText(liveChore.title, type: .cardTitle)

				ThemedText(
					choreStatusText,
					type: .captionSemibold
				)
				.badgeStyle(
					textColor: choreStatusColor,
					backgroundColor: choreStatusColor.opacity(0.14)
				)

				ThemedText(
					liveChore.schedule.rawValue,
					systemImage: liveChore.schedule.systemImage,
					type: .captionSemibold
				)
				.badgeStyle(
					textColor: scheduleBadgeColor,
					backgroundColor: scheduleBadgeColor.opacity(0.14)
				)

				if let choreIndex {
					ThemedText(
						"Position: \(choreIndex + 1) of \(choreStore.totalChores)",
						type: .caption,
						style: .secondary
					)
				}
			}
		}
		.padding(16)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color.white.opacity(0.82))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
	}

	var body: some View {
		GradientScrollScreen {
			ScreenHeaderView(
				title: route.title,
				subtitle: route.subtitle
			)

			if let liveChore {
				detailCard
			} else {
				ThemedText("Chore not found", type: .body, style: .secondary)
			}
		}
	}
}

#Preview {
	let store = ChoreStore(chores: [
		Chore(title: "Dishes", schedule: .daily),
		Chore(title: "Vacuum", schedule: .weekly),
	])

	NavigationStack {
		if let firstChore = store.allChores.first {
			ChoreDetailView(choreStore: store, chore: firstChore)
		} else {
			ThemedText("No preview chore", type: .body, style: .secondary)
		}
	}
}
