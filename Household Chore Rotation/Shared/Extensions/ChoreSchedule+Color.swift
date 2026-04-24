//
//  ChoreSchedule+Color.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

extension ChoreSchedule {
	var badgeColor: Color {
		switch self {
		case .daily:
			return .orange
		case .weekly:
			return .teal
		case .monthly:
			return .purple
		}
	}
}
