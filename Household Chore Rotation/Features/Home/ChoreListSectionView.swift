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

					Text(chore)
						.font(.body.weight(.medium))
					Spacer()
					Text(choreStore.status(for: index).rawValue)
						.font(.caption.weight(.semibold))
						.foregroundStyle(.secondary)
				}
				.padding(12)
				.background(Color.white.opacity(0.82))
				.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
			}
		}
	}
}

#Preview {
	ChoreListSectionView(
		choreStore: ChoreStore(
			chores: ["Dishes", "Vacuum", "Laundry", "Trash"],
			currentIndex: 1,
			completedIndices: [0]
		)
	)
}
