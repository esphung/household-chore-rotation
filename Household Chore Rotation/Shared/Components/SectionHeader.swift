//
//  SectionHeader.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct SectionHeader: View {
	let title: String
	let subtitle: String

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			ThemedText(title, type: .screenTitle)
			ThemedText(subtitle, type: .screenSubtitle)
		}
	}
}

#Preview {
	SectionHeader(
		title: "Household Chores",
		subtitle: "Keep your home routine fair and organized"
	)
}
