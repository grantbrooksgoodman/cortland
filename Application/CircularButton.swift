//
//  CircularButton.swift
//  Cortland
//
//  Created by Grant Brooks Goodman on 20/05/2021.
//  Copyright © 2013-2021 NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import UIKit

class CircularButton: UIButton {
    
    //==================================================//
    
    /* MARK: Overridden Functions */
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
    }
}
