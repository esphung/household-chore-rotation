//
//  CurrentChoreCardView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct CurrentChoreCardView: View {
	private enum PaginationItem: Hashable {
		case dot(Int)
		case gap(String)
	}

	@Bindable var choreStore: ChoreStore

	private let accentGradient = LinearGradient(
		colors: [Color.blue, Color.cyan],
		startPoint: .topLeading,
		endPoint: .bottomTrailing
	)

	var body: some View {
		VStack(alignment: .leading, spacing: 18) {
			HStack {
				Label("Current Chore", systemImage: "sparkles")
					.font(.headline)
					.foregroundStyle(.white.opacity(0.95))
				Spacer()
				Text(choreStore.currentStatusLabel)
					.font(.caption.weight(.semibold))
					.padding(.horizontal, 10)
					.padding(.vertical, 4)
					.background(Color.white.opacity(0.20))
					.clipShape(Capsule())
				Text("\(choreStore.currentPosition) of \(choreStore.totalChores)")
					.font(.caption.weight(.semibold))
					.foregroundStyle(.white.opacity(0.85))
			}

			Text(choreStore.currentChore)
				.font(.system(.title, design: .rounded, weight: .bold))
				.foregroundStyle(.white)

			if let schedule = choreStore.currentChoreSchedule {
				Label(schedule.rawValue, systemImage: schedule.systemImage)
					.font(.caption.weight(.semibold))
					.foregroundStyle(.white.opacity(0.90))
					.padding(.horizontal, 10)
					.padding(.vertical, 4)
					.background(Color.white.opacity(0.18))
					.clipShape(Capsule())
			}

			VStack(alignment: .leading, spacing: 8) {
				HStack(spacing: 8) {
					ForEach(paginationItems, id: \.self) { item in
						switch item {
						case .dot(let index):
							Circle()
								.fill(dotColor(for: index))
								.frame(
									width: index == currentChoreIndex ? 10 : 8,
									height: index == currentChoreIndex ? 10 : 8
								)
						case .gap:
							Capsule()
								.fill(Color.white.opacity(0.45))
								.frame(width: 10, height: 3)
						}
					}
				}
				.frame(maxWidth: .infinity, alignment: .center)

				Text("Chore \(choreStore.currentPosition) of \(choreStore.totalChores)")
					.font(.caption)
					.foregroundStyle(.white.opacity(0.85))

				Text(choreStore.statusSummary)
					.font(.caption)
					.foregroundStyle(.white.opacity(0.9))
			}
		}
		.padding(18)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(accentGradient)
		.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
		.shadow(color: .blue.opacity(0.24), radius: 14, y: 8)
	}

	private func dotColor(for index: Int) -> Color {
		if index == currentChoreIndex {
			return .white
		}
		if status(for: index) == .completed {
			return .green.opacity(0.9)
		}
		return .white.opacity(0.28)
	}

	private func status(for index: Int) -> ChoreStore.ChoreStatus {
		choreStore.status(for: index)
	}

	private var currentChoreIndex: Int {
		max(choreStore.currentPosition - 1, 0)
	}

	private var paginationItems: [PaginationItem] {
		let total = choreStore.totalChores
		guard total > 0 else { return [] }

		if total <= 10 {
			return (0..<total).map { .dot($0) }
		}

		let currentIndex = min(currentChoreIndex, total - 1)
		var indices: Set<Int> = [0, total - 1]

		for offset in -2...2 {
			let candidate = currentIndex + offset
			if (0..<total).contains(candidate) {
				indices.insert(candidate)
			}
		}

		let sorted = indices.sorted()
		var items: [PaginationItem] = []
		var previousIndex: Int?

		for index in sorted {
			if let previousIndex, index - previousIndex > 1 {
				items.append(.gap("\(previousIndex)-\(index)"))
			}
			items.append(.dot(index))
			previousIndex = index
		}

		return items
	}
}

#Preview {
	CurrentChoreCardView(
		choreStore: ChoreStore(
			chores: [
				Chore(title: "Dishes", schedule: .daily),
				Chore(title: "Vacuum", schedule: .weekly),
				Chore(title: "Laundry", schedule: .weekly),
				Chore(title: "Trash", schedule: .weekly),
			],
			currentIndex: 1,
			completedIndices: [0]
		)
	)
}
