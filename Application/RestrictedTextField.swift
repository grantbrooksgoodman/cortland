//
//  RestrictedTextField.swift
//  Cortland
//
//  Created by Grant Brooks Goodman on 20/05/2021.
//  Copyright © 2013-2021 NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import UIKit

class RestrictedTextField: UITextField {
    
    //==================================================//
    
    /* MARK: - Overridden Functions */
    
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return position(from: beginningOfDocument, offset: self.text?.count ?? 0)
    }
}
