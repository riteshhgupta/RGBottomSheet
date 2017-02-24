//
//  RGBottomSheet.swift
//  RGBottomSheet
//
//  Created by Ritesh Gupta on 22/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

public typealias Callback = () -> ()

open class RGBottomSheet {
	
	fileprivate let sheetView: RGBottomSheetView
	fileprivate var topWindow: UIWindow?
	
	public let configuration: RGBottomSheetConfiguration
	public var willShow: Callback?
	public var didShow: Callback?
	public var willHide: Callback?
	public var didHide: Callback?
	
	public init(
		withContentView contentView: UIView,
		configuration: RGBottomSheetConfiguration = RGBottomSheetConfiguration())
	{
		self.configuration =  configuration
		sheetView = RGBottomSheetView(
			withContentView: contentView,
			configuration: configuration
		)
		sheetView.didTapOverlayView = { [weak self] in
			self?.hide()
		}
		topWindow { [weak self] (window: UIWindow?) in
			guard let this = self else { return }
			this.topWindow = window
			window?.add(
				subview: this.sheetView,
				viewsDict: ["bottomSheetView": this.sheetView]
			)
		}
	}
	
	fileprivate func topWindow(handler: @escaping (UIWindow?) -> Void) {
		DispatchQueue.main.async {
			handler(UIApplication.shared.keyWindow)
		}
	}
	
	open func show() {
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
	
	open func hide() {
		willHide?()
		let height = sheetView.contentView.bounds.height
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
	
	fileprivate func animateWithDefaultOptions(animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
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

