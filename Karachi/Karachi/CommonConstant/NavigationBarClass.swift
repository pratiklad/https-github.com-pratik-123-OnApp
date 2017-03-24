//
//  NavigationBarClass.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

class NavigationBarClass: UIView {

  
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = getNavigationBarColor()

        // fatalError("init(coder:) has not been implemented")
    }
}
