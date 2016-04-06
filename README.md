# ASSliderSegmentControl

[![CI Status](http://img.shields.io/travis/Svitlana Moiseyenko/ASSliderSegmentControl.svg?style=flat)](https://travis-ci.org/Svitlana Moiseyenko/ASSliderSegmentControl)
[![Version](https://img.shields.io/cocoapods/v/ASSliderSegmentControl.svg?style=flat)](http://cocoapods.org/pods/ASSliderSegmentControl)
[![License](https://img.shields.io/cocoapods/l/ASSliderSegmentControl.svg?style=flat)](http://cocoapods.org/pods/ASSliderSegmentControl)
[![Platform](https://img.shields.io/cocoapods/p/ASSliderSegmentControl.svg?style=flat)](http://cocoapods.org/pods/ASSliderSegmentControl)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)

## Features
- [x] Customizable UI
- [x] Animation
- [x] Interaction with page scrolling
- [x] Following by scroll position




## Demo

![Alt text](https://github.com/svetlanama/ASSliderSegmentControl/blob/master/demo/animation12.gif "Demo")

## Requirements
- Swift
- Swift2

## Installation

ASSliderSegmentControl is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ASSliderSegmentControl"
```
## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### Create ASSliderSegmentControl
```swift
// create ASSliderSegmentControl with titles
![Alt text](https://github.com/svetlanama/ASSliderSegmentControl/blob/master/demo/title_segment_control.png "Demo")
lazy var segmentControl: ASSliderSegmentControl = {
    
    let segmentControl = ASSliderSegmentControl(frame:
      CGRect(
        x: 0,
        y: 0,
        width:
        self.view.bounds.width,
        height: self.navigationView.bounds.height),
                                                titleItems: [
                                                  "Discover",
                                                  "Home",
                                                  "Settings"
      ])
    
    segmentControl.delegate = self
    return segmentControl
  }()


// create ASSliderSegmentControl with images
lazy var segmentControlImage: ASSliderSegmentControl = {
   
   let segmentControlImage = ASSliderSegmentControl(frame:
   CGRect(
   x: 0,
   y: 0,
   width:
   self.view.bounds.width,
   height: self.navigationView.bounds.height),
   imageItems: [
   UIImage(named: "search")!,
   UIImage(named: "home")!,
   UIImage(named: "settings")!
   ],
   imageItemsHighlighted: [
   UIImage(named: "search_selected")!,
   UIImage(named: "home_selected")!,
   UIImage(named: "settings_selected")!
   ])
   segmentControlImage.delegate = self
   segmentControlImage.isSelectorLine = false
   segmentControlImage.isButtomLine = false
  segmentControlImage.changeBackgroundControlStyle(UIColor.clearColor(), selectedBackgroundColor: UIColor(named:UIColor.AppColor.LinkWater).colorWithAlphaComponent(0.1))
   return segmentControlImage
   }()

```

## Author

https://github.com/alexnodejs

https://github.com/svetlanama

## License

ASSliderSegmentControl is available under the MIT license. See the LICENSE file for more info.
