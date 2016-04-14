//
//  UIViewControllerExtension.swift
//  travel
//
//  Created by citiadmin on 3/13/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation
import UIKit

var activityHolderView: UIView!
var activityStatus = UILabel()
var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

var isActivityViewDisplayed = false
let accessiblityIdentifier = "ACTIVITYINDICATION"


extension UIViewController {
    /**
     Displays an Activity Indicator to show loading
     */
    func showActivityView() {
        
        if  isActivityViewDisplayed == false {
            let appDelegate = UIApplication.sharedApplication().delegate
            isActivityViewDisplayed = true
            activityHolderView = UIView(frame: CGRectMake(0, 0, 80, 80))
            activityHolderView.backgroundColor = UIColor.redColor()
            activityHolderView?.center = self.view.center
            activityHolderView.backgroundColor = UIColor.blackColor()
            activityHolderView.alpha = 0.4
            activityHolderView.layer.cornerRadius = 5.0
 
            let basePoint = appDelegate?.window??.convertPoint(activityHolderView.frame.origin, fromCoordinateSpace: UIWindow())
            
            activityHolderView.frame.origin = basePoint!
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicator.hidesWhenStopped = true
            activityIndicator.frame = CGRectMake(0, 0, 45, 45)
            activityIndicator.accessibilityIdentifier = accessiblityIdentifier
            activityIndicator.startAnimating()
            
            activityIndicator.center = activityHolderView.center
            appDelegate?.window??.addSubview(activityHolderView)
            appDelegate?.window??.addSubview(activityIndicator)
            appDelegate?.window??.alpha = 0.8
            appDelegate?.window??.userInteractionEnabled = false

        }
    }
    
    /**
     Displays an Activity Indicator to show loading
     */
    func showActivityViewWithText(text:String) {
        
        if  isActivityViewDisplayed == false {
            isActivityViewDisplayed = true
            activityHolderView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            activityHolderView?.center = self.view.center
            activityHolderView.backgroundColor = UIColor.blackColor()
            activityHolderView.alpha = 0.6
            activityStatus.frame = CGRectMake((self.view.frame.width/2)-75, (self.view.frame.height/2), 150,20)
            activityStatus.text = text
            activityStatus.textColor = UIColor.whiteColor()
            activityStatus.textAlignment = NSTextAlignment.Center
            activityHolderView.addSubview(activityStatus)
            self.view.addSubview(activityHolderView)
            
            let basePoint = self.view.convertPoint(activityHolderView.frame.origin, fromCoordinateSpace: UIWindow())
            activityHolderView.frame.origin = basePoint
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicator.hidesWhenStopped = true
            activityIndicator.frame = CGRectMake(0, 0, 45, 45)
            activityIndicator.accessibilityIdentifier = accessiblityIdentifier
            activityIndicator.startAnimating()
            
            activityIndicator.center = CGPointMake(activityHolderView.center.x, activityHolderView.center.y-64)
            self.view.addSubview(activityIndicator)
            
            self.view.userInteractionEnabled = false
        }
    }
    
    /**
     Hide the Activity Indicator
     */
    func hideActivityView() {
        if isActivityViewDisplayed == true {
            let appDelegate = UIApplication.sharedApplication().delegate
            activityHolderView.removeFromSuperview()
            activityIndicator.removeFromSuperview()
            activityStatus.removeFromSuperview()
            isActivityViewDisplayed = false
            self.view.userInteractionEnabled = true
            
            appDelegate?.window??.alpha = 1.0
            appDelegate?.window??.userInteractionEnabled = true
        }
        
    }
}