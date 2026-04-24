//
//  Household_Chore_RotationApp.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct RootView: View {
	@State private var path: [AppRoute] = []
	@State private var choreStore = ChoreStore(chores: [])

	var body: some View {
		NavigationStack(path: $path) {
			HomeView(choreStore: choreStore)
				.navigationDestination(for: AppRoute.self) { route in
					switch route {
					case .home:
						HomeView(choreStore: choreStore)
					case .addChore:
						AddChoresView(choreStore: choreStore)
					case .choreDetail(let choreID):
						if let chore = choreStore.allChores.first(where: { $0.id == choreID }) {
							ChoreDetailView(choreStore: choreStore, chore: chore)
						} else {
							Text("Chore not found")
						}
					}
				}
		}
	}
}

// @main
// struct Household_Chore_RotationApp: App {
// 	@State private var choreStore = ChoreStore(chores: [])

// 	var body: some Scene {
// 		WindowGroup {
// 			NavigationStack {
// 				HomeView(choreStore: choreStore)
// 			}
// 		}
// 	}
// }

@main
struct Household_Chore_RotationApp: App {
	var body: some Scene {
		WindowGroup {
			RootView()
		}
	}
}
