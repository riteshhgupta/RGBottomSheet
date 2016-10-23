//
//  ViewController.swift
//  RGBottomSheet
//
//  Created by Ritesh Gupta on 22/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var sheet: RGBottomSheet?

	var bottomView: UIView {
		var screenBound = UIScreen.main.bounds
		screenBound.size.height = 200.0
		let bottomView = UIView(frame: screenBound)
		bottomView.backgroundColor = UIColor.white
		return bottomView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()		
		let config = RGBottomSheetConfiguration(
			showBlur: true
		)
		
		sheet = RGBottomSheet(
			withContentView: bottomView,
			configuration: config
		)
	}

	@IBAction func didTapShow(_ sender: UIButton) {
		sheet?.show()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
