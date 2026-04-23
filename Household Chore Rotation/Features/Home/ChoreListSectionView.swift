//
//  ChoreListSectionView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct ChoreListSectionView: View {
	@Bindable var choreStore: ChoreStore

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("All Chores")
				.font(.headline)

			ForEach(Array(choreStore.allChores.enumerated()), id: \.offset) { index, chore in
				HStack(spacing: 12) {
					Text("\(index + 1)")
						.font(.caption.weight(.bold))
						.frame(width: 24, height: 24)
						.background(Color.teal.opacity(0.16))
						.clipShape(Circle())

					Text(chore.title)
						.font(.body.weight(.medium))
					Spacer()
					Label(chore.schedule.rawValue, systemImage: chore.schedule.systemImage)
						.font(.caption.weight(.semibold))
						.foregroundStyle(scheduleColor(for: chore.schedule))
						.padding(.horizontal, 8)
						.padding(.vertical, 3)
						.background(scheduleColor(for: chore.schedule).opacity(0.12))
						.clipShape(Capsule())
				}
				.padding(12)
				.background(Color.white.opacity(0.82))
				.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
			}
		}
	}

	private func scheduleColor(for schedule: ChoreSchedule) -> Color {
		switch schedule {
		case .daily: return .orange
		case .weekly: return .teal
		case .monthly: return .purple
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
