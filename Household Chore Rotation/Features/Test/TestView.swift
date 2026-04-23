//
//  TestView.swift
//  Household Chore Rotation
//
//  Created by GitHub Copilot on 4/22/26.
//

import SwiftUI

struct TestView: View {
	@Environment(ChoreStore.self) private var choreStore

	var body: some View {
		Form {
			Section("Current State") {
				LabeledContent("Total Chores", value: "\(choreStore.totalChores)")
				LabeledContent("Current Chore", value: choreStore.currentChore)
				LabeledContent(
					"Position",
					value: "\(choreStore.currentPosition) / \(choreStore.totalChores)")
				LabeledContent("Current Status", value: choreStore.currentChoreStatus.rawValue)
				LabeledContent(
					"Completion",
					value: "\(choreStore.completedChoreCount) / \(choreStore.totalChores)")
				LabeledContent(
					"In Progress",
					value: "\(choreStore.inProgressChoreCount) / \(choreStore.totalChores)")
				LabeledContent(
					"All Completed",
					value: choreStore.allChoresCompleted ? "Yes" : "No")
				Text(choreStore.statusSummary)
					.font(.footnote)
					.foregroundStyle(.secondary)
			}

			Section("Actions") {
				Button(
					choreStore.currentChoreStatus == .completed
						? "Mark Current as Incomplete" : "Mark Current as Complete"
				) {
					choreStore.toggleCurrentChoreCompletion()
				}

				Button("Mark Current as In Progress") {
					choreStore.toggleCurrentChoreInProgress()
				}

				Button("Next Chore") {
					choreStore.incrementChore()
				}
				.disabled(
					choreStore.allChores.isEmpty || choreStore.isLastChore
						|| choreStore.allChoresCompleted)

				Button("Previous Chore") {
					choreStore.decrementChore()
				}
				.disabled(
					choreStore.allChores.isEmpty || choreStore.isFirstChore
						|| choreStore.allChoresCompleted)

				Button("Reset Chores", role: .destructive) {
					choreStore.resetChores()
				}
				.disabled(choreStore.isReset)

				Button("Clear Completed Status", role: .destructive) {
					choreStore.clearCompletedChores()
				}
				.disabled(choreStore.completedChoreCount == 0)
			}

			Section("All Chores") {
				ForEach(Array(choreStore.allChores.enumerated()), id: \.offset) { index, chore in
					HStack {
						Text(chore)
						Spacer()
						Text(choreStore.status(for: index).rawValue)
							.font(.footnote.weight(.semibold))
							.foregroundStyle(.secondary)
					}
				}
			}
		}
		.navigationTitle("Test Screen")
	}
}

#Preview {
	TestView()
		.environment(
			ChoreStore(
				chores: ["Dishes", "Vacuum", "Laundry", "Trash"],
				currentIndex: 0,
				completedIndices: [],
				inProgressIndices: []
			)
		)
}
