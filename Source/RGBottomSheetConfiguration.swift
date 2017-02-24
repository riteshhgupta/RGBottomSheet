//
//  RGBottomSheetConfiguration.swift
//  RGBottomSheet
//
//  Created by Ritesh Gupta on 23/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

open class RGBottomSheetConfiguration {
	public let overlayTintColor: UIColor
	public let blurTintColor: UIColor
	public let blurStyle: UIBlurEffectStyle
	public var showOverlay: Bool
	public var showBlur: Bool
	public var customOverlayView: UIView? {
		didSet {
			self.showOverlay = customOverlayView != nil
		}
	}
	public var customBlurView: UIVisualEffectView? {
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
	
	public init(
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
