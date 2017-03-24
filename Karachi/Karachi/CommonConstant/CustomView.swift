//
//  CustomView.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable
    public var cornerRadious : CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadious
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
