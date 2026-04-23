//
//  Household_Chore_RotationApp.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

@main
struct Household_Chore_RotationApp: App {
	@State private var choreStore = ChoreStore(chores: [])

	var body: some Scene {
		WindowGroup {
			NavigationStack {
				HomeView(choreStore: choreStore)
			}
		}
	}
}
