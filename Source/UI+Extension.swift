//
//  UI+Extension.swift
//  RGBottomSheet
//
//  Created by Ritesh Gupta on 22/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	typealias ConstraintHandler = ([(ConstraintType, NSLayoutConstraint)]) -> Void
	
	enum ConstraintType: Equatable {
		case Top(Int, String?)
		case Bottom(Int, String?)
		case Left(Int, String?)
		case Right(Int, String?)
		case Width(Int)
		case Height(Int)
		
		func visualFormat(viewName: String) -> String {
			switch self {
			case .Top(let padding, let sibling):
				if let sibling = sibling {
					return "V:" + "|-(==0@1)-[\(sibling)]-\(padding)-" + "[\(viewName)]"
				}
				return "V:" + "|-\(padding)-" + "[\(viewName)]"
			case .Bottom(let padding, let sibling):
				let paddingString = "-(" + "\(padding)" + ")-"
				if let sibling = sibling {
					return "V:" + "[\(viewName)]" + paddingString + "[\(sibling)]-(==0@1)|"
				}
				return "V:" + "[\(viewName)]" + paddingString + "|"
			case .Left(let padding, let sibling):
				if let sibling = sibling {
					return "H:" + "|-(==0@1)-[\(sibling)]-\(padding)-" + "[\(viewName)]"
				}
				return "H:" + "|-\(padding)-" + "[\(viewName)]"
			case .Right(let padding, let sibling):
				if let sibling = sibling {
					return "H:" + "[\(viewName)]" + "-\(padding)-" + "[\(sibling)]-(==0@1)|"
				}
				return "H:" + "[\(viewName)]" + "-\(padding)-|"
			case .Width(let value):
				return "H:[\(viewName)(\(value))]"
			case .Height(let value):
				return "V:[\(viewName)(\(value))]"
			}
		}
		
		public static func == (lhs: ConstraintType, rhs: ConstraintType) -> Bool {
			switch (lhs, rhs) {
			case (.Top(_), .Top(_)):
				return true
			case (.Bottom(_), .Bottom(_)):
				return true
			case (.Left(_), .Left(_)):
				return true
			case (.Right(_), .Right(_)):
				return true
			case (.Height(_), .Height(_)):
				return true
			case (.Width(_), .Width(_)):
				return true
			default:
				return false
			}
		}
	}
	
	func add(
		contraintTypes: [ConstraintType] = [.Top(0, nil), .Bottom(0, nil), .Left(0, nil), .Right(0, nil)],
		subview: UIView,
		viewsDict: [String: UIView],
		completionHandler: ConstraintHandler? = nil
		)
	{
		var constraints: [(ConstraintType, NSLayoutConstraint)] = []
		let subviewName = viewsDict.filter { $0.1 == subview }.first?.0
		if let subviewName = subviewName {
			addSubview(subview)
			subview.translatesAutoresizingMaskIntoConstraints = false
			contraintTypes.forEach {
				let format = $0.visualFormat(viewName: subviewName)
				let constraint = NSLayoutConstraint.constraints(
					withVisualFormat: format,
					options: [],
					metrics: nil,
					views: viewsDict
				)
				let constraintTupple = ($0, constraint.first!)
				constraints.append(constraintTupple)
				addConstraints(
					constraint
				)
			}
			completionHandler?(constraints)
		}
	}
}
