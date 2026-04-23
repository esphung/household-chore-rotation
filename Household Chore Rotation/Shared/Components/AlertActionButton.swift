//
//  AlertActionButton.swift
//  Household Chore Rotation
//
//  Created by Eric Phung on 4/22/26.
//

import SwiftUI

struct AlertActionButton: View {
	let buttonTitle: String
	let systemImage: String?
	let alertTitle: String?
	let alertMessage: String?
	let confirmButtonTitle: String
	let onConfirm: () -> Void
	let onCancel: () -> Void

	@State private var showingAlert = false

	init(
		buttonTitle: String,
		systemImage: String? = nil,
		alertTitle: String? = nil,
		alertMessage: String? = nil,
		confirmButtonTitle: String = "Confirm",
		onConfirm: @escaping () -> Void = {},
		onCancel: @escaping () -> Void = {}
	) {
		self.buttonTitle = buttonTitle
		self.systemImage = systemImage
		self.alertTitle = alertTitle
		self.alertMessage = alertMessage
		self.confirmButtonTitle = confirmButtonTitle
		self.onConfirm = onConfirm
		self.onCancel = onCancel
	}

	var body: some View {
		Button {
			showingAlert = true
		} label: {
			buttonLabel
		}
		.alert(alertTitle ?? "Alert", isPresented: $showingAlert) {
			Button("Cancel", role: .cancel, action: onCancel)
			Button(confirmButtonTitle, action: onConfirm)
		} message: {
			if let alertMessage {
				Text(alertMessage)
			}
		}
	}

	@ViewBuilder
	private var buttonLabel: some View {
		if let systemImage {
			Label(buttonTitle, systemImage: systemImage)
		} else {
			Text(buttonTitle)
		}
	}
}

#Preview {
	Group {
		AlertActionButton(
			buttonTitle: "Show Alert w/ Props",
			systemImage: "bell.badge",
			alertTitle: "Chore Reminder",
			alertMessage: "Time to rotate chores!",
			confirmButtonTitle: "Confirm",
			onConfirm: {
				print("Confirm pressed")
			},
			onCancel: {
				print("Cancel pressed")
			}
		)

		AlertActionButton(
			buttonTitle: "Show Alert Default",
			alertTitle: "Chore Reminder"
		)
	}
}
