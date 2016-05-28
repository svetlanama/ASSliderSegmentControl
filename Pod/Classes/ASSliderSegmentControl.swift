//
//  ASSliderSegmentControl.swift
//  ASPageControllerSample
//
//  Created by Alexander Vasileyko  and Svitlana Moiseyenko on 3/27/16.
//  Copyright © 2016 Svitlana Moiseyenko. All rights reserved.
//

//
//  SeshSegmentControl.swift
//  sesh
//
//  Created by Alexander on 17.05.16.
//  Copyright © 2016 Silicon Valley Insight. All rights reserved.
//

import Foundation
import UIKit

// Scroll direction enum
public enum HorizontalScrollDirection: Int {
  case Forward = 0
  case Back = 1
}

// The struct to contain all params for control Appearance
struct ASSegmentControlStyle {
  var backgroundColor: UIColor
  var selectedBackgroundColor: UIColor
  var textColor: UIColor
  var font: UIFont
  var selectedTextColor: UIColor
  var selectedFont: UIFont
  var bottomLineColor: UIColor
  var selectorColor: UIColor
  var bottomLineHeight: CGFloat
  var selectorHeight: CGFloat
  var imageEdgeInsets: UIEdgeInsets
  var imageHighlightedEdgeInsets: UIEdgeInsets
  var textEdgeInsets: UIEdgeInsets
  var textSelectedEdgeInsets: UIEdgeInsets
}

// Item Delegate
protocol ASSliderSegmentItemDelegate: class {
  func onItem(segment: SegmentItem) // To track onClick by item
}

/*
 SegmentItem is a based from Button Control
 the class created for
 - SegmentTitleItem
 - SegmentImageItem
 */
class SegmentItem: UIButton {
  
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?
  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  
  weak var delegate: ASSliderSegmentItemDelegate?
  
  var controlStyle: ASSegmentControlStyle! {
    didSet {
      draw()
    }
  }
  
  private var index: Int!
  private var isSelected: Bool = false {
    didSet {
      isSelected ? drawSelected() : draw()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  init(frame: CGRect, index: Int) {
    super.init(frame: frame)
    self.index = index
  }
  
  // Init control
  func initControl() {
    preconditionFailure("This method must be overridden")
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // Draw all items except selected
  func draw() {
    preconditionFailure("This method must be overridden")
  }
  
  // Draw the selected item
  func drawSelected() {
    preconditionFailure("This method must be overridden")
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    delegate?.onItem(self)
  }
  
  func removeConstraints() {
    if let lc = leadingConstraint {
      self.removeConstraint(lc)
    }
    
    if let tc = topConstraint {
      self.removeConstraint(tc)
    }
    
    if let hc = heightConstraint {
      self.removeConstraint(hc)
    }
    
    if let wc = widthConstraint {
      self.removeConstraint(wc)
    }
  }
  
  /*
  Add contraints to each Item in Control
  */
  func addConstraints() {
    
    heightConstraint = NSLayoutConstraint(
      item: self,                           // to which item we add the constraint
      attribute: NSLayoutAttribute.Height,  // what constraint will be added
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,                          // to which view we connected the item
      attribute: NSLayoutAttribute.NotAnAttribute, // to which side of connected
      multiplier: 1,
      constant: self.frame.size.height)     //  contsant
    
    widthConstraint = NSLayoutConstraint(
      item: self,                           // to which item we add the constraint
      attribute: NSLayoutAttribute.Width,   // what constraint will be added
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,                          // to which view we connected the item
      attribute: NSLayoutAttribute.NotAnAttribute,// to which side of connected
      multiplier: 1,
      constant: self.frame.size.width)     //  contsant
    
    topConstraint = NSLayoutConstraint(
      item: self,                           // to which item we add the constraint
      attribute: NSLayoutAttribute.Top,     // what constraint will be added
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.superview,               // to which view we connected the item
      attribute: NSLayoutAttribute.Top,     // to which side of connected
      multiplier: 1,
      constant: 0)                          //  contsant
    
    leadingConstraint = NSLayoutConstraint(
      item: self,                           // to which item we add the constraint
      attribute: NSLayoutAttribute.Leading, // what constraint will be added
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.superview,               // to which view we connected the item
      attribute: NSLayoutAttribute.Leading, // to which side of connected
      multiplier: 1,
      constant: 0)                          //  contsant
    
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([leadingConstraint!, topConstraint!, heightConstraint!, widthConstraint!])
  }
}

/*
 SegmentTitleItem class based on SegmentItem
 which contain Text as a main attribute
*/
private class SegmentTitleItem: SegmentItem {
  
  private var title: String = ""
  
  init(frame: CGRect, title: String, index: Int) {
    super.init(frame: frame, index: index)
    self.title = title
    initControl()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func initControl() {
    setTitle(title, forState: UIControlState.Normal)
  }
  
  // Draw all items except selected
  override func draw() {
    setTitleColor(controlStyle.textColor, forState: UIControlState.Normal)
    backgroundColor = controlStyle.backgroundColor
    titleLabel?.font = controlStyle.font
    titleEdgeInsets = controlStyle.textEdgeInsets
  }
  
  // Draw the selected item
  override func drawSelected() {
    setTitleColor(controlStyle.selectedTextColor, forState: UIControlState.Normal)
    backgroundColor = controlStyle.selectedBackgroundColor
    titleLabel?.font = controlStyle.selectedFont
    titleEdgeInsets = controlStyle.textSelectedEdgeInsets
  }
}

/*
 SegmentImageItem class based on SegmentItem
 which contain Image as a main attribute
 */
private class SegmentImageItem: SegmentItem {
  
  private var image: UIImage = UIImage()
  private var imageHighlighted: UIImage = UIImage()
  
  init(frame: CGRect, image: UIImage, imageHighlighted: UIImage, index: Int) {
    super.init(frame: frame, index: index)
    self.image = image
    self.imageHighlighted = imageHighlighted
    initControl()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // Init control
  override func initControl() {
    setImage(image, forState: UIControlState.Normal)
  }
  
  // Draw all items except selected
  override func draw() {
    setImage(image, forState: UIControlState.Normal)
    backgroundColor = controlStyle.backgroundColor
    imageEdgeInsets = controlStyle.imageEdgeInsets
    
  }
  
  // Draw the iselected item
  override func drawSelected() {
    setImage(imageHighlighted, forState: UIControlState.Normal)
    backgroundColor = controlStyle.selectedBackgroundColor
    imageEdgeInsets = controlStyle.imageHighlightedEdgeInsets
  }
}

// The delegate of ASSliderSegmentControl
public protocol ASSliderSegmentControlDelegate: class {
  
  // Track onClick on one of the SegmentItem's
  func segmentedControlPressedItemAtIndex (segmentedControl: ASSliderSegmentControl, index: Int)
}

/*
 ASSliderSegmentControl is class which allows developer to create
 the custom segment control dynamically based on amount of items
 which former can configure as he want.
 Moreover line selector can track the scrolling position and move appropriate
*/
public class ASSliderSegmentControl: UIView {
  
  public weak var delegate: ASSliderSegmentControlDelegate?
  private var items: [SegmentItem] = []
  private var selectedIndex: Int = 0
  
  private var separator: CALayer?
  
  public var displaySeparator: Bool = true {
    didSet {
      drawControl()
    }
  }
  
  private var selector: UIView?
  
  public var isSelectorLine: Bool = true {
    didSet {
      drawControl()
    }
  }
  
  private var controlStyle: ASSegmentControlStyle! {
    didSet{
      drawControl()
    }
  }
  
  public init(frame: CGRect, titleItems: [String]) {
    super.init (frame: frame)
    
    initControlItems(titleItems)
    initControl()
  }
  
  public init(frame: CGRect, imageItems: [UIImage], imageItemsHighlighted: [UIImage]) {
    super.init(frame: frame)
    
    initControlItems(imageItems, itemsHighlighted: imageItemsHighlighted)
    initControl()
  }
  
  public override func willMoveToSuperview(newSuperview: UIView?) {
    super.willMoveToSuperview(newSuperview)
    updateControlConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // Init control
  private func initControl() {
    setAppearance()
    selectItemAtIndex(selectedIndex)
  }
  
  // Add item to control
  private func addItem(item: SegmentItem) {
    items.append(item)
  }
  
  // Init control with Text buttons
  private func initControlItems(items: [String]) {
    let itemWidth = frame.size.width / CGFloat(items.count)
    let itemHeight = frame.size.height
    let itemY = frame.origin.y
    var currentX: CGFloat = 0
    
    for index in 0...items.count - 1 {
      let rect = CGRect(x: currentX, y: itemY, width: itemWidth, height: itemHeight)
      let item: SegmentItem = SegmentTitleItem(frame: rect, title: items[index], index: index)
      item.delegate = self
      self.addItem(item)
      currentX += itemWidth
    }
  }
  
  // Init control with Images buttons
  private func initControlItems(items: [UIImage], itemsHighlighted: [UIImage]) {
    let itemWidth = frame.size.width / CGFloat(items.count)
    let itemHeight = frame.size.height
    let itemY = frame.origin.y
    var currentX: CGFloat = 0
    
    for index in 0...items.count - 1 {
      let rect = CGRect(x: currentX, y: itemY, width: itemWidth, height: itemHeight)
      
      let item: SegmentItem = SegmentImageItem(frame: rect, image: items[index], imageHighlighted: itemsHighlighted[index], index: index)
      item.delegate = self
      addItem(item)
      currentX += itemWidth
    }
  }
  
  // Add the bottomLine across the whole control like a separator
  private func addBottomLine() {
    if !displaySeparator {
      return
    }
    
    separator = CALayer ()
    separator!.frame = CGRect(
      x: 0,
      y: frame.size.height - controlStyle.bottomLineHeight,
      width: frame.size.width,
      height: controlStyle.bottomLineHeight)
    separator!.backgroundColor = controlStyle.bottomLineColor.CGColor
    layer.addSublayer(separator!)
  }
  
  // Add selector line - the line which highlighted the selected SegmentItem at the bottom
  private func addSelectorLine() {
    if !isSelectorLine {
      return
    }
    
    let width = frame.size.width / CGFloat(items.count)
    selector = UIView (frame: CGRect (
      x: CGFloat(selectedIndex) * width,
      y: frame.size.height - controlStyle.selectorHeight,
      width: width,
      height: controlStyle.selectorHeight))
    selector!.backgroundColor = controlStyle.selectorColor
    addSubview(selector!)
  }
  
  // Remove all controls from
  private func cleanControl() {
    separator?.removeFromSuperlayer()
    
    for sub in subviews {
      let v = sub
      v.removeFromSuperview()
    }
  }
  
  // Draw all controls
  private func drawControl() {
    cleanControl()
    cleanConstraints()
    
    for item in items {
      item.controlStyle = controlStyle
      addSubview(item)
      item.addConstraints()
    }
    
    addBottomLine()
    addSelectorLine()
  }
  
  // Remove all contraints
  private func cleanConstraints() {
    for item in items {
      item.removeConstraints()
    }
  }
  
  // Updating contraints after putting control on View
  public func updateControlConstraints() {
    let width = frame.size.width / CGFloat(items.count)
    let height = frame.size.height
    
    for item in items {
      item.widthConstraint?.constant = width
      item.heightConstraint?.constant = height
      item.leadingConstraint?.constant = CGFloat(item.index) * width
      item.topConstraint?.constant = frame.origin.y //TODO: - marginTop
    }
  }

  // MARK: Appearance control
  
  // Set default cntrol appearance
  public func setAppearance (
    backgroundColor: UIColor = UIColor.clearColor(),
    selectedBackgroundColor: UIColor = UIColor.clearColor(),
    textColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.3),
    font: UIFont = UIFont(name: "Helvetica", size: 17)!,
    selectedTextColor: UIColor = UIColor.whiteColor(),
    selectedFont: UIFont = UIFont(name: "Helvetica", size: 17)!,
    bottomLineColor: UIColor = UIColor.whiteColor(),
    selectorColor:  UIColor = UIColor.whiteColor(),
    bottomLineHeight: CGFloat = 0.5,
    selectorHeight: CGFloat = 3,
    imageEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(20, 5, 10, 5),
    imageHighlightedEdgeInsets:  UIEdgeInsets = UIEdgeInsetsMake(20, 5, 10, 5),
    textEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0),
    textSelectedEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    ) {
    
    controlStyle = ASSegmentControlStyle(
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      textColor: textColor,
      font: font,
      selectedTextColor: selectedTextColor,
      selectedFont: selectedFont,
      bottomLineColor: bottomLineColor,
      selectorColor: selectorColor,
      bottomLineHeight:bottomLineHeight,
      selectorHeight: selectorHeight,
      imageEdgeInsets: imageEdgeInsets,
      imageHighlightedEdgeInsets:  imageHighlightedEdgeInsets,
      textEdgeInsets: textEdgeInsets,
      textSelectedEdgeInsets: textSelectedEdgeInsets
    )
  }
  
  // Change background appearance in SegmentItem
  public func changeBackgroundControlStyle(backgroundColor: UIColor, selectedBackgroundColor: UIColor) {
    controlStyle.backgroundColor = backgroundColor
    controlStyle.selectedBackgroundColor = selectedBackgroundColor
  }
  
  // Change textColor in SegmentItem label
  public func changeTextColorControlStyle(textColor: UIColor, selectedTextColor: UIColor) {
    controlStyle.textColor = textColor
    controlStyle.selectedTextColor = selectedTextColor
  }
  
  // Change font in SegmentItem label
  public func changeTextFontControlStyle(font: UIFont, seletedFont: UIFont) {
    controlStyle.font = font
    controlStyle.selectedFont = seletedFont
  }
  
  // Change bottomLine appearance
  public func changeBottomLineControlStyle(selectorColor: UIColor, bottomLineHeight: CGFloat) {
    controlStyle.selectorColor = selectorColor
    controlStyle.bottomLineHeight = bottomLineHeight
  }
  
  // Change selectorLine appearance
  public func changeSelectorLineControlStyle(bottomLineColor: UIColor, selectorHeight: CGFloat) {
    controlStyle.bottomLineColor = bottomLineColor
    controlStyle.selectorHeight = selectorHeight
  }
  
  // Change edges for texts in SegmentItem
  public func changeTextEdgesControlStyle(textEdgeInsets: UIEdgeInsets, textSelectedEdgeInsets: UIEdgeInsets) {
    controlStyle.textEdgeInsets = textEdgeInsets
    controlStyle.textSelectedEdgeInsets = textSelectedEdgeInsets
  }
  
  // Change edges for images in SegmentItem
  public func changeImagesEdgesControlStyle(imageEdgeInsets: UIEdgeInsets, imageHighlightedEdgeInsets: UIEdgeInsets) {
    controlStyle.imageEdgeInsets = imageEdgeInsets
    controlStyle.imageHighlightedEdgeInsets = imageHighlightedEdgeInsets
  }
  
  /*
   Makes SegmentItem selected by tracking onItem action
  */
  public func selectItemAtIndex(index: Int) {
    moveSelectorAtIndex(index)
    
    for item in items {
      item.isSelected = false
      if item.index == index {
        selectedIndex = index
        item.isSelected = true
      }
    }
  }

  
  /*
  The control moves selector line to selectedIndex
  by tracking onItem action
  */
  private func moveSelectorAtIndex (index: Int) {
    
    if self.selector == nil {
      return
    }
    
    let item = items[index]
    let itemX = item.frame.origin.x
    let itemWidth = item.frame.size.width
    
    UIView.animateWithDuration(
      0.3,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 0,
      options: [],
      animations: { [unowned self] in
        self.selector!.frame = CGRect(
          x: itemX,
          y: self.selector!.frame.origin.y,
          width: itemWidth,
          height: self.controlStyle.selectorHeight)
      },
      completion: nil)
  }

  /*
   Ability to move segment line following by scroll precisly
   The method calculates the control width and depends on scroll position
   makes an appropriate moving of segment line position.
   */
  public func moveSelectorByScrollPosition (scrollX: CGFloat, index: Int, scrollDirection: HorizontalScrollDirection) {
    
    if self.selector == nil {
      return
    }
    
    let item = items[index]
    let itemWidth = item.frame.size.width
    let currentItemPositionX = itemWidth * CGFloat(index)
    let scrollProportion = scrollX / CGFloat(items.count)
    let scrX = scrollDirection == HorizontalScrollDirection.Forward ? currentItemPositionX + scrollProportion : currentItemPositionX + scrollProportion - itemWidth
    
    self.selector!.frame = CGRect(
      x: scrX,
      y: self.selector!.frame.origin.y,
      width: itemWidth,
      height: self.controlStyle.selectorHeight)
  }
  
  /*
   Define scrolling position and move the selector line appropriate
  */
  public func moveSelectorLine(scrollView: UIScrollView, targetView: UIView) {
    let isScrolling = scrollView.dragging || scrollView.decelerating
    if !isScrolling { return }
    
    let translation = scrollView.panGestureRecognizer.translationInView(targetView)
    let scrollDirection: HorizontalScrollDirection = translation.x > 0 ? .Back : .Forward
    
    if scrollView.contentOffset.x != scrollView.frame.size.width {
      var scrollX = scrollView.contentOffset.x - scrollView.frame.size.width
      
      if scrollDirection == HorizontalScrollDirection.Back {
        scrollX = scrollView.contentOffset.x
      }
      
      moveSelectorByScrollPosition(scrollX, index: selectedIndex, scrollDirection: scrollDirection)
    }
  }
}

extension ASSliderSegmentControl: ASSliderSegmentItemDelegate {
  func onItem(segment: SegmentItem) {
    selectItemAtIndex(segment.index)
    delegate?.segmentedControlPressedItemAtIndex(self, index: segment.index)
  }
}


