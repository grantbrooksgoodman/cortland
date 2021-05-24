//
//  CLTimer.swift
//  Cortland
//
//  Created by Grant Brooks Goodman on 20/05/2021.
//  Copyright © 2013-2021 NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import UIKit

class CLTimer {
    
    //==================================================//
    
    /* MARK: - Class-level Variable Declarations */
    
    var title: String!
    var alarmDate: Date! {
        didSet {
            alarmDate = alarmDate.startOfMinute
        }
    }
    
    //==================================================//
    
    /* MARK: - Initializer Function */
    
    @discardableResult required init(title: String, alarmDate: Date) {
        self.title = title
        self.alarmDate = alarmDate.startOfMinute
    }
}
