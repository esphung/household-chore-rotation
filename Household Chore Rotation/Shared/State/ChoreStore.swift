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
		let chores: [String]
		let currentIndex: Int
		let completedIndices: [Int]
	}

	static let defaultChores = ["Dishes", "Vacuum", "Laundry", "Trash"]
	private static let storageKey = "ChoreStore.persistedState"

	enum ChoreStatus: String {
		case pending = "Pending"
		case completed = "Completed"
	}

	private var chores: [String]
	private var currentIndex = 0
	private var completedIndices: Set<Int> = []

	private static func loadPersistedState() -> PersistedState? {
		guard let data = UserDefaults.standard.data(forKey: storageKey) else {
			return nil
		}
		return try? JSONDecoder().decode(PersistedState.self, from: data)
	}

	private func persistState() {
		let state = PersistedState(
			chores: chores,
			currentIndex: currentIndex,
			completedIndices: completedIndices.sorted()
		)
		guard let data = try? JSONEncoder().encode(state) else { return }
		UserDefaults.standard.set(data, forKey: Self.storageKey)
	}

	private func applyState(
		chores: [String],
		currentIndex: Int,
		completedIndices: [Int]
	) {
		self.chores = chores
		self.currentIndex = currentIndex
		self.currentIndex = clampedCurrentIndex

		let validIndices = Set(chores.indices)
		self.completedIndices = Set(completedIndices).intersection(validIndices)
	}

	private func addChoreInternal(_ chore: String) -> Bool {
		let trimmedChore = chore.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmedChore.isEmpty else { return false }
		chores.append(trimmedChore)
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
		if completedIndices.contains(index) {
			return .completed
		}
		return .pending
	}

	private func firstNonCompletedIndex() -> Int? {
		chores.indices.first(where: { !completedIndices.contains($0) })
	}

	private func nextNonCompletedIndex(after index: Int) -> Int? {
		chores.indices.first(where: { $0 > index && !completedIndices.contains($0) })
	}

	var isReset: Bool {
		chores.isEmpty
			|| (currentIndex == 0 && completedIndices.isEmpty)
	}

	init(
		chores: [String],
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
				completedIndices: persistedState.completedIndices
			)
		} else {
			applyState(
				chores: chores,
				currentIndex: currentIndex,
				completedIndices: completedIndices
			)
		}

		persistState()
	}

	var allChores: [String] {
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

	var currentChore: String {
		guard hasValidCurrentIndex else {
			return "No chores available"
		}
		return chores[currentIndex]
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

	func moveToNextNonCompletedChore() {
		guard !chores.isEmpty else { return }
		if let targetIndex = nextNonCompletedIndex(after: currentIndex) ?? firstNonCompletedIndex()
		{
			currentIndex = targetIndex
		}
		persistState()
	}

	func setCurrentToFirstNonCompletedChore() {
		guard !chores.isEmpty else {
			currentIndex = 0
			persistState()
			return
		}

		currentIndex = firstNonCompletedIndex() ?? 0
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
		persistState()
	}

	func addChore(_ chore: String) {
		if addChoreInternal(chore) {
			persistState()
		}
	}

	func addChores(_ newChores: [String]) {
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
				title: chores[index],
				isCompleted: completedIndices.contains(index)
			)
		}

		combined.remove(atOffsets: offsets)

		chores = combined.map { $0.title }
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
