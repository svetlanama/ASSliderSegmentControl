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

![Alt text](https://github.com/svetlanama/ASSliderSegmentControl/blob/master/demo/title_segment_control.png "Demo")
```swift
// create ASSliderSegmentControl with titles
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
    return segmentControl
  }()
```  

![Alt text](https://github.com/svetlanama/ASSliderSegmentControl/blob/master/demo/image_segment_control.png "Demo")
```swift
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
   return segmentControlImage
   }()

```

#### Customize UI
```swift
// remove buttom line 
segmentControl.isButtomLine = false

// remove selected line 
segmentControl.isSelectorLine = false 
 
//Customize control appearance
segmentControl.changeControlStyle (
          UIColor.clearColor(),
          selectedBackgroundColor: UIColor.clearColor(),
          textColor: UIColor(named: UIColor.AppColor.LinkWater).colorWithAlphaComponent(0.3),
          font: UIFont(name: "Helvetica", size: 17)!,
          selectedTextColor: UIColor(named: UIColor.AppColor.BisonHide),
          selectedFont:UIFont(name: "Helvetica", size: 17)!,
          bottomLineColor: UIColor(named: UIColor.AppColor.LinkWater),
          selectorColor: UIColor(named: UIColor.AppColor.BisonHide),
          bottomLineHeight: 0.5,
          selectorHeight: 3
      )
      
// Or just some parts like background color, text color, font, titleEdges, imageEdges
segmentControlImage.changeBackgroundControlStyle(UIColor.clearColor(), selectedBackgroundColor: UIColor(named:UIColor.AppColor.LinkWater).colorWithAlphaComponent(0.1))
```


## Author

https://github.com/alexnodejs

https://github.com/svetlanama

## License

ASSliderSegmentControl is available under the MIT license. See the LICENSE file for more info.
