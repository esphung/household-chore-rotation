//
//  ChoreStore.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import Observation

@Observable
final class ChoreStore {
	enum ChoreStatus: String {
		case pending = "Pending"
		case inProgress = "In Progress"
		case completed = "Completed"
	}

	private let chores: [String]
	private var currentIndex = 0
	private var completedIndices: Set<Int> = []
	private var inProgressIndices: Set<Int> = []

	private var hasValidCurrentIndex: Bool {
		chores.indices.contains(currentIndex)
	}

	private var clampedCurrentIndex: Int {
		guard !chores.isEmpty else { return 0 }
		return min(max(currentIndex, 0), chores.count - 1)
	}

	private func toggleMembership(in set: inout Set<Int>, for index: Int) {
		if set.contains(index) {
			set.remove(index)
		} else {
			set.insert(index)
		}
	}

	var isReset: Bool {
		chores.isEmpty
			|| (currentIndex == 0 && completedIndices.isEmpty && inProgressIndices.isEmpty)
	}

	init(
		chores: [String],
		currentIndex: Int = 0,
		completedIndices: [Int] = [],
		inProgressIndices: [Int] = []
	) {
		self.chores = chores
		self.currentIndex = currentIndex
		self.currentIndex = clampedCurrentIndex

		let validIndices = Set(chores.indices)
		let completedSet = Set(completedIndices).intersection(validIndices)
		let inProgressSet = Set(inProgressIndices)
			.intersection(validIndices)
			.subtracting(completedSet)

		self.completedIndices = completedSet
		self.inProgressIndices = inProgressSet
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

	var inProgressChoreCount: Int {
		inProgressIndices.count
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
		if completedIndices.contains(currentIndex) {
			return .completed
		}
		if inProgressIndices.contains(currentIndex) {
			return .inProgress
		}
		return .pending
	}

	var statusSummary: String {
		guard !chores.isEmpty else { return "No chores available" }
		if allChoresCompleted {
			return "All chores completed"
		}
		return "\(completedChoreCount) completed, \(remainingChoreCount) remaining"
	}

	func isChoreCompleted(at index: Int) -> Bool {
		completedIndices.contains(index)
	}

	func status(for index: Int) -> ChoreStatus {
		guard chores.indices.contains(index) else { return .pending }
		if completedIndices.contains(index) {
			return .completed
		}
		if inProgressIndices.contains(index) {
			return .inProgress
		}
		return .pending
	}

	func toggleCurrentChoreCompletion() {
		guard hasValidCurrentIndex else { return }
		if completedIndices.contains(currentIndex) {
			completedIndices.remove(currentIndex)
		} else {
			completedIndices.insert(currentIndex)
			inProgressIndices.remove(currentIndex)
		}
	}

	func toggleCurrentChoreInProgress() {
		guard hasValidCurrentIndex else { return }
		guard !completedIndices.contains(currentIndex) else { return }
		toggleMembership(in: &inProgressIndices, for: currentIndex)
	}

	func moveToNextNonCompletedChore() {
		// should find any non-completed chore and move to it, preferably the next one in line. If all chores are completed, stay on current chore.
		guard !chores.isEmpty else { return }
		if let nextNonCompleted = chores.indices.first(where: {
			!completedIndices.contains($0) && $0 > currentIndex
		}) {
			currentIndex = nextNonCompleted
		} else if let firstNonCompleted = chores.indices.first(where: {
			!completedIndices.contains($0)
		}) {
			currentIndex = firstNonCompleted
		}
	}

	func setCurrentToFirstNonCompletedChore() {
		guard !chores.isEmpty else {
			currentIndex = 0
			return
		}

		if let firstNonCompleted = chores.indices.first(where: { !completedIndices.contains($0) }) {
			currentIndex = firstNonCompleted
		} else {
			// If all chores are completed, default to the first chore.
			currentIndex = 0
		}
	}

	func incrementChore() {
		guard hasValidCurrentIndex else {
			currentIndex = 0
			return
		}
		if isLastChore {
			return
		}
		currentIndex += 1
	}

	func decrementChore() {
		guard hasValidCurrentIndex else {
			currentIndex = 0
			return
		}
		if isFirstChore {
			return
		}
		currentIndex -= 1
	}

	func resetChores() {
		currentIndex = 0
		completedIndices.removeAll()
		inProgressIndices.removeAll()
	}

	func clearCompletedChores() {
		completedIndices.removeAll()
	}

	func clearInProgressChores() {
		inProgressIndices.removeAll()
	}

}
