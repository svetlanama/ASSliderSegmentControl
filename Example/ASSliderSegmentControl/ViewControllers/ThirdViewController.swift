//
//  ThirdViewController.swift
//  ASPageControllerSample
//
//  Created by Svitlana Moiseyenko on 3/18/16.
//  Copyright © 2016 Svitlana Moiseyenko. All rights reserved.
//

import Foundation
import UIKit

class ThirdViewController: UIViewController {

  @IBOutlet weak var contentView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentView.backgroundColor = UIColor(named: UIColor.AppColor.BermudaGray)
    view.backgroundColor = UIColor(named: UIColor.AppColor.BisonHide)
  }
}

