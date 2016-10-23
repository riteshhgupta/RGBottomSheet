//
//  RGBottomSheet.swift
//  BottomSheet
//
//  Created by Ritesh Gupta on 22/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

typealias Callback = () -> ()

class RGBottomSheetView: UIView {
	var overlayView = UIView()
	var blurView = UIVisualEffectView()
	let overlayButton = UIButton()

	var contentView: UIView?
	var contentViewBottomConstraint: NSLayoutConstraint?
	var didTapOverlayView: Callback?
	
	init() {
		super.init(frame: CGRect.zero)
		commonInit()
	}
	
	init(configuration: RGBottomSheetConfiguration) {
		super.init(frame: CGRect.zero)
		commonInit(configuration: configuration)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}	
	
	func commonInit(configuration: RGBottomSheetConfiguration = RGBottomSheetConfiguration()) {
		configureSelf()
		configureOverlayButton()
		configureOverlay(withConfiguration: configuration)
		configureBlur(withConfiguration: configuration)
	}
	
	func didTap(overlayView: UIView) {
		didTapOverlayView?()
	}
	
	var screenBound: CGRect {
		return UIScreen.main.bounds
	}
	
	func configureSelf() {
		backgroundColor = UIColor.clear
		alpha = 0.0
		frame = screenBound
	}
	
	func configureOverlayButton() {
		overlayButton.frame = screenBound
		overlayButton.backgroundColor = UIColor.clear
		overlayButton.addTarget(
			self,
			action: #selector(RGBottomSheetView.didTap(overlayView:)),
			for: .touchUpInside
		)
	}
	
	func configureOverlay(withConfiguration configuration: RGBottomSheetConfiguration) {
		if let customView = configuration.customOverlayView {
			overlayView = customView
		} else {
			overlayView.backgroundColor = configuration.overlayTintColor
		}
		overlayView.frame = screenBound
		overlayView.alpha = 0.0
	}
	
	func configureBlur(withConfiguration configuration: RGBottomSheetConfiguration) {
		if let customView = configuration.customBlurView {
			blurView = customView
		} else {
			let effect = UIBlurEffect(style: configuration.blurStyle)
			blurView.effect = effect
			blurView.contentView.backgroundColor = configuration.blurTintColor
		}
		blurView.frame = screenBound
		blurView.alpha = 0.0
		blurView.isUserInteractionEnabled = false
	}
}

class RGBottomSheetConfiguration {
	let overlayTintColor: UIColor
	let blurTintColor: UIColor
	let blurStyle: UIBlurEffectStyle
	var showOverlay: Bool
	var showBlur: Bool
	var customOverlayView: UIView? {
		didSet {
			self.showOverlay = customOverlayView != nil
		}
	}
	var customBlurView: UIVisualEffectView? {
		didSet {
			self.showBlur = customBlurView != nil
		}
	}
	
	var overlayShowAlpha: CGFloat {
		return showOverlay ? 1.0 : 0.0
	}
	
	var blurShowAlpha: CGFloat {
		return showBlur ? 1.0 : 0.0
	}
	
	init(
		showOverlay: Bool = false,
		showBlur: Bool = false,
		overlayTintColor: UIColor = UIColor.black.withAlphaComponent(0.7),
		blurTintColor: UIColor = UIColor.clear,
		blurStyle: UIBlurEffectStyle = .dark,
		customOverlayView: UIView? = nil,
		customBlurView: UIVisualEffectView? = nil)
	{
		self.showOverlay = showOverlay
		self.showBlur = showBlur
		self.overlayTintColor = overlayTintColor
		self.blurTintColor = blurTintColor
		self.blurStyle = blurStyle
		self.customOverlayView = customOverlayView
		self.customBlurView = customBlurView
	}
}

class RGBottomSheet {
	
	let sheetView: RGBottomSheetView
	let configuration: RGBottomSheetConfiguration
	
	var willShow: Callback?
	var didShow: Callback?
	var willHide: Callback?
	var didHide: Callback?
	
	var topWindow: UIWindow?
	
	init(
		withContentView contentView: UIView,
		configuration: RGBottomSheetConfiguration = RGBottomSheetConfiguration())
	{
		self.configuration =  configuration
		sheetView = RGBottomSheetView(configuration: configuration)
		sheetView.contentView = contentView
		
		let contentViewHeight = Int(contentView.bounds.height)
		
		sheetView.add(
			subview: sheetView.blurView,
			viewsDict: ["bottomSheetBlurView": sheetView.blurView]
		)
		sheetView.add(
			subview: sheetView.overlayView,
			viewsDict: ["bottomSheetOverlayView": sheetView.overlayView]
		)
		sheetView.add(
			subview: sheetView.overlayButton,
			viewsDict: ["bottomSheetOverlayButtonView": sheetView.overlayButton]
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
		topWindow { [weak self] (window: UIWindow?) in
			guard let this = self else { return }
			this.topWindow = window
			window?.add(
				subview: this.sheetView,
				viewsDict: ["bottomSheetView": this.sheetView]
			)
		}
		sheetView.didTapOverlayView = { [weak self] in
			self?.hide()
		}
	}
	
	func topWindow(handler: @escaping (UIWindow?) -> Void) {
		DispatchQueue.main.async {
			handler(UIApplication.shared.keyWindow)
		}
	}
	
	func show() {
		willShow?()
		sheetView.alpha = 1.0
		sheetView.contentViewBottomConstraint?.constant = 0.0
		
		animateWithDefaultOptions(animation: {
			self.sheetView.overlayView.alpha = self.configuration.overlayShowAlpha
			self.sheetView.blurView.alpha = self.configuration.blurShowAlpha
			self.topWindow?.layoutIfNeeded()
		}) {
			self.didShow?()
		}
	}
	
	func hide() {
		willHide?()
		let height = sheetView.contentView?.bounds.height ?? 0.0
		sheetView.contentViewBottomConstraint?.constant = -height
		
		animateWithDefaultOptions(animation: {
			self.sheetView.overlayView.alpha = 0.0
			self.sheetView.blurView.alpha = 0.0
			self.topWindow?.layoutIfNeeded()
		}) {
			self.sheetView.alpha = 0.0
			self.didHide?()
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

