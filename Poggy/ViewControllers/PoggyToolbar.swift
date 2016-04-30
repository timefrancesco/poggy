//
//  PoggyToolbar.swift
//  Poggy
//
//  Created by Francesco Pretelli on 30/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import UIKit

protocol PoggyToolbarDelegate{
    func onPoggyToolbarButtonTouchUpInside()
}

class PoggyToolbar:UIToolbar{
    
    var mainButton:UIButton =  UIButton(type: UIButtonType.Custom)
    var poggyDelegate:PoggyToolbarDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        barStyle = UIBarStyle.BlackOpaque
        backgroundColor = UIColor.clearColor()// PoggyConstants.POGGY_BLUE
        
        mainButton.backgroundColor = PoggyConstants.POGGY_BLUE
        //mainButton.titleLabel?.font = YNCSS.sharedInstance.getFont(21, style: YNCSS.FontStyle.REGULAR)
        mainButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        mainButton.frame = CGRect(x: 0,y: 0,width: frame.width, height: frame.height)
        mainButton.addTarget(self, action: #selector(self.onButtonTouchUpInside(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(mainButton)
    }
    
    func setButtonTitle(title:String){
        mainButton.setTitle(title,forState: UIControlState.Normal)
    }
    
    func onButtonTouchUpInside(sender: UIButton!) {
        poggyDelegate?.onPoggyToolbarButtonTouchUpInside()
    }
}