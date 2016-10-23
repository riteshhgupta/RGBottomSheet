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
	var blurView: UIVisualEffectView?
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
		let screenBound = UIScreen.main.bounds

		backgroundColor = UIColor.clear
		alpha = 0.0
		frame = screenBound
		
		let color = UIColor.black.withAlphaComponent(0.7)
		overlayView = UIButton(frame: screenBound)
		overlayView?.backgroundColor = color
		overlayView?.alpha = 0.0
		
		let effect = UIBlurEffect(style: .dark)
		blurView = UIVisualEffectView(frame: screenBound)
		blurView?.effect = effect
		blurView?.alpha = 0.0
		blurView?.isUserInteractionEnabled = false
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
	
	func configure(withContentView contentView: UIView) {
		let contentViewHeight = Int(contentView.bounds.height)
		sheetView.contentView = contentView
		sheetView.add(
			subview: self.sheetView.blurView!,
			viewsDict: ["bottomSheetBlurView": self.sheetView.blurView!]
		)
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
			subview: contentView,
			viewsDict: ["bottomSheetContentView": contentView],
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
			self.sheetView.blurView?.alpha = 1.0
			self.topWindow?.layoutIfNeeded()
		})
	}

	func hide() {
		let height = sheetView.contentView?.bounds.height ?? 0.0
		sheetView.contentViewBottomConstraint?.constant = -height

		animateWithDefaultOptions(animation: {
			self.sheetView.overlayView?.alpha = 0.0
			self.sheetView.blurView?.alpha = 0.0
			self.topWindow?.layoutIfNeeded()
			
			}) { 
				self.sheetView.alpha = 0.0
		}
	}
	
	func animateWithDefaultOptions(animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
		UIView.animate(
			withDuration: 0.4,
			delay: 0.0,
			usingSpringWithDamping: 0.8,
			initialSpringVelocity: 1.0,
			options: UIViewAnimationOptions.beginFromCurrentState,
			animations: {
				animation()
		}) { (_) in
			completion?()
		}
	}
}
