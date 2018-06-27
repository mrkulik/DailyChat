//
//  DCTextField.swift
//  DailyChat
//
//  Created by Mikhail Lyapich on 11/9/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit

class DCTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
        //layer.borderColor = Const.Colors.cyan.cgColor
        //layer.borderWidth = 1
    }
}
