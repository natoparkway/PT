//
//  CircleWithTextView.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/11/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import QuartzCore
let lineWidth = CGFloat(5.0)

class CircleWithTextView: UIView {
    
    var color: UIColor!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet var circularView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
        counterLabel.text = "-1" //Default text
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
        counterLabel.text = "-1" //Default text
    }
    
    func setup() {
        if let bgColor = backgroundColor {
            color = backgroundColor
        } else {
            color = UIColor(red: 255/255, green: 94/255, blue: 69/255, alpha: 1.0)    //Default color when programatically instantiated
        }
        
        addNib()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    func addNib() {
        var nib = UINib(nibName: "CircularView", bundle: nil)
        var objects = nib.instantiateWithOwner(self, options: nil)
        circularView.frame = self.bounds
        circularView.layer.borderWidth = circularView.frame.width / 8
        circularView.layer.borderColor = color.CGColor
        circularView.layer.cornerRadius = circularView.frame.width / 2
        addSubview(circularView)
        
    }
    
    func setFont(font: UIFont) {
        counterLabel.font = font
    }
    
    func updateColor(color: UIColor) {
        self.color = color
    }
    
    //Public method to change counterLabel
    func updateCounter(count: String) {
        counterLabel.text = count
        
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        var context = UIGraphicsGetCurrentContext()
//        CGContextSetLineWidth(context, lineWidth)
//        
//        //Sets the color of the circle-outline to be the color of the view in storyboard.
//        color.set()
//        
//        CGContextAddArc(context, frame.size.width / 2, frame.size.height / 2, (frame.size.width - 2 * lineWidth) / 2, 0.0, CGFloat(M_PI * 2.0), 1)
//        
//        //Draw
//        CGContextStrokePath(context)
//    }

}
