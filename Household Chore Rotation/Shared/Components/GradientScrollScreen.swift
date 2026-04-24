//
//  GradientScrollScreen.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct GradientScrollScreen<Content: View>: View {
	private let isScrollView: Bool
	private let showsIndicators: Bool
	private let contentSpacing: CGFloat
	private let horizontalPadding: CGFloat
	private let verticalPadding: CGFloat
	private let alignment: HorizontalAlignment
	@ViewBuilder private let content: () -> Content

	init(
		isScrollView: Bool = true,
		showsIndicators: Bool = false,
		contentSpacing: CGFloat = 20,
		horizontalPadding: CGFloat = 20,
		verticalPadding: CGFloat = 28,
		alignment: HorizontalAlignment = .leading,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.isScrollView = isScrollView
		self.showsIndicators = showsIndicators
		self.contentSpacing = contentSpacing
		self.horizontalPadding = horizontalPadding
		self.verticalPadding = verticalPadding
		self.alignment = alignment
		self.content = content
	}

	var body: some View {
		ZStack {
			LinearGradient(
				colors: [Color.indigo.opacity(0.20), Color.teal.opacity(0.12), Color.white],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()

			if isScrollView {
				ScrollView(showsIndicators: showsIndicators) {
					contentStack
				}
			} else {
				contentStack
			}
		}
	}

	private var contentStack: some View {
		VStack(alignment: alignment, spacing: contentSpacing) {
			content()
		}
		.padding(.horizontal, horizontalPadding)
		.padding(.vertical, verticalPadding)
	}
}

#Preview {
	GradientScrollScreen {
		Text("Example")
	}
	// Padding example
	GradientScrollScreen(
		horizontalPadding: 60,
		verticalPadding: 60
	) {
		Text("Example with custom padding")
	}

	// Alignment example
	GradientScrollScreen(alignment: .center) {
		Text("Centered Content")
	}

	// Non-scrollable example
	GradientScrollScreen(isScrollView: false) {
		Text("Non-scrollable Content")
	}
}
