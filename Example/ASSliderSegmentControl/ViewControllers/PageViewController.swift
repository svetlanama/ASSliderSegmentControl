//
//  PageViewController.swift
//  Cape
//
//  Created by Svitlana Moiseyenko on 3/18/16.
//  Copyright © 2016 Svitlana Moiseyenko. All rights reserved.
//

import Foundation
import UIKit

protocol PageViewControllerDelegate: class {
  func pageViewController(pageViewController: PageViewController, didUpdatePageCount count: Int)
  func pageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int)
  func pageViewController(pageViewController: PageViewController, didUpdateScroll scrollView: UIScrollView)
}

class PageViewController: UIPageViewController {
  
  weak var pageViewControllerDelegate: PageViewControllerDelegate?
  
  private(set) lazy var itemViewControllers: [UIViewController] = {
    return [
      self.loadItemViewController("first_vc"),
      self.loadItemViewController("second_vc"),
      self.loadItemViewController("third_vc")]
  }()
  
  internal lazy var scrollView: UIScrollView? = {
    var scrollView: UIScrollView?
    
    for subview in self.view.subviews {
      if subview.isKindOfClass(UIScrollView) {
        scrollView = subview as? UIScrollView
        break
      }
    }
    
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    delegate = self
    scrollView?.delegate = self
    
    if let initialViewController = itemViewControllers.first {
      scrollToViewController(initialViewController)
    }
  }
  
  func scrollToNextViewController() {
    if let visibleViewController = viewControllers?.first,
      let nextViewController = pageViewController(self,
        viewControllerAfterViewController: visibleViewController) {
          scrollToViewController(nextViewController)
    }
  }
  
  func scrollToViewController(index newIndex: Int) {
    if let firstViewController = viewControllers?.first,
      let currentIndex = itemViewControllers.indexOf(firstViewController) {
        let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
        let nextViewController = itemViewControllers[newIndex]
        scrollToViewController(nextViewController, direction: direction)
    }
  }
  
  private func loadItemViewController(viewId: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil) .
      instantiateViewControllerWithIdentifier(viewId)
  }
  
  private func scrollToViewController(viewController: UIViewController,
    direction: UIPageViewControllerNavigationDirection = .Forward) {
      setViewControllers([viewController],
        direction: direction,
        animated: true,
        completion: { (finished) -> Void in
          self.notifyTutorialDelegateOfNewIndex()
      })
  }
  
  private func notifyTutorialDelegateOfNewIndex() {
    if let firstViewController = viewControllers?.first,
      let index = itemViewControllers.indexOf(firstViewController) {
        pageViewControllerDelegate?.pageViewController(self, didUpdatePageIndex: index)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension  PageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(pageViewController: UIPageViewController,
    viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
      guard let viewControllerIndex = itemViewControllers.indexOf(viewController) else {
        return nil
      }
      
      let previousIndex = viewControllerIndex - 1
      guard previousIndex >= 0 else {
        return nil
      }
      
      guard itemViewControllers.count > previousIndex else {
        return nil
      }
      
      return itemViewControllers[previousIndex]
  }
  
  func pageViewController(pageViewController: UIPageViewController,
    viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
      guard let viewControllerIndex = itemViewControllers.indexOf(viewController) else {
        return nil
      }
      
      let nextIndex = viewControllerIndex + 1
      let orderedViewControllersCount = itemViewControllers.count
      
      guard orderedViewControllersCount != nextIndex else {
        return nil
      }
      
      guard orderedViewControllersCount > nextIndex else {
        return nil
      }
      
      return itemViewControllers[nextIndex]
  }

}

extension PageViewController: UIPageViewControllerDelegate {
  
  func pageViewController(pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool) {
      notifyTutorialDelegateOfNewIndex()
  }
}

extension PageViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    pageViewControllerDelegate?.pageViewController(self, didUpdateScroll: scrollView)
  }
}





