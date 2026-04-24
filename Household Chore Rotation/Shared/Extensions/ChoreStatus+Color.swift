//
//  ChoreStatus+Color.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/23/26.
//

import SwiftUI

extension ChoreStore.ChoreStatus {
		var cardBadgeColor: Color {
				cardBadgeColor(isLightBackground: false)
		}

		func cardBadgeColor(isLightBackground: Bool) -> Color {
				switch self {
				case .pending:
						return isLightBackground ? .gray : .white
				case .completed:
						return .green.opacity(0.9)
				}
		}
}
