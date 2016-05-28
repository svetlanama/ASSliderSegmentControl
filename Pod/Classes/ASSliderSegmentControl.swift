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

public enum HorizontalScrollDirection: Int {
  case Forward = 0
  case Back = 1
}

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

protocol ASSliderSegmentItemDelegate: class {
  func onItem(segment: SegmentItem)
}

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
  
  func initControl() {
    preconditionFailure("This method must be overridden")
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func draw() {
    preconditionFailure("This method must be overridden")
  }
  
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
  
  func addConstraints() {
    
    heightConstraint = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Height,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,
      attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1,
      constant: self.frame.size.height)
    
    widthConstraint = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Width,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,
      attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1,
      constant: self.frame.size.width)
    
    topConstraint = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Top,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.superview,
      attribute: NSLayoutAttribute.Top,
      multiplier: 1,
      constant: 0)
    
    leadingConstraint = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Leading,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.superview,
      attribute: NSLayoutAttribute.Leading,
      multiplier: 1,
      constant: 0)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([leadingConstraint!, topConstraint!, heightConstraint!, widthConstraint!])
  }
}

private class SeshSegmentTitleItem: SegmentItem {
  
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
  
  override func draw() {
    setTitleColor(controlStyle.textColor, forState: UIControlState.Normal)
    backgroundColor = controlStyle.backgroundColor
    titleLabel?.font = controlStyle.font
    titleEdgeInsets = controlStyle.textEdgeInsets
  }
  
  override func drawSelected() {
    setTitleColor(controlStyle.selectedTextColor, forState: UIControlState.Normal)
    backgroundColor = controlStyle.selectedBackgroundColor
    titleLabel?.font = controlStyle.selectedFont
    titleEdgeInsets = controlStyle.textSelectedEdgeInsets
  }
}

private class SeshSegmentImageItem: SegmentItem {
  
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
  
  override func initControl() {
    setImage(image, forState: UIControlState.Normal)
  }
  
  override func draw() {
    setImage(image, forState: UIControlState.Normal)
    backgroundColor = controlStyle.backgroundColor
    imageEdgeInsets = controlStyle.imageEdgeInsets
    
  }
  
  override func drawSelected() {
    setImage(imageHighlighted, forState: UIControlState.Normal)
    backgroundColor = controlStyle.selectedBackgroundColor
    imageEdgeInsets = controlStyle.imageHighlightedEdgeInsets
  }
}

public protocol ASSliderSegmentControlDelegate: class {
  func segmentedControlPressedItemAtIndex (segmentedControl: ASSliderSegmentControl, index: Int)
}

public class ASSliderSegmentControl: UIView {
  
  public weak var delegate: ASSliderSegmentControlDelegate?
  private var items: [SegmentItem] = []
  private var selectedIndex: Int = 0
  
  private var bottomLine: CALayer?
  
  public var displayBottomLine: Bool = true {
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
  
  private func initControl() {
    setAppearance()
    selectItemAtIndex(selectedIndex)
  }
  
  private func addItem(item: SegmentItem) {
    items.append(item)
  }
  
  private func initControlItems(items: [String]) {
    let itemWidth = frame.size.width / CGFloat(items.count)
    let itemHeight = frame.size.height
    let itemY = frame.origin.y
    var currentX: CGFloat = 0
    
    for index in 0...items.count - 1 {
      let rect = CGRect(x: currentX, y: itemY, width: itemWidth, height: itemHeight)
      let item: SegmentItem = SeshSegmentTitleItem(frame: rect, title: items[index], index: index)
      item.delegate = self
      self.addItem(item)
      currentX += itemWidth
    }
  }
  
  private func initControlItems(items: [UIImage], itemsHighlighted: [UIImage]) {
    let itemWidth = frame.size.width / CGFloat(items.count)
    let itemHeight = frame.size.height
    let itemY = frame.origin.y
    var currentX: CGFloat = 0
    
    for index in 0...items.count - 1 {
      let rect = CGRect(x: currentX, y: itemY, width: itemWidth, height: itemHeight)
      
      let item: SegmentItem = SeshSegmentImageItem(frame: rect, image: items[index], imageHighlighted: itemsHighlighted[index], index: index)
      item.delegate = self
      addItem(item)
      currentX += itemWidth
    }
  }
  
  private func addBottomLine() {
    if !displayBottomLine {
      return
    }
    
    bottomLine = CALayer ()
    bottomLine!.frame = CGRect(
      x: 0,
      y: frame.size.height - controlStyle.bottomLineHeight,
      width: frame.size.width,
      height: controlStyle.bottomLineHeight)
    bottomLine!.backgroundColor = controlStyle.bottomLineColor.CGColor
    layer.addSublayer(bottomLine!)
  }
  
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
  
  private func cleanControl() {
    bottomLine?.removeFromSuperlayer()
    
    for sub in subviews {
      let v = sub
      v.removeFromSuperview()
    }
  }
  
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
  
  private func cleanConstraints() {
    for item in items {
      item.removeConstraints()
    }
  }
  
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
  
  public func changeBackgroundControlStyle(backgroundColor: UIColor, selectedBackgroundColor: UIColor) {
    controlStyle.backgroundColor = backgroundColor
    controlStyle.selectedBackgroundColor = selectedBackgroundColor
  }
  
  public func changeTextColorControlStyle(textColor: UIColor, selectedTextColor: UIColor) {
    controlStyle.textColor = textColor
    controlStyle.selectedTextColor = selectedTextColor
  }
  
  public func changeTextFontControlStyle(font: UIFont, seletedFont: UIFont) {
    controlStyle.font = font
    controlStyle.selectedFont = seletedFont
  }
  
  public func changeBottomLineControlStyle(selectorColor: UIColor, bottomLineHeight: CGFloat) {
    controlStyle.selectorColor = selectorColor
    controlStyle.bottomLineHeight = bottomLineHeight
  }
  
  public func changeSelectorLineControlStyle(bottomLineColor: UIColor, selectorHeight: CGFloat) {
    controlStyle.bottomLineColor = bottomLineColor
    controlStyle.selectorHeight = selectorHeight
  }
  
  public func changeTextEdgesControlStyle(textEdgeInsets: UIEdgeInsets, textSelectedEdgeInsets: UIEdgeInsets) {
    controlStyle.textEdgeInsets = textEdgeInsets
    controlStyle.textSelectedEdgeInsets = textSelectedEdgeInsets
  }
  
  public func changeImagesEdgesControlStyle(imageEdgeInsets: UIEdgeInsets, imageHighlightedEdgeInsets: UIEdgeInsets) {
    controlStyle.imageEdgeInsets = imageEdgeInsets
    controlStyle.imageHighlightedEdgeInsets = imageHighlightedEdgeInsets
  }
  
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
  
  // Move selector line while scrolling
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
  
  // Move selector line to selected Index
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


/*
import Foundation
import UIKit


public enum HorizontalScrollDirection: Int {
  case Forward = 0
  case Back = 1
 
}

struct ASSegmentControlStyle {
  var backgroundColor: UIColor = UIColor.clearColor()
  var selectedBackgroundColor: UIColor = UIColor.clearColor()
  var textColor: UIColor = UIColor.whiteColor()
  var font: UIFont = UIFont(name: "Helvetica", size: 17)!
  var selectedTextColor: UIColor = UIColor.whiteColor()
  var selectedFont: UIFont = UIFont(name: "Helvetica", size: 17)!
  var bottomLineColor: UIColor = UIColor.whiteColor()
  var selectorColor: UIColor = UIColor.whiteColor()
  var bottomLineHeight: CGFloat = 0.5
  var selectorHeight: CGFloat = 3
  var imageEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
  var imageHighlightedEdgeInsets: UIEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
  var textEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
  var textSelectedEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
}


protocol SegmentItemDelegate: class {
  func itemClick(segment: SegmentItem)
}

class SegmentItem: UIButton {
 
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?
  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?

  weak var delegate: SegmentItemDelegate?
 
  var controlStyle: ASSegmentControlStyle! {
    didSet {
      draw()
    }
  }
  private var index: Int!
 
  private var isSelected: Bool = false {
    didSet {
      if isSelected {
        drawSelected()
      } else {
        draw()
      }
    }
  }
 
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
 
  init(frame: CGRect, index: Int) {
    super.init(frame: frame)
    self.index = index
  }
 
  func initControl() {
  }
 
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
 
  func draw(){
  }
 
  func drawSelected(){
  }
  
  // MARK: Events
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    delegate?.itemClick(self)
  }
  
  // MARK: constraints
  func removeConstraints() {
    if leadingConstraint != nil {
      self.removeConstraint(leadingConstraint!)
    }
    if topConstraint != nil {
      self.removeConstraint(topConstraint!)
    }
    if heightConstraint != nil {
      self.removeConstraint(heightConstraint!)
    }
    if widthConstraint != nil {
      self.removeConstraint(widthConstraint!)
    }
  }
  
  func addConstraints() {
    heightConstraint = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Height,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,
      attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1,
      constant: self.frame.size.height)
    
    widthConstraint = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Width,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,
      attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1,
      constant: self.frame.size.width)
    
    topConstraint = NSLayoutConstraint(
      item: self,                       // to which item we add the constraint
      attribute: NSLayoutAttribute.Top, // which part of item we connecting
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.superview,           // to which object related
      attribute: NSLayoutAttribute.Top, // the part of related object from which the gap will be
      multiplier: 1,
      constant: 0)
    
    leadingConstraint = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Leading,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.superview,
      attribute: NSLayoutAttribute.Leading,
      multiplier: 1,
      constant: 0)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([leadingConstraint!, topConstraint!, heightConstraint!, widthConstraint!])
    
  }

}

private class ASSegmentTitleItem: SegmentItem {
  
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
  
  override func draw(){
    setTitleColor(controlStyle.textColor, forState:  UIControlState.Normal)
    backgroundColor = controlStyle.backgroundColor
    titleLabel?.font = controlStyle.font
    titleEdgeInsets = controlStyle.textEdgeInsets
  }
  
  override func drawSelected(){
    setTitleColor(controlStyle.selectedTextColor, forState:  UIControlState.Normal)
    backgroundColor = controlStyle.selectedBackgroundColor
    titleLabel?.font = controlStyle.selectedFont
    titleEdgeInsets = controlStyle.textSelectedEdgeInsets
    
  }
}

class ASSegmentImageItem: SegmentItem {
  
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
  
  override func initControl() {
    setImage(image, forState: UIControlState.Normal)
  }
  
  override func draw(){
    setImage(image, forState: UIControlState.Normal)
    backgroundColor = controlStyle.backgroundColor
    imageEdgeInsets = controlStyle.imageEdgeInsets
    
  }
  
  override func drawSelected(){
    setImage(imageHighlighted, forState: UIControlState.Normal)
    backgroundColor = controlStyle.selectedBackgroundColor
    imageEdgeInsets = controlStyle.imageHighlightedEdgeInsets
  }
  
}

public protocol ASSliderSegmentControlDelegate: class {
  func segmentedControlPressedItemAtIndex (segmentedControl: ASSliderSegmentControl, index: Int)
}

public class ASSliderSegmentControl: UIView {

  public weak var delegate: ASSliderSegmentControlDelegate?
  private var items: [SegmentItem] = []
  private var selectedIndex: Int = 0
  
  private var bottomLine: CALayer?
  public var isButtomLine: Bool = true {
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
  
  public init (frame: CGRect, titleItems: [String]) {
    super.init (frame: frame)
    
    initControlItems(titleItems)
    initControl()
  }
  
  public init (frame: CGRect, imageItems: [UIImage], imageItemsHighlighted: [UIImage]) {
    super.init (frame: frame)
    
    initControlItems(imageItems, itemsHighlighted: imageItemsHighlighted)
    initControl()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  //MARK: Initialize control
  private func initControl() {
    initDefaultControlStyle()
    selectItemAtIndex(selectedIndex)
  }

  private func addItem(item: SegmentItem) {
    items.append(item)
  }
  
  private func initControlItems(items: [String]) {
    let itemWidth = frame.size.width / CGFloat(items.count)
    let itemHeight = frame.size.height
    let itemY = frame.origin.y
    var currentX: CGFloat = 0
    
    for index in 0...items.count - 1 {
      let rect = CGRect(x: currentX, y: itemY, width: itemWidth, height: itemHeight)
      let i: SegmentItem = ASSegmentTitleItem(frame: rect, title: items[index], index: index)
      i.delegate = self
      self.addItem(i)
      currentX += itemWidth
    }
  }
  
  private func initControlItems(items: [UIImage], itemsHighlighted: [UIImage]) {
    let itemWidth = frame.size.width / CGFloat(items.count)
    let itemHeight = frame.size.height
    let itemY = frame.origin.y
    var currentX: CGFloat = 0
    
    for index in 0...items.count - 1 {
      let rect = CGRect(x: currentX, y: itemY, width: itemWidth, height: itemHeight)
      
      let i: SegmentItem = ASSegmentImageItem(frame: rect, image: items[index], imageHighlighted: itemsHighlighted[index], index: index)
      i.delegate = self
      addItem(i)
      currentX += itemWidth
    }
  }
  
  private func addButtomLine() {
    if !isButtomLine {
      return
    }
    
    bottomLine = CALayer ()
    bottomLine!.frame = CGRect(
      x: 0,
      y: frame.size.height - controlStyle.bottomLineHeight,
      width: frame.size.width,
      height: controlStyle.bottomLineHeight)
    bottomLine!.backgroundColor = controlStyle.bottomLineColor.CGColor
    layer.addSublayer(bottomLine!)
  }
  
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
  
  //MARK: Draw control
  private func cleanControl() {
    bottomLine?.removeFromSuperlayer()
    
    for sub in subviews {
      let v = sub
      v.removeFromSuperview()
    }
  }

  private func drawControl() {
    
    cleanControl()
    cleanConstraints()
    for item in items {
      item.controlStyle = controlStyle
      addSubview(item)
      item.addConstraints()
    }
    
    addButtomLine()
    addSelectorLine()
  }
  
  // MARK: contraints
  private func cleanConstraints() {
    for item in items {
      item.removeConstraints()
    }
  }

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
  
  //MARK: Appearance control
  private func initDefaultControlStyle () {
    controlStyle = ASSegmentControlStyle()
  }
  
  public func changeControlStyle (
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
  
  public func changeBackgroundControlStyle(backgroundColor: UIColor, selectedBackgroundColor: UIColor)
  {
    controlStyle.backgroundColor = backgroundColor
    controlStyle.selectedBackgroundColor = selectedBackgroundColor
  }
  
  public func changeTextColorControlStyle(textColor: UIColor, selectedTextColor: UIColor)
  {
    controlStyle.textColor = textColor
    controlStyle.selectedTextColor = selectedTextColor
  }
  
  public func changeTextFontControlStyle(font: UIFont, seletedFont: UIFont)
  {
    controlStyle.font = font
    controlStyle.selectedFont = seletedFont
  }
  
  public func changeBottomLineControlStyle(selectorColor: UIColor, bottomLineHeight: CGFloat)
  {
    controlStyle.selectorColor = selectorColor
    controlStyle.bottomLineHeight = bottomLineHeight
  }
  
  public func changeSelectorLineControlStyle(bottomLineColor: UIColor, selectorHeight: CGFloat)
  {
    controlStyle.bottomLineColor = bottomLineColor
    controlStyle.selectorHeight = selectorHeight
  }
  
  public func changeTextEdgesControlStyle(textEdgeInsets: UIEdgeInsets, textSelectedEdgeInsets: UIEdgeInsets)
  {
    controlStyle.textEdgeInsets = textEdgeInsets
    controlStyle.textSelectedEdgeInsets = textSelectedEdgeInsets
  }
  
  public func changeImagesEdgesControlStyle(imageEdgeInsets: UIEdgeInsets, imageHighlightedEdgeInsets: UIEdgeInsets)
  {
    controlStyle.imageEdgeInsets = imageEdgeInsets
    controlStyle.imageHighlightedEdgeInsets = imageHighlightedEdgeInsets
  }
  
  //MARK: Actions
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
  
  // Move selector while scrolling
  public func moveSelectorByScrollPosition (scrollX: CGFloat, index: Int, scrollDirection: HorizontalScrollDirection) {
    
    if self.selector == nil {
      return
    }
    
    let item = items[index]
    let itemWidth = item.frame.size.width
    let currentItemPositionX = itemWidth * CGFloat(index)
    let scrollProportion = scrollX / CGFloat(items.count)
    let scrX = scrollDirection == HorizontalScrollDirection.Forward ? currentItemPositionX + scrollProportion :  currentItemPositionX + scrollProportion - itemWidth
    
    self.selector!.frame = CGRect(
      x: scrX,
      y: self.selector!.frame.origin.y,
      width: itemWidth,
      height: self.controlStyle.selectorHeight)
    
  }
  
  // Move selector to selected Index
  private func moveSelectorAtIndex (index: Int) {
    
    if self.selector == nil {
      return
    }
    
    let item = items[index]
    let itemX = item.frame.origin.x
    let itemWidth = item.frame.size.width
    
    
    UIView.animateWithDuration(0.3,
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
}


extension ASSliderSegmentControl: SegmentItemDelegate {
  func itemClick(segment: SegmentItem) {
    selectItemAtIndex(segment.index)
    delegate?.segmentedControlPressedItemAtIndex(self, index: segment.index)
  }
}*/
