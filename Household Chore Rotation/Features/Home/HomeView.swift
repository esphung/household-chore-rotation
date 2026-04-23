//
//  HomeView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct HomeView: View {
	private enum PaginationItem: Hashable {
		case dot(Int)
		case gap(String)
	}

	@Environment(ChoreStore.self) private var choreStore
	private let accentGradient = LinearGradient(
		colors: [Color.blue, Color.cyan],
		startPoint: .topLeading,
		endPoint: .bottomTrailing
	)

	var body: some View {
		ZStack {
			LinearGradient(
				colors: [Color.indigo.opacity(0.20), Color.teal.opacity(0.12), Color.white],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()

			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 20) {
					headerSection
					currentChoreCard
					actionsSection
					allChoresSection
				}
				.padding(.horizontal, 20)
				.padding(.vertical, 28)
			}
		}
		.onAppear {
			choreStore.setCurrentToFirstNonCompletedChore()
		}
	}

	private var headerSection: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text("Household Chores")
				.font(.system(.largeTitle, design: .rounded, weight: .bold))
			Text("Keep your home routine fair and organized")
				.font(.subheadline)
				.foregroundStyle(.secondary)
		}
	}

	private var currentChoreCard: some View {
		VStack(alignment: .leading, spacing: 18) {
			HStack {
				Label("Current Chore", systemImage: "sparkles")
					.font(.headline)
					.foregroundStyle(.white.opacity(0.95))
				Spacer()
				Text(choreStore.currentChoreStatus.rawValue)
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
		if choreStore.isChoreCompleted(at: index) {
			return .green.opacity(0.9)
		}
		return .white.opacity(0.28)
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

	private var actionsSection: some View {
		VStack(spacing: 10) {
			Button {
				choreStore.toggleCurrentChoreCompletion()
				// If marking current chore as completed, automatically move to next non-completed chore
				if choreStore.currentChoreStatus == .completed {
					choreStore.moveToNextNonCompletedChore()
				}
			} label: {
				Label(
					choreStore.currentChoreStatus == .completed
						? "Mark as Incomplete" : "Mark as Completed",
					systemImage: choreStore.currentChoreStatus == .completed
						? "xmark.circle.fill" : "checkmark.circle.fill"
				)
				.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderedProminent)
			.tint(.mint)
			.disabled(choreStore.allChores.isEmpty || choreStore.allChoresCompleted)

			Button {
				choreStore.incrementChore()
			} label: {
				Label(
					"Next Chore", systemImage: "arrow.right.circle.fill"
				)
				.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderedProminent)
			.tint(.teal)
			.disabled(
				choreStore.allChores.isEmpty || choreStore.isLastChore
					|| choreStore.allChoresCompleted)

			HStack(spacing: 10) {
				Button {
					choreStore.decrementChore()
				} label: {
					Label("Previous Chore", systemImage: "arrow.left.circle")
				}
				.buttonStyle(.bordered)
				.tint(.orange)
				.disabled(
					choreStore.allChores.isEmpty || choreStore.isFirstChore
						|| choreStore.allChoresCompleted)

				Spacer(minLength: 0)

				AlertActionButton(
					buttonTitle: "Reset Chores",
					systemImage: "arrow.counterclockwise.circle",
					alertTitle: "Reset All Chores?",
					alertMessage: "This resets all chores and chore statuses.",
					confirmButtonTitle: "Reset",
					onConfirm: {
						choreStore.resetChores()
					},
					onCancel: {}
				)
				.buttonStyle(.bordered)
				.tint(.red)
				.disabled(choreStore.isReset)

			}
		}
	}

	private var allChoresSection: some View {
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
	HomeView()
		.environment(
			ChoreStore(chores: [
				"Dishes", "Vacuum", "Laundry", "Trash", "Cooking",
				"Yard Work", "Pet Care",
				"Grocery Shopping", "Bathroom Cleaning", "Dusting", "Window Washing",
				"Car Maintenance", "Organizing", "Bill Payments", "Recycling", "Meal Planning",
				"Trash Duty", "Floor Mopping", "Fridge Cleaning", "Errands",
				"Garden Care", "Home Repairs", "Childcare", "Laundry Folding",
				"Pantry Organization",
				"Seasonal Decor", "Tech Support", "Bookkeeping", "Donation Runs",
			]))
}
