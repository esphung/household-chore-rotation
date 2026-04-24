//
//  AppRoute.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import Foundation

enum AppRoute: Hashable {
		case home
		case addChore
		case choreDetail(choreID: UUID)

		var title: String {
				switch self {
				case .home:
						return "Home"
				case .addChore:
						return "Add Chore"
				case .choreDetail:
						return "Chore Detail"
				}
		}

		var subtitle: String {
				switch self {
				case .home:
						return "Manage your household chores with ease"
				case .addChore:
						return "Easily add new chores to your household rotation"
				case .choreDetail:
						return "View and edit chore details"
				}
		}
}
