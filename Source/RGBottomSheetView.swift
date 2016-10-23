//
//  RGBottomSheetView.swift
//  RGBottomSheet
//
//  Created by Ritesh Gupta on 23/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

class RGBottomSheetView: UIView {
	var overlayView = UIView()
	var blurView = UIVisualEffectView()
	let overlayButton = UIButton()
	
	let contentView: UIView
	var contentViewBottomConstraint: NSLayoutConstraint?
	var didTapOverlayView: Callback?
	
	convenience init() {
		self.init(withContentView: UIView(), configuration: RGBottomSheetConfiguration())
	}
	
	init(withContentView contentView: UIView, configuration: RGBottomSheetConfiguration) {
		self.contentView = contentView
		super.init(frame: CGRect.zero)
		commonInit(configuration: configuration)
	}
	
	convenience override init(frame: CGRect) {
		self.init(withContentView: UIView(frame: frame), configuration: RGBottomSheetConfiguration())
	}
	
	convenience required public init?(coder aDecoder: NSCoder) {
		self.init(withContentView: UIView(), configuration: RGBottomSheetConfiguration())
	}
	
	fileprivate func commonInit(
		configuration: RGBottomSheetConfiguration = RGBottomSheetConfiguration())
	{
		configureSelf()
		configureOverlayButton()
		configureOverlay(withConfiguration: configuration)
		configureBlur(withConfiguration: configuration)
		addSubviews()
	}
	
	func didTap(overlayView: UIView) {
		didTapOverlayView?()
	}
	
	fileprivate var screenBound: CGRect {
		return UIScreen.main.bounds
	}
	
	fileprivate func configureSelf() {
		backgroundColor = UIColor.clear
		alpha = 0.0
		frame = screenBound
	}
	
	fileprivate func configureOverlayButton() {
		overlayButton.frame = screenBound
		overlayButton.backgroundColor = UIColor.clear
		overlayButton.addTarget(
			self,
			action: #selector(RGBottomSheetView.didTap(overlayView:)),
			for: .touchUpInside
		)
	}
	
	fileprivate func configureOverlay(withConfiguration configuration: RGBottomSheetConfiguration) {
		if let customView = configuration.customOverlayView {
			overlayView = customView
		} else {
			overlayView.backgroundColor = configuration.overlayTintColor
		}
		overlayView.frame = screenBound
		overlayView.alpha = 0.0
	}
	
	fileprivate func configureBlur(withConfiguration configuration: RGBottomSheetConfiguration) {
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
	
	fileprivate func addSubviews() {
		let contentViewHeight = Int(contentView.bounds.height)		
		add(
			subview: blurView,
			viewsDict: ["bottomSheetBlurView": blurView]
		)
		add(
			subview: overlayView,
			viewsDict: ["bottomSheetOverlayView": overlayView]
		)
		add(
			subview: overlayButton,
			viewsDict: ["bottomSheetOverlayButtonView": overlayButton]
		)
		add(
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
				self?.contentViewBottomConstraint = bottomConstraint
			})
	}
}
