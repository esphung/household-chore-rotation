//
//  ChoreStore.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import Foundation
import Observation

@Observable
final class ChoreStore {
	private struct PersistedState: Codable {
		let chores: [Chore]
		let currentIndex: Int
		let completedIndices: [Int]
		let selectedSchedule: ChoreSchedule

		private enum CodingKeys: String, CodingKey {
			case chores
			case currentIndex
			case completedIndices
			case selectedSchedule
		}

		init(
			chores: [Chore],
			currentIndex: Int,
			completedIndices: [Int],
			selectedSchedule: ChoreSchedule
		) {
			self.chores = chores
			self.currentIndex = currentIndex
			self.completedIndices = completedIndices
			self.selectedSchedule = selectedSchedule
		}

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			chores = try container.decode([Chore].self, forKey: .chores)
			currentIndex = try container.decode(Int.self, forKey: .currentIndex)
			completedIndices = try container.decode([Int].self, forKey: .completedIndices)
			selectedSchedule =
				try container.decodeIfPresent(ChoreSchedule.self, forKey: .selectedSchedule)
				?? .daily
		}
	}

	private static let defaultChoreTitles = ["Dishes", "Vacuum", "Laundry", "Trash"]
	private static let storageKey = "ChoreStore.persistedState"

	enum ChoreStatus: String {
		case pending = "Pending"
		case completed = "Completed"
	}

	var selectedSchedule: ChoreSchedule = .daily {
		didSet {
			persistState()
		}
	}

	private var chores: [Chore]
	private var currentIndex = 0
	private var completedIndices: Set<Int> = []

	private var persistedState: PersistedState {
		PersistedState(
			chores: chores,
			currentIndex: currentIndex,
			completedIndices: completedIndices.sorted(),
			selectedSchedule: selectedSchedule
		)
	}

	func addDefaultChores() {
		let defaultChores = Self.defaultChoreTitles.map {
			Chore(title: $0, schedule: selectedSchedule)
		}
		addChores(defaultChores)
	}

	private static func loadPersistedState() -> PersistedState? {
		guard let data = UserDefaults.standard.data(forKey: storageKey) else {
			return nil
		}
		return try? JSONDecoder().decode(PersistedState.self, from: data)
	}

	private func persistState() {
		guard let data = try? JSONEncoder().encode(persistedState) else { return }
		UserDefaults.standard.set(data, forKey: Self.storageKey)
	}

	private func applyState(
		chores: [Chore],
		currentIndex: Int,
		completedIndices: [Int],
		selectedSchedule: ChoreSchedule
	) {
		self.chores = chores
		self.currentIndex = currentIndex
		self.currentIndex = clampedCurrentIndex

		let validIndices = Set(chores.indices)
		self.completedIndices = Set(completedIndices).intersection(validIndices)
		self.selectedSchedule = selectedSchedule
	}

	private func addChoreInternal(_ chore: Chore) -> Bool {
		let trimmedTitle = chore.title.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmedTitle.isEmpty else { return false }
		chores.append(Chore(title: trimmedTitle, schedule: chore.schedule))
		if chores.count == 1 {
			currentIndex = 0
		}
		return true
	}

	private var hasValidCurrentIndex: Bool {
		chores.indices.contains(currentIndex)
	}

	private var clampedCurrentIndex: Int {
		guard !chores.isEmpty else { return 0 }
		return min(max(currentIndex, 0), chores.count - 1)
	}

	private func status(forKnownValidIndex index: Int) -> ChoreStatus {
		completedIndices.contains(index) ? .completed : .pending
	}

	private func firstNonCompletedIndex() -> Int? {
		chores.indices.first(where: { !completedIndices.contains($0) })
	}

	private func nextNonCompletedIndex(after index: Int) -> Int? {
		chores.indices.first(where: { $0 > index && !completedIndices.contains($0) })
	}

	var isReset: Bool {
		chores.isEmpty
			|| (currentIndex == 0 && completedIndices.isEmpty && selectedSchedule == .daily)
	}

	init(
		chores: [Chore],
		currentIndex: Int = 0,
		completedIndices: [Int] = []
	) {
		self.chores = []

		let hasExplicitSeed =
			!chores.isEmpty
			|| currentIndex != 0
			|| !completedIndices.isEmpty

		if !hasExplicitSeed, let persistedState = Self.loadPersistedState() {
			applyState(
				chores: persistedState.chores,
				currentIndex: persistedState.currentIndex,
				completedIndices: persistedState.completedIndices,
				selectedSchedule: persistedState.selectedSchedule
			)
		} else {
			applyState(
				chores: chores,
				currentIndex: currentIndex,
				completedIndices: completedIndices,
				selectedSchedule: .daily
			)
		}

		persistState()
	}

	var allChores: [Chore] {
		chores
	}

	var currentPosition: Int {
		guard !chores.isEmpty else { return 0 }
		return currentIndex + 1
	}

	var isFirstChore: Bool {
		currentIndex == 0
	}

	var isLastChore: Bool {
		!chores.isEmpty && currentIndex == chores.count - 1
	}

	var totalChores: Int {
		chores.count
	}

	var completedChoreCount: Int {
		completedIndices.count
	}

	var remainingChoreCount: Int {
		totalChores - completedChoreCount
	}

	var allChoresCompleted: Bool {
		totalChores > 0 && completedChoreCount == totalChores
	}

	var currentChoreItem: Chore? {
		guard hasValidCurrentIndex else { return nil }
		return chores[currentIndex]
	}

	var currentChore: String {
		currentChoreItem?.title ?? "No chores available"
	}

	var currentChoreSchedule: ChoreSchedule? {
		currentChoreItem?.schedule
	}

	var currentChoreStatus: ChoreStatus {
		guard hasValidCurrentIndex else { return .pending }
		return status(forKnownValidIndex: currentIndex)
	}

	var currentStatusLabel: String {
		guard !chores.isEmpty else { return "No status" }
		return currentChoreStatus.rawValue
	}

	var statusSummary: String {
		guard !chores.isEmpty else { return "No chores available" }
		if allChoresCompleted {
			return "All chores completed"
		}
		return "\(completedChoreCount) completed, \(remainingChoreCount) remaining"
	}

	func status(for index: Int) -> ChoreStatus {
		guard chores.indices.contains(index) else { return .pending }
		return status(forKnownValidIndex: index)
	}

	func toggleCurrentChoreCompletion() {
		guard hasValidCurrentIndex else { return }
		if completedIndices.contains(currentIndex) {
			completedIndices.remove(currentIndex)
		} else {
			completedIndices.insert(currentIndex)
		}
		persistState()
	}

	func incrementChore() {
		guard hasValidCurrentIndex else {
			currentIndex = 0
			persistState()
			return
		}
		guard !isLastChore else {
			return
		}
		currentIndex += 1
		persistState()
	}

	func decrementChore() {
		guard hasValidCurrentIndex else {
			currentIndex = 0
			persistState()
			return
		}
		guard !isFirstChore else {
			return
		}
		currentIndex -= 1
		persistState()
	}

	func resetChores() {
		currentIndex = 0
		completedIndices.removeAll()
		selectedSchedule = .daily
		persistState()
	}

	func addChore(_ chore: Chore) {
		if addChoreInternal(chore) {
			persistState()
		}
	}

	func addChores(_ newChores: [Chore]) {
		var didAddAny = false
		for chore in newChores {
			if addChoreInternal(chore) {
				didAddAny = true
			}
		}
		if didAddAny {
			persistState()
		}
	}

	func removeChores(atOffsets offsets: IndexSet) {
		guard !offsets.isEmpty, !chores.isEmpty else { return }

		let oldCurrentIndex = currentIndex
		let removedBeforeCurrent = offsets.filter { $0 < oldCurrentIndex }.count

		var combined = chores.indices.map { index in
			(
				chore: chores[index],
				isCompleted: completedIndices.contains(index)
			)
		}

		combined.remove(atOffsets: offsets)

		chores = combined.map { $0.chore }
		completedIndices = Set(combined.indices.filter { combined[$0].isCompleted })

		if chores.isEmpty {
			currentIndex = 0
		} else {
			currentIndex = min(max(oldCurrentIndex - removedBeforeCurrent, 0), chores.count - 1)
		}

		persistState()
	}

	func removeAllChores() {
		chores.removeAll()
		resetChores()
	}

}
