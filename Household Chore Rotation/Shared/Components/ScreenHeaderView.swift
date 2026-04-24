//
//  ScreenHeaderView.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct ScreenHeaderView<TrailingContent: View>: View {
		let title: String
		let subtitle: String
		@ViewBuilder private let trailingContent: () -> TrailingContent

		init(
				title: String,
				subtitle: String,
				@ViewBuilder trailingContent: @escaping () -> TrailingContent
		) {
				self.title = title
				self.subtitle = subtitle
				self.trailingContent = trailingContent
		}

		init(
				title: String,
				subtitle: String
		) where TrailingContent == EmptyView {
				self.title = title
				self.subtitle = subtitle
				self.trailingContent = { EmptyView() }
		}

		var body: some View {
				VStack(alignment: .leading, spacing: 10) {
						HStack(alignment: .top) {
								SectionHeader(title: title, subtitle: subtitle)

								Spacer(minLength: 0)
								trailingContent()
						}
				}
		}
}

#Preview {
		VStack(spacing: 24) {
				ScreenHeaderView(
						title: "Add Chores",
						subtitle: "Easily add new chores to your household rotation"
				)

				ScreenHeaderView(
						title: "Household Chores",
						subtitle: "Keep your home routine fair and organized"
				) {
						Button("Add") {}
								.buttonStyle(.borderedProminent)
				}
		}
		.padding()
}
