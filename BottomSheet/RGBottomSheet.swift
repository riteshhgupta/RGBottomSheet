//
//  RGBottomSheet.swift
//  BottomSheet
//
//  Created by Ritesh Gupta on 22/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

class RGBottomSheetView: UIView {
	var contentView: UIView?
	var overlayView: UIButton?
	var contentViewBottomConstraint: NSLayoutConstraint?
	
	init() {
		super.init(frame: CGRect.zero)
		commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		let screenBounds = UIScreen.main.bounds

		backgroundColor = UIColor.clear
		alpha = 0.0
		frame = screenBounds

		let color = UIColor.black.withAlphaComponent(0.7)
		overlayView = UIButton(frame: screenBounds)
		overlayView?.backgroundColor = color
		overlayView?.alpha = 0.0
	}
}

class RGBottomSheet {
	
	let sheetView = RGBottomSheetView()
	var topWindow: UIWindow?
	
	func topWindow(handler: @escaping (UIWindow?) -> Void) {
		DispatchQueue.main.async {
			handler(UIApplication.shared.keyWindow)
		}
	}
	
	func configure(withView view: UIView) {
		let contentViewHeight = Int(view.bounds.height)
		sheetView.contentView = view
		sheetView.add(
			subview: self.sheetView.overlayView!,
			viewsDict: ["bottomSheetOverlayView": self.sheetView.overlayView!]
		)
		sheetView.add(
			contraintTypes: [
				.Bottom(-contentViewHeight, nil),
				.Left(0, nil),
				.Right(0, nil),
				.Height(contentViewHeight)
			],
			subview: view,
			viewsDict: ["bottomSheetContentView": view],
			completionHandler: { [weak self] constraints in
				let bottomConstraint = constraints
					.filter { $0.0 == UIView.ConstraintType.Bottom(0, nil) }
					.first?
					.1
				self?.sheetView.contentViewBottomConstraint = bottomConstraint
			})
		topWindow { (window: UIWindow?) in
			self.topWindow = window
			window?.add(
				subview: self.sheetView,
				viewsDict: ["bottomSheetView": self.sheetView]
			)
		}
		sheetView.overlayView?.addTarget(
			self,
			action: #selector(RGBottomSheet.didTapOverlay(button:)),
			for: .touchUpInside
		)
	}
	
	@objc func didTapOverlay(button: UIButton) {
		hide()
	}
	
	func show() {
		sheetView.alpha = 1.0
		sheetView.contentViewBottomConstraint?.constant = 0.0

		animateWithDefaultOptions(animation: { 
			self.sheetView.overlayView?.alpha = 1.0
			self.topWindow?.layoutIfNeeded()
		})
	}

	func hide() {
		let height = sheetView.contentView?.bounds.height ?? 0.0
		sheetView.contentViewBottomConstraint?.constant = -height

		animateWithDefaultOptions(animation: {
			self.sheetView.overlayView?.alpha = 0.0
			self.topWindow?.layoutIfNeeded()
			
			}) { 
				self.sheetView.alpha = 0.0
		}
	}
	
	func animateWithDefaultOptions(animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
		UIView.animate(
			withDuration: 0.3,
			delay: 0.0,
			usingSpringWithDamping: 0.9,
			initialSpringVelocity: 1.0,
			options: UIViewAnimationOptions.beginFromCurrentState,
			animations: {
				animation()
		}) { (_) in
			completion?()
		}
	}
}
