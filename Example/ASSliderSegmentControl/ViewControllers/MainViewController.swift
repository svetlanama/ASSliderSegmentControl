//
//  MainViewController.swift
//  ASPageControllerSample
//
//  Created by Svitlana Moiseyenko on 3/18/16.
//  Copyright © 2016 Svitlana Moiseyenko. All rights reserved.
//

import Foundation
import UIKit
import ASSliderSegmentControl

enum ViewIndex: Int {
  case firstIndex = 0
  case secondIndex = 1
  case thirdIndex = 2
}

class MainViewController: UIViewController {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var navigationView: UIView!
  @IBOutlet weak var navigationViewBottom: UIView!
  

  private var isPageScrolling: Bool = false
  
  private var scrollView: UIScrollView! {
    didSet {
      scrollView.delegate = self
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  //MARK: Example of Text Segment control
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
    segmentControl.isButtomLine = false
    
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
    
    return segmentControl
  }()
  
  //MARK: Example of Image Segment Control
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
  
  
  @IBAction func onFirst(sender: AnyObject) {
    loadPadeItem(.firstIndex)
  }
  
  @IBAction func onSecond(sender: AnyObject) {
    loadPadeItem(.secondIndex)
  }
  
  
  @IBAction func onThird(sender: AnyObject) {
    loadPadeItem(.thirdIndex)
  }
  
  var pageViewController: PageViewController? {
    didSet {
      pageViewController?.pageViewControllerDelegate = self
    }
  }
  
  private var currentViewIndex: ViewIndex = .firstIndex
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationView.backgroundColor = UIColor(named: UIColor.AppColor.PickledBluewood)
    navigationViewBottom.backgroundColor = UIColor(named: UIColor.AppColor.PickledBluewood)
    containerView.backgroundColor = UIColor(named: UIColor.AppColor.BermudaGray)
    
    navigationView.addSubview(segmentControl)
    navigationViewBottom.addSubview(segmentControlImage)
    initScrollView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    segmentControl.updateControlConstraints()
    segmentControlImage.updateControlConstraints()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let pageViewController = segue.destinationViewController as? PageViewController {
      self.pageViewController = pageViewController
    }
  }
  
   // Set up delegate to track user scroll actions
  func initScrollView() {
    for v in pageViewController!.view.subviews{
      if v.isKindOfClass(UIScrollView){
        scrollView = v as! UIScrollView
      }
    }
  }
  
  func loadPadeItem(index: ViewIndex) {
    currentViewIndex = index
    pageViewController!.scrollToViewController(index: currentViewIndex.rawValue)
  }
  
  //MARK: Segment control
  func moveSegmentSelector(scrollView: UIScrollView) {
    
    let translation = scrollView.panGestureRecognizer.translationInView(self.view)
    var scrollDirection: HorizontalScrollDirection
    if translation.x > 0 {
      scrollDirection = HorizontalScrollDirection.Back
    } else {
      scrollDirection = HorizontalScrollDirection.Forward
    }
    
    if scrollView.contentOffset.x != scrollView.frame.size.width {
      //Move segment control
      var scrollX = scrollView.contentOffset.x - scrollView.frame.size.width
      if scrollDirection == HorizontalScrollDirection.Back {
        scrollX = scrollView.contentOffset.x
      }
      segmentControl.moveSelectorByScrollPosition(scrollX, index: currentViewIndex.rawValue, scrollDirection: scrollDirection)
      segmentControlImage.moveSelectorByScrollPosition(scrollX, index: currentViewIndex.rawValue, scrollDirection: scrollDirection)
    }
  }
}
extension MainViewController: ASSliderSegmentControlDelegate {
  func segmentedControlPressedItemAtIndex (segmentedControl: ASSliderSegmentControl, index: Int){
    loadPadeItem(ViewIndex(rawValue: index)!)
  }
  
}
extension MainViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    
    if !isPageScrolling {
      return
    }
    moveSegmentSelector(scrollView)
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    isPageScrolling = false
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    isPageScrolling = true
  }
}

extension MainViewController: PageViewControllerDelegate {
  
  func pageViewController(pageViewController: PageViewController,
                          didUpdatePageCount count: Int) {
  }
  
  func pageViewController(pageViewController: PageViewController,
                          didUpdatePageIndex index: Int) {
    self.currentViewIndex = ViewIndex(rawValue: index)!
    segmentControl.selectItemAtIndex(currentViewIndex.rawValue)
    segmentControlImage.selectItemAtIndex(currentViewIndex.rawValue)
  }
  
}


