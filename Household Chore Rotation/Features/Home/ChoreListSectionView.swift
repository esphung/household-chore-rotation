//
//  ChoreListSectionView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct ChoreListSectionView: View {
	@Bindable var choreStore: ChoreStore

	private var indexedChores: [(offset: Int, element: Chore)] {
		Array(choreStore.allChores.enumerated())
	}

	private func choreRow(index: Int, chore: Chore) -> some View {
		HStack(spacing: 12) {
			rowNumberBadge(index: index)
			ThemedText(chore.title, type: .bodyMedium)
			Spacer()
			rowTrailingContent(for: chore)
		}
		.padding(12)
		.background(Color.white.opacity(0.82))
		.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
	}

	private func rowNumberBadge(index: Int) -> some View {
		ThemedText("\(index + 1)", type: .captionBold)
			.frame(width: 24, height: 24)
			.background(Color.teal.opacity(0.16))
			.clipShape(Circle())
	}

	private func rowTrailingContent(for chore: Chore) -> some View {
		HStack(spacing: 8) {
			ChoreDetailNavigationBadge(chore: chore) { selectedChore in
				ChoreDetailView(choreStore: choreStore, chore: selectedChore)
			}

			ThemedText(
				chore.schedule.rawValue,
				systemImage: chore.schedule.systemImage,
				type: .captionSemibold
			)
			.badgeStyle(
				textColor: chore.schedule.badgeColor,
				backgroundColor: chore.schedule.badgeColor.opacity(0.12)
			)
			.frame(minWidth: 92)
		}
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			ThemedText("All Chores", type: .sectionTitle)

			ForEach(indexedChores, id: \.offset) { index, chore in
				choreRow(index: index, chore: chore)
			}
		}
	}
}

#Preview {
	ChoreListSectionView(
		choreStore: ChoreStore(
			chores: [
				Chore(title: "Dishes", schedule: .daily),
				Chore(title: "Vacuum", schedule: .weekly),
				Chore(title: "Laundry", schedule: .weekly),
				Chore(title: "Deep Clean", schedule: .monthly),
			],
			currentIndex: 1,
			completedIndices: [0]
		)
	)
}
