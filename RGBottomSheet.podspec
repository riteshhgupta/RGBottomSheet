Pod::Spec.new do |spec|
  spec.name         =  'RGBottomSheet'
  spec.version      =  '1.0'
  spec.summary   =  'RGBottomSheet is an iOS UI component which presents a dismissible view from the bottom of the screen!'
  spec.author = {
    'Ritesh Gupta' => 'rg.riteshh@gmail.com'
  }
  spec.license          =  'MIT' 
  spec.homepage         =  'https://github.com/riteshhgupta/RGBottomSheet'
  spec.source = {
    :git => 'https://github.com/riteshhgupta/RGBottomSheet.git',
    :tag => '1.0'
  }
  spec.ios.deployment_target = "8.0"
  spec.source_files =  'Source/*.{swift}'
  spec.requires_arc     =  true
end
