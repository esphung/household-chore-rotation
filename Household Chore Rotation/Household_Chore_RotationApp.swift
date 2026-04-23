//
//  Household_Chore_RotationApp.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

@main
struct Household_Chore_RotationApp: App {
	private let defaultChores = ["Dishes", "Vacuum", "Laundry", "Trash"]
	@State private var choreStore: ChoreStore

	init() {
		_choreStore = State(initialValue: ChoreStore(chores: defaultChores))
	}

	var body: some Scene {
		WindowGroup {
			ScreenSelectionView()
				.environment(choreStore)
		}
	}
}
