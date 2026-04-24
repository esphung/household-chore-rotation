//
//  ThemedText.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

struct ThemedText: View {
	enum TextType {
		case screenTitle
		case screenSubtitle
		case sectionTitle
		case cardTitle
		case body
		case bodyMedium
		case caption
		case captionSemibold
		case captionBold

		var font: Font {
			switch self {
			case .screenTitle:
				return .system(.largeTitle, design: .rounded, weight: .bold)
			case .screenSubtitle:
				return .subheadline
			case .sectionTitle:
				return .headline
			case .cardTitle:
				return .system(.title, design: .rounded, weight: .bold)
			case .body:
				return .body
			case .bodyMedium:
				return .body.weight(.medium)
			case .caption:
				return .caption
			case .captionSemibold:
				return .caption.weight(.semibold)
			case .captionBold:
				return .caption.weight(.bold)
			}
		}

		var defaultStyle: Style {
			switch self {
			case .screenSubtitle, .caption:
				return .secondary
			default:
				return .primary
			}
		}
	}

	enum Style {
		case automatic
		case primary
		case secondary
		case inversePrimary
		case inverseSecondary
		case inversePrimaryBadge
		case destructive
		case custom(AnyShapeStyle)

		func foregroundStyle(for type: TextType) -> AnyShapeStyle {
			switch self {
			case .automatic:
				return type.defaultStyle.foregroundStyle(for: type)
			case .primary:
				return AnyShapeStyle(.primary)
			case .secondary:
				return AnyShapeStyle(.secondary)
			case .inversePrimary:
				return AnyShapeStyle(.white)
			case .inverseSecondary:
				return AnyShapeStyle(.white.opacity(0.85))
			case .inversePrimaryBadge:
				return AnyShapeStyle(.white)
			case .destructive:
				return AnyShapeStyle(.red)
			case .custom(let style):
				return style
			}
		}

		var horizontalPadding: CGFloat {
			switch self {
			case .inversePrimaryBadge:
				return 10
			default:
				return 0
			}
		}

		var verticalPadding: CGFloat {
			switch self {
			case .inversePrimaryBadge:
				return 4
			default:
				return 0
			}
		}

		var backgroundColor: Color? {
			switch self {
			case .inversePrimaryBadge:
				return Color.white.opacity(0.20)
			default:
				return nil
			}
		}
	}

	private let text: String
	private let systemImage: String?
	private let type: TextType
	private let style: Style

	init(
		_ text: String,
		systemImage: String? = nil,
		type: TextType = .body,
		style: Style = .automatic
	) {
		self.text = text
		self.systemImage = systemImage
		self.type = type
		self.style = style
	}

	@ViewBuilder
	var body: some View {
		if let backgroundColor = style.backgroundColor {
			content
				.padding(.horizontal, style.horizontalPadding)
				.padding(.vertical, style.verticalPadding)
				.background(backgroundColor)
				.clipShape(Capsule())
		} else {
			content
		}
	}

	@ViewBuilder
	private var content: some View {
		if let systemImage {
			Label(text, systemImage: systemImage)
				.font(type.font)
				.foregroundStyle(style.foregroundStyle(for: type))
		} else {
			Text(text)
				.font(type.font)
				.foregroundStyle(style.foregroundStyle(for: type))
		}
	}
}

#Preview {
	VStack(alignment: .leading, spacing: 8) {
		ThemedText("Household Chores", type: .screenTitle)
		ThemedText("Keep your home routine fair and organized", type: .screenSubtitle)
		ThemedText("Current Chores", type: .sectionTitle)
		ThemedText("Dishes", type: .body)
		ThemedText("Weekly", type: .caption)
		ThemedText("Warning", type: .body, style: .destructive)
		ThemedText("On Card", type: .captionSemibold, style: .inverseSecondary)
		ThemedText("In Progress", type: .captionSemibold, style: .inversePrimaryBadge)
	}
	.padding()
}
