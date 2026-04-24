//
//  BadgeStyle.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct BadgeStyle: ViewModifier {
		let textColor: Color?
		let backgroundColor: Color
		let horizontalPadding: CGFloat
		let verticalPadding: CGFloat

		init(
				textColor: Color? = nil,
				backgroundColor: Color,
				horizontalPadding: CGFloat = 10,
				verticalPadding: CGFloat = 4
		) {
				self.textColor = textColor
				self.backgroundColor = backgroundColor
				self.horizontalPadding = horizontalPadding
				self.verticalPadding = verticalPadding
		}

		func body(content: Content) -> some View {
				if let textColor {
						content
								.foregroundStyle(textColor)
								.padding(.horizontal, horizontalPadding)
								.padding(.vertical, verticalPadding)
								.background(backgroundColor)
								.clipShape(Capsule())
				} else {
						content
								.padding(.horizontal, horizontalPadding)
								.padding(.vertical, verticalPadding)
								.background(backgroundColor)
								.clipShape(Capsule())
				}
		}
}

extension View {
		func badgeStyle(
				textColor: Color? = .white,
				backgroundColor: Color,
				horizontalPadding: CGFloat = 10,
				verticalPadding: CGFloat = 4
		) -> some View {
				modifier(
						BadgeStyle(
								textColor: textColor,
								backgroundColor: backgroundColor,
								horizontalPadding: horizontalPadding,
								verticalPadding: verticalPadding
						)
				)
		}
}

#Preview {
		VStack(alignment: .leading, spacing: 8) {
				ThemedText("Pending", type: .captionSemibold, style: .custom(AnyShapeStyle(.orange)))
						.badgeStyle(backgroundColor: .orange.opacity(0.14))

				ThemedText("Completed", type: .captionSemibold)
						.badgeStyle(textColor: .green, backgroundColor: .green.opacity(0.14))
		}
}
