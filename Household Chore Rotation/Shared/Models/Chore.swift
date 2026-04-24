//
//  Chore.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
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

struct Chore: Codable, Equatable, Identifiable {
	var id: UUID
	var title: String
	var schedule: ChoreSchedule

	init(id: UUID = UUID(), title: String, schedule: ChoreSchedule = .weekly) {
		self.id = id
		self.title = title
		self.schedule = schedule
	}

	private enum CodingKeys: String, CodingKey {
		case id
		case title
		case schedule
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
		title = try container.decode(String.self, forKey: .title)
		schedule = try container.decode(ChoreSchedule.self, forKey: .schedule)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(schedule, forKey: .schedule)
	}
}
