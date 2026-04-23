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
	@State private var bulkInput = ""

	var body: some View {
		Form {
			Section("Add a Chore") {
				TextField("Ex: Clean kitchen", text: $newChore)
					.textInputAutocapitalization(.sentences)
					.submitLabel(.done)
					.onSubmit {
						addSingleChore()
					}

				Button("Add Chore") {
					addSingleChore()
				}
				.disabled(trimmedNewChore.isEmpty)
			}

			Section("Add Multiple Chores") {
				TextEditor(text: $bulkInput)
					.frame(minHeight: 110)

				Button("Add From Lines") {
					let chores =
						bulkInput
						.split(whereSeparator: \.isNewline)
						.map { String($0) }
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
							Text(chore)
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
		choreStore.addChore(newChore)
		newChore = ""
	}
}

#Preview {
	NavigationStack {
		AddChoresView(choreStore: ChoreStore(chores: ["Dishes", "Vacuum"]))
	}
}
