//
//  AddChoresView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct AddChoresView: View {
		@Bindable var choreStore: ChoreStore
		@State private var newChore = ""
		@State private var bulkInput = ""

		var body: some View {
				GradientScrollScreen {
						ScreenHeaderView(
								title: AppRoute.addChore.title,
								subtitle: AppRoute.addChore.subtitle
						)

						VStack(alignment: .leading, spacing: 16) {
								sectionCard(title: "Add a Chore") {
										TextField("Ex: Clean kitchen", text: $newChore)
												.textInputAutocapitalization(.sentences)
												.submitLabel(.done)
												.padding(.horizontal, 14)
												.padding(.vertical, 12)
												.background(Color.white)
												.clipShape(
														RoundedRectangle(
																cornerRadius: 12, style: .continuous
														)
												)
												.onSubmit {
														addSingleChore()
												}

										Picker(
												"Schedule", selection: $choreStore.selectedSchedule
										) {
												ForEach(
														ChoreSchedule.allCases, id: \.self
												) { schedule in
														Text(schedule.rawValue)
																.tag(schedule)
												}
										}
										.pickerStyle(.segmented)

										Button("Add Chore") {
												addSingleChore()
										}
										.buttonStyle(.borderedProminent)
										.tint(.teal)
										.disabled(trimmedNewChore.isEmpty)

										Button("Add Default Chores") {
												choreStore.addDefaultChores()
										}
										.buttonStyle(.bordered)
								}

								sectionCard(title: "Current Chores") {
										if choreStore.allChores.isEmpty {
												ThemedText(
														"No chores yet", type: .body,
														style: .secondary)
										} else {
												ForEach(
														Array(choreStore.allChores.enumerated()),
														id: \.offset
												) { index, chore in
														HStack(spacing: 12) {
																ThemedText(
																		"\(index + 1).",
																		type: .body,
																		style: .secondary)
																ThemedText(chore.title, type: .body)
																Spacer()
																ThemedText(
																		chore.schedule.rawValue,
																		systemImage: chore.schedule
																				.systemImage,
																		type: .captionSemibold,
																		style: .custom(
																				AnyShapeStyle(
																						chore
																								.schedule
																								.badgeColor
																				))
																)
																.badgeStyle(
																		textColor: chore.schedule
																				.badgeColor,
																		backgroundColor: chore
																				.schedule.badgeColor
																				.opacity(0.12),
																		horizontalPadding: 8,
																		verticalPadding: 3
																)
																Button {
																		choreStore.removeChores(
																				atOffsets: IndexSet(
																						integer:
																								index
																				))
																} label: {
																		Image(systemName: "trash")
																				.foregroundStyle(
																						.red)
																}
																.buttonStyle(.plain)
														}
														.padding(.vertical, 4)
														if index < choreStore.allChores.count - 1 {
																Divider()
														}
												}
										}
								}

								sectionCard(title: "Reset") {
										AlertActionButton(
												buttonTitle: "Remove All Chores",
												systemImage: "trash",
												alertTitle: "Remove All Chores?",
												alertMessage:
														"This will delete every chore and reset chore progress.",
												confirmButtonTitle: "Remove All",
												onConfirm: {
														choreStore.removeAllChores()
														newChore = ""
														bulkInput = ""
												},
												onCancel: {}
										)
										.foregroundStyle(.red)
										.disabled(choreStore.allChores.isEmpty)
								}
						}
				}
		}

		private var trimmedNewChore: String {
				newChore.trimmingCharacters(in: .whitespacesAndNewlines)
		}

		private var trimmedBulkInput: String {
				bulkInput.trimmingCharacters(in: .whitespacesAndNewlines)
		}

		private func addSingleChore() {
				choreStore.addChore(Chore(title: newChore, schedule: choreStore.selectedSchedule))
				newChore = ""
		}

		private func sectionCard<Content: View>(
				title: String,
				@ViewBuilder content: () -> Content
		) -> some View {
				VStack(alignment: .leading, spacing: 14) {
						ThemedText(title, type: .sectionTitle)
						content()
				}
				.padding(16)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(Color.white.opacity(0.82))
				.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
		}

}

#Preview {
		NavigationStack {
				AddChoresView(
						choreStore: ChoreStore(chores: [
								Chore(title: "Dishes", schedule: .daily),
								Chore(title: "Vacuum", schedule: .weekly)
						]))
		}
}
