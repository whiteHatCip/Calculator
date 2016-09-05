//
//  RoundedButton.swift
//  StanfordCalculator
//
//  Created by Fabio Cipriani on 04/09/16.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import UIKit

protocol RoundedCorners {}
extension RoundedCorners where Self: UIButton {

    func roundCornersAndDropShadow(){
        layer.cornerRadius = 3.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
}
