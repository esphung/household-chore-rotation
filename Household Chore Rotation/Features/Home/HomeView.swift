//
//  HomeView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct HomeView: View {
	@Bindable var choreStore: ChoreStore

	var body: some View {
		ZStack {
			LinearGradient(
				colors: [Color.indigo.opacity(0.20), Color.teal.opacity(0.12), Color.white],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()

			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 20) {
					headerSection
					CurrentChoreCardView(choreStore: choreStore)
					if !choreStore.allChores.isEmpty {
						ChoreActionsView(choreStore: choreStore)
						ChoreListSectionView(choreStore: choreStore)
					}
				}
				.padding(.horizontal, 20)
				.padding(.vertical, 28)
			}
		}
		.onAppear {
			choreStore.setCurrentToFirstNonCompletedChore()
		}
	}

	private var headerSection: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack(alignment: .top) {
				VStack(alignment: .leading, spacing: 6) {
					Text("Household Chores")
						.font(.system(.largeTitle, design: .rounded, weight: .bold))
					Text("Keep your home routine fair and organized")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}

				Spacer(minLength: 0)

				NavigationLink {
					AddChoresView(choreStore: choreStore)
				} label: {
					Label("Add", systemImage: "plus")
						.font(.subheadline.weight(.semibold))
				}
				.buttonStyle(.borderedProminent)
				.tint(.teal)
			}
		}
	}
}

#Preview {
	NavigationStack {
		HomeView(
			choreStore: ChoreStore(chores: []))
	}
}
