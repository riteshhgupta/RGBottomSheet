//
//  ViewController.swift
//  BottomSheet
//
//  Created by Ritesh Gupta on 22/10/16.
//  Copyright © 2016 Ritesh Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let sheet = RGBottomSheet()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		var screenBound = UIScreen.main.bounds
		screenBound.size.height = 200.0
		let bottomView = UIView(frame: screenBound)
		bottomView.backgroundColor = UIColor.blue
		sheet.configure(withView: bottomView)
	}

	@IBAction func didTapShow(_ sender: UIButton) {
		sheet.show()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
