//
//  AddChoresView.swift
//  Household Chore Rotation
//
//  Created by GitHub Copilot on 4/22/26.
//

import SwiftUI

struct AddChoresView: View {
	@Bindable var choreStore: ChoreStore
	@State private var newChore = ""
	@State private var selectedSchedule: ChoreSchedule = .weekly
	@State private var bulkInput = ""
	@State private var bulkSchedule: ChoreSchedule = .weekly

	var body: some View {
		Form {
			Section("Add a Chore") {
				TextField("Ex: Clean kitchen", text: $newChore)
					.textInputAutocapitalization(.sentences)
					.submitLabel(.done)
					.onSubmit {
						addSingleChore()
					}

				Picker("Schedule", selection: $selectedSchedule) {
					ForEach(ChoreSchedule.allCases, id: \.self) { schedule in
						Label(schedule.rawValue, systemImage: schedule.systemImage)
							.tag(schedule)
					}
				}

				Button("Add Chore") {
					addSingleChore()
				}
				.disabled(trimmedNewChore.isEmpty)
			}

			Section("Add Multiple Chores") {
				TextEditor(text: $bulkInput)
					.frame(minHeight: 110)

				Picker("Schedule", selection: $bulkSchedule) {
					ForEach(ChoreSchedule.allCases, id: \.self) { schedule in
						Label(schedule.rawValue, systemImage: schedule.systemImage)
							.tag(schedule)
					}
				}

				Button("Add From Lines") {
					let chores =
						bulkInput
						.split(whereSeparator: \.isNewline)
						.map { Chore(title: String($0), schedule: bulkSchedule) }
					choreStore.addChores(chores)
					bulkInput = ""
				}
				.disabled(trimmedBulkInput.isEmpty)

				Button("Add Default Chores") {
					choreStore.addChores(ChoreStore.defaultChores)
				}
			}

			Section("Current Chores") {
				if choreStore.allChores.isEmpty {
					Text("No chores yet")
						.foregroundStyle(.secondary)
				} else {
					ForEach(Array(choreStore.allChores.enumerated()), id: \.offset) {
						index, chore in
						HStack {
							Text("\(index + 1).")
								.foregroundStyle(.secondary)
							Text(chore.title)
							Spacer()
							Label(chore.schedule.rawValue, systemImage: chore.schedule.systemImage)
								.font(.caption)
								.foregroundStyle(.secondary)
						}
					}
					.onDelete { offsets in
						choreStore.removeChores(atOffsets: offsets)
					}
				}
			}

			Section("Reset") {
				AlertActionButton(
					buttonTitle: "Remove All Chores",
					systemImage: "trash",
					alertTitle: "Remove All Chores?",
					alertMessage: "This will delete every chore and reset chore progress.",
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
		.navigationTitle("Add Chores")
	}

	private var trimmedNewChore: String {
		newChore.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	private var trimmedBulkInput: String {
		bulkInput.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	private func addSingleChore() {
		choreStore.addChore(Chore(title: newChore, schedule: selectedSchedule))
		newChore = ""
	}
}

#Preview {
	NavigationStack {
		AddChoresView(choreStore: ChoreStore(chores: [Chore(title: "Dishes", schedule: .daily), Chore(title: "Vacuum", schedule: .weekly)]))
	}
}
