//
//  UIColor+PC.swift
//  ASPageControllerSample
//
//  Created by Svitlana Moiseyenko on 3/19/16.
//  Copyright © 2016 Svitlana Moiseyenko. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  
  
  enum AppColor : Int {
    case CharcoalGrey = 0x333438
    case Beige        = 0xf5f3e6
    case GreyishBrown = 0x4c4c4c
    case BoringGreen  = 0x65b77b
    case EvilRed      = 0xe9301b
    case StormDust    = 0x6d6d6c
    case Tuna         = 0x3a3b3e
    case DustyGray    = 0x717173
    case ScarpaFlow   = 0x575759
    
    case RegentStBlueApprox = 0x9fbfe6
    case ConiferApprox = 0xb1e45f
    case VividTangerineApprox = 0xff927d

  }
  
  convenience init(rgbValue: Int) {
    let red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
    let blue  = CGFloat(rgbValue & 0xFF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
  
  convenience init(named name: AppColor) {
    self.init(rgbValue: name.rawValue)
  }

  
}