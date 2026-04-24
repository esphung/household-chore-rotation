//
//  HouseholdChoreRotationTests.swift
//  Household Chore RotationTests
//
//  Created by Eric Phung on 4/22/26.
//

import Foundation
import Testing

@testable import Household_Chore_Rotation

struct HouseholdChoreRotationTests {

		@Test func example() async throws {
				// Write your test here and use APIs like `#expect(...)` to check expected conditions.
		}

		// MARK: - Chore Scheduling

		@Test func choreHasNilTimingFieldsByDefault() {
				let chore = Chore(title: "Dishes", schedule: .daily)
				#expect(chore.lastCompletedAt == nil)
				#expect(chore.nextDueAt == nil)
		}

		@Test func toggleCompletionSetsTimingFields() {
				let store = ChoreStore(chores: [Chore(title: "Dishes", schedule: .daily)])
				#expect(store.currentChoreStatus == .pending)

				store.toggleCurrentChoreCompletion()

				let chore = store.allChores[0]
				#expect(store.currentChoreStatus == .completed)
				#expect(chore.lastCompletedAt != nil)
				#expect(chore.nextDueAt != nil)
		}

		@Test func toggleCompletionClearsTimingFieldsWhenUncompleting() {
				let store = ChoreStore(chores: [Chore(title: "Dishes", schedule: .daily)])
				store.toggleCurrentChoreCompletion()
				store.toggleCurrentChoreCompletion()

				let chore = store.allChores[0]
				#expect(store.currentChoreStatus == .pending)
				#expect(chore.lastCompletedAt == nil)
				#expect(chore.nextDueAt == nil)
		}

		@Test func nextDueAtIsComputedFromSchedule() {
				let store = ChoreStore(chores: [Chore(title: "Dishes", schedule: .weekly)])
				let before = Date()
				store.toggleCurrentChoreCompletion()
				let after = Date()

				let chore = store.allChores[0]
				guard let nextDueAt = chore.nextDueAt, let lastCompletedAt = chore.lastCompletedAt
				else {
						Issue.record("Timing fields should be set after completion")
						return
				}

				let calendar = Calendar.current
				let expectedLower = calendar.date(byAdding: DateComponents(day: 7), to: before)!
				let expectedUpper = calendar.date(byAdding: DateComponents(day: 7), to: after)!
				#expect(nextDueAt >= expectedLower)
				#expect(nextDueAt <= expectedUpper)
				#expect(lastCompletedAt >= before)
				#expect(lastCompletedAt <= after)
		}

		// MARK: - Expiry and Auto-Reset

		@Test func expiredChoreIsReportedAsPending() {
				let pastDate = Date(timeIntervalSinceNow: -1)
				let chore = Chore(
						title: "Dishes", schedule: .daily, lastCompletedAt: pastDate,
						nextDueAt: pastDate)
				let store = ChoreStore(chores: [chore], completedIndices: [0])

				#expect(store.status(for: 0) == .pending)
		}

		@Test func nonExpiredChoreRemainsCompleted() {
				let futureDate = Date(timeIntervalSinceNow: 86400)
				let chore = Chore(
						title: "Dishes", schedule: .daily, lastCompletedAt: Date(),
						nextDueAt: futureDate)
				let store = ChoreStore(chores: [chore], completedIndices: [0])

				#expect(store.status(for: 0) == .completed)
		}

		@Test func checkAndResetExpiredChoresResetsExpiredChore() {
				let pastDate = Date(timeIntervalSinceNow: -1)
				let chore = Chore(
						title: "Dishes", schedule: .daily, lastCompletedAt: pastDate,
						nextDueAt: pastDate)
				let store = ChoreStore(chores: [chore], completedIndices: [0])

				store.checkAndResetExpiredChores()

				#expect(store.status(for: 0) == .pending)
				#expect(store.allChores[0].lastCompletedAt == nil)
				#expect(store.allChores[0].nextDueAt == nil)
		}

		@Test func checkAndResetExpiredChoresLeavesNonExpiredChoreIntact() {
				let futureDate = Date(timeIntervalSinceNow: 86400)
				let chore = Chore(
						title: "Dishes", schedule: .daily, lastCompletedAt: Date(),
						nextDueAt: futureDate)
				let store = ChoreStore(chores: [chore], completedIndices: [0])

				store.checkAndResetExpiredChores()

				#expect(store.status(for: 0) == .completed)
				#expect(store.allChores[0].nextDueAt == futureDate)
		}

		@Test func checkAndResetOnlyResetsExpiredChores() {
				let pastDate = Date(timeIntervalSinceNow: -1)
				let futureDate = Date(timeIntervalSinceNow: 86400)
				let expiredChore = Chore(
						title: "Dishes", schedule: .daily, lastCompletedAt: pastDate,
						nextDueAt: pastDate)
				let activeChore = Chore(
						title: "Vacuum", schedule: .weekly, lastCompletedAt: Date(),
						nextDueAt: futureDate)
				let store = ChoreStore(
						chores: [expiredChore, activeChore], completedIndices: [0, 1])

				store.checkAndResetExpiredChores()

				#expect(store.status(for: 0) == .pending)
				#expect(store.status(for: 1) == .completed)
		}

		@Test func checkAndResetExpiredChoresWithCustomNowTime() {
				let futureDate = Date(timeIntervalSinceNow: 86400)
				let chore = Chore(
						title: "Dishes", schedule: .daily, lastCompletedAt: Date(),
						nextDueAt: futureDate)
				let store = ChoreStore(chores: [chore], completedIndices: [0])

				#expect(store.status(for: 0) == .completed)

				// Simulate time advancing past nextDueAt
				store.checkAndResetExpiredChores(now: Date(timeIntervalSinceNow: 86401))

				#expect(store.status(for: 0) == .pending)
				#expect(store.allChores[0].lastCompletedAt == nil)
				#expect(store.allChores[0].nextDueAt == nil)
		}

}
