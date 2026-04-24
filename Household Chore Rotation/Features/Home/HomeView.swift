//
//  HomeView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct HomeView: View {
		@Bindable var choreStore: ChoreStore

		private var hasChores: Bool {
				!choreStore.allChores.isEmpty
		}

		private var addChoresButton: some View {
				NavigationLink {
						AddChoresView(choreStore: choreStore)
				} label: {
						Label("Add", systemImage: "plus")
								.font(.subheadline.weight(.semibold))
				}
				.buttonStyle(.borderedProminent)
				.tint(.teal)
		}

		@ViewBuilder
		private var choreContent: some View {
				if hasChores {
						ChoreListSectionView(choreStore: choreStore)
				}
		}

		var body: some View {
				GradientScrollScreen {
						ScreenHeaderView(
								title: AppRoute.home.title,
								subtitle: AppRoute.home.subtitle
						) {
								addChoresButton
						}

						CurrentChoreCardView(choreStore: choreStore)
						choreContent
				}
		}
}

#Preview {
		let choreStore = ChoreStore(chores: [
				Chore(title: "Dishes", schedule: .daily),
				Chore(title: "Vacuum", schedule: .weekly),
				Chore(title: "Laundry", schedule: .weekly)

		])
		NavigationStack {
				HomeView(choreStore: choreStore)
		}
}
