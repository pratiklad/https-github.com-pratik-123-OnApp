//
//  CutomLable.swift
//  Karachi
//
//  Created by Bunty on 23/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

@IBDesignable
class CutomLable: UILabel {
    
    @IBInspectable
    public var cornerRadious : CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadious
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable
    public var borderColor : UIColor? {
        didSet{
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth : CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
}
