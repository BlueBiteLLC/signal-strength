//
//  SignalStrengthView.swift
//  Decode
//
//  Created by Tanner Nelson on 7/17/15.
//  Copyright (c) 2015 Blue Bite. All rights reserved.
//

import UIKit

@IBDesignable
open class SignalStrengthView: UIView {
    
    //MARK: Interace
    var dot1: SignalStrengthDotView!
    var dot2: SignalStrengthDotView!
    var dot3: SignalStrengthDotView!
    var dot4: SignalStrengthDotView!
    var dot5: SignalStrengthDotView!
    
    //MARK: Properties
    open var color = UIColor.black {
        didSet {
            self.update()
        }
    }
    
    open var signal: SignalStrength = .unknown {
        didSet {
            self.update()
        }
    }
    open var flipped: Bool = true
    
    //MARK: Enumerations
    public enum SignalStrength {
        case excellent
        case veryGood
        case good
        case low
        case veryLow
        case noSignal
        case unknown
    }
    
    //MARK: Lifecycle
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeDots()
        self.update()
    }
    
    //MARK: Initialize
    func initializeDots() {
        self.dot1 = SignalStrengthDotView.addAfter(self, inView: self)
        self.dot2 = SignalStrengthDotView.addAfter(self.dot1, inView: self)
        self.dot3 = SignalStrengthDotView.addAfter(self.dot2, inView: self)
        self.dot4 = SignalStrengthDotView.addAfter(self.dot3, inView: self)
        self.dot5 = SignalStrengthDotView.addAfter(self.dot4, inView: self, lastView: self)
    }
    
    //MARK: Functions
    func update() {
        if dot1 == nil {
            //attempt to update before initialization
            return
        }
        
        dot1.color = self.color
        dot2.color = self.color
        dot3.color = self.color
        dot4.color = self.color
        dot5.color = self.color
        
        dot1.on = true
        dot2.on = true
        dot3.on = true
        dot4.on = true
        dot5.on = true
        
        switch self.signal {
        case .excellent:
            break
        case .veryGood:
            if self.flipped {
                dot1.on = false
            } else {
                dot5.on = false
            }
        case .good:
            if self.flipped {
                dot1.on = false
                dot2.on = false
            } else {
                dot5.on = false
                dot4.on = false
            }
        case .low:
            if self.flipped {
                dot1.on = false
                dot2.on = false
            } else {
                dot5.on = false
                dot4.on = false
            }
            dot3.on = false
        case .veryLow:
            
            if self.flipped {
                dot1.on = false
            } else {
                dot5.on = false
            }
            dot4.on = false
            dot3.on = false
            dot2.on = false
            
        case .noSignal, .unknown:
            dot5.on = false
            dot4.on = false
            dot3.on = false
            dot2.on = false
            dot1.on = false
        }
    }
    
    //MARK: Designable
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.awakeFromNib()
    }
    
}


class SignalStrengthDotView: UIView {
    
    //MARK: Properties
    static let size: CGFloat = 6
    static let spacing: CGFloat = 2
    var on: Bool = true {
        didSet {
            self.update()
        }
    }
    
    var color = UIColor.black {
        didSet {
            self.update()
        }
    }
    
    //MARK: Class
    class func addAfter(_ leadingView: UIView, inView: UIView) -> SignalStrengthDotView {
        return self.addAfter(leadingView, inView: inView, lastView: nil)
    }
    
    class func addAfter(_ leadingView: UIView, inView superview: UIView, lastView: UIView?) -> SignalStrengthDotView {
        let dot = SignalStrengthDotView()
        
        
        dot.layer.borderColor = UIColor.black.cgColor
        dot.layer.borderWidth = 0.5
        
        dot.on = false
        dot.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addSubview(dot)
        
        dot.layer.cornerRadius = size / 2
        
        dot.addConstraint(
            NSLayoutConstraint(item: dot, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: size)
        )
        dot.addConstraint(
            NSLayoutConstraint(item: dot, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: size)
        )
        
        superview.addConstraint(
            NSLayoutConstraint(item: superview, attribute: .top, relatedBy: .equal, toItem: dot, attribute: .top, multiplier: 1, constant: 0)
        )
        superview.addConstraint(
            NSLayoutConstraint(item: superview, attribute: .bottom, relatedBy: .equal, toItem: dot, attribute: .bottom, multiplier: 1, constant: 0)
        )
        
        if leadingView == superview {
            superview.addConstraint(
                NSLayoutConstraint(item: dot, attribute: .left, relatedBy: .equal, toItem: leadingView, attribute: .left, multiplier: 1, constant: 0)
            )
        } else {
            superview.addConstraint(
                NSLayoutConstraint(item: dot, attribute: .left, relatedBy: .equal, toItem: leadingView, attribute: .right, multiplier: 1, constant: spacing)
            )
        }
        
        if let lastView = lastView {
            superview.addConstraint(
                NSLayoutConstraint(item: lastView, attribute: .right, relatedBy: .equal, toItem: dot, attribute: .right, multiplier: 1, constant: 0)
            )
        }
        
        return dot
    }
    
    //MARK: Functions
    func update() {
        self.layer.borderColor = self.color.cgColor
        
        if self.on {
            self.backgroundColor = self.color
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
}
