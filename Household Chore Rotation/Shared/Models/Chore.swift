//
//  Chore.swift
//  Household Chore Rotation
//
//  Created by GitHub Copilot on 4/23/26.
//

import Foundation

enum ChoreSchedule: String, Codable, CaseIterable {
	case daily = "Daily"
	case weekly = "Weekly"
	case monthly = "Monthly"

	var systemImage: String {
		switch self {
		case .daily: return "sun.max.fill"
		case .weekly: return "calendar.circle.fill"
		case .monthly: return "calendar.badge.clock"
		}
	}

	var dueInterval: DateComponents {
		switch self {
		case .daily:
			return DateComponents(day: 1)
		case .weekly:
			return DateComponents(day: 7)
		case .monthly:
			return DateComponents(month: 1)
		}
	}

	/// Returns the next due date from a given start date.
	func nextDueDate(from date: Date, calendar: Calendar = .current) -> Date {
		calendar.date(byAdding: dueInterval, to: date) ?? date
	}
}

struct Chore: Codable, Equatable {
	var title: String
	var schedule: ChoreSchedule

	init(title: String, schedule: ChoreSchedule = .weekly) {
		self.title = title
		self.schedule = schedule
	}
}
