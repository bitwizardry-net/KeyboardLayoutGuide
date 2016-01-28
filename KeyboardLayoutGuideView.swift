//
//  KeyboardLayoutGuideView.swift
//  test
//
//  Created by Thomas Sempf on 2015-06-12.
//  Copyright © 2015 BitWizardry. All rights reserved.
//

import Foundation
import UIKit

class KeyboardLayoutGuideView: UIView {
    private weak var bottomLayoutGuideConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Do any additional setup after loading the view, typically from a nib.
        setupObservers()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false

        setupObservers()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func updateConstraints() {
        defer { super.updateConstraints() }
        
        guard let superview = self.superview else { return }

        if constraints.count == 0 {
            setupLeftRightLayoutConstraintsWithSuperview(superview)
        }
        
        if bottomLayoutGuideConstraint == nil {
            setupBottomLayoutConstraintWithSuperview(superview)
        }
    }
}

private extension KeyboardLayoutGuideView {
    func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "showKeyboardNotification:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "hideKeyboardNotification:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func setupLeftRightLayoutConstraintsWithSuperview(superview: UIView) {
        superview.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
        superview.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
        heightAnchor.constraintEqualToConstant(0).active = true
    }
    
    func setupBottomLayoutConstraintWithSuperview(superview: UIView) {
        if let existingBottomLayoutConstraint = findExistingBottomLayoutConstraintWithSuperview(superview) {
            superview.removeConstraint(existingBottomLayoutConstraint)
        }

        bottomLayoutGuideConstraint = superview.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0)
        bottomLayoutGuideConstraint?.active = true
    }
    
    func findExistingBottomLayoutConstraintWithSuperview(superview: UIView) -> NSLayoutConstraint? {
        return superview.constraints.filter({ constraint -> Bool in
            if constraint.firstAttribute == .Bottom && constraint.secondAttribute == .Bottom &&
                (constraint.firstItem === self || constraint.secondItem === self)
            {
                return true
            }
            
            return false
        }).first
    }
    
    dynamic func showKeyboardNotification(notification: NSNotification) {
        guard let
            userInfo = notification.userInfo,
            endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            else { return }
        
        self.superview?.setNeedsLayout()
        
        self.bottomLayoutGuideConstraint?.constant = endFrame.height
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.superview?.layoutIfNeeded()
        }
    }
    
    dynamic func hideKeyboardNotification(notification: NSNotification) {
        self.bottomLayoutGuideConstraint?.constant = 0
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.superview?.layoutIfNeeded()
        }
    }
}
