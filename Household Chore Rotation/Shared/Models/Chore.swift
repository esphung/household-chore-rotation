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
		var lastCompletedAt: Date?
		var nextDueAt: Date?

		init(
				id: UUID = UUID(),
				title: String,
				schedule: ChoreSchedule = .weekly,
				lastCompletedAt: Date? = nil,
				nextDueAt: Date? = nil
		) {
				self.id = id
				self.title = title
				self.schedule = schedule
				self.lastCompletedAt = lastCompletedAt
				self.nextDueAt = nextDueAt
		}

		private enum CodingKeys: String, CodingKey {
				case id
				case title
				case schedule
				case lastCompletedAt
				case nextDueAt
		}

		init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
				title = try container.decode(String.self, forKey: .title)
				schedule = try container.decode(ChoreSchedule.self, forKey: .schedule)
				lastCompletedAt = try container.decodeIfPresent(Date.self, forKey: .lastCompletedAt)
				nextDueAt = try container.decodeIfPresent(Date.self, forKey: .nextDueAt)
		}

		func encode(to encoder: Encoder) throws {
				var container = encoder.container(keyedBy: CodingKeys.self)
				try container.encode(id, forKey: .id)
				try container.encode(title, forKey: .title)
				try container.encode(schedule, forKey: .schedule)
				try container.encodeIfPresent(lastCompletedAt, forKey: .lastCompletedAt)
				try container.encodeIfPresent(nextDueAt, forKey: .nextDueAt)
		}
}
