#RGBottomSheet

**RGBottomSheet** is an iOS UI component which presents a dismissible view from the bottom of the screen. It can hold any Custom UIView so the use cases are endless. Its designed to abstract out the logic of displaying such bottom views and let the developer just focus on its custom view which they need to present. It offers **translucent**, **blur** or clear overlays!

Made in Swift 3.0 🚀

##Installation
To integrate RGBottomSheet into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'RGBottomSheet', '~> 1.0'
```

##Getting Started


```swift
import RGBottomSheet

let config = RGBottomSheetConfiguration(
	showBlur: true
)
	
let sheet = RGBottomSheet(
	withContentView: myCustomBottomView,
	configuration: config
)

sheet.show()
```

## Customisation
RGBottomSheet provides a simple interface to initialise as well as customise it. Content view used in the initialisation is the custom bottom view which you want to present from bottom. It has built in translucent & blurry background which you can customise using `RGBottomSheetConfiguration` class e.g.
	
	- overlayTintColor
	- blurTintColor
	- blurStyle
	- showOverlay
	- showBlur

You can choose to show/hide either translucent or blurry or both views to meet your design needs. If you still don't feel satisfied then you can simply pass your custom translucent/blurry view which this library will overlay on the screen behind your content view. 


##Callbacks
RGBottomSheet provides some handy callbacks which you can use to perform your custom animations along with show/hide of your bottom view!

	- willShow { }
	- didShow { }
	- willHide { }
	- didHide { }


## Contributing

Open an issue or send pull request [here](https://github.com/riteshhgupta/RGBottomSheet/issues/new).

## Licence

RGBottomSheet is available under the MIT license. See the LICENSE file for more info.