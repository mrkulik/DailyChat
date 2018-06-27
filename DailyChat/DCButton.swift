//
//  DCButton.swift
//  DailyChat
//
//  Created by Gleb Kulik on 4/21/18.
//  Copyright © 2018 Gleb Kulik. All rights reserved.
//

import Foundation
import UIKit

class DCButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 25
    }
}
