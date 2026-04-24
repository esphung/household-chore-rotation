//
//  ChoreActionsView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct ChoreActionsView: View {
		@Bindable var choreStore: ChoreStore

		var body: some View {
				VStack(spacing: 10) {
						Button {
								choreStore.toggleCurrentChoreCompletion()
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

						Button {
								choreStore.incrementChore()
						} label: {
								Label("Next Chore", systemImage: "arrow.right.circle.fill")
										.frame(maxWidth: .infinity)
						}
						.buttonStyle(.borderedProminent)
						.tint(.teal)

						HStack(spacing: 10) {
								Button {
										choreStore.decrementChore()
								} label: {
										Label("Previous Chore", systemImage: "arrow.left.circle")
								}
								.buttonStyle(.bordered)
								.tint(.orange)

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
}

#Preview {
		ChoreActionsView(
				choreStore: ChoreStore(
						chores: [
								Chore(title: "Dishes", schedule: .daily),
								Chore(title: "Vacuum", schedule: .weekly),
								Chore(title: "Laundry", schedule: .weekly),
								Chore(title: "Trash", schedule: .weekly)
						],
						currentIndex: 1,
						completedIndices: [0]
				)
		)
}
