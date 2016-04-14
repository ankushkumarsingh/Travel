//
//  ViewController.swift
//  imageFilter
//
//  Created by citiadmin on 3/12/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var flightData: Array<FlightsDataModal>?
    var airportMap : Dictionary<String,String>?
    var airlineMap : Dictionary<String,String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlPath: String = SERVER_URL
        data_request(urlPath)
        navigationController?.showActivityView()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        if #available(iOS 9.0, *) {
        } else {
           UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent , animated: false)
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    deinit{
        print("ViewController Released")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //sort by price
    @IBAction func priceSort(sender: UIButton) {
        
       self.flightData?.sortInPlace { (element1, element2) -> Bool in
            return element1.price < element2.price }
        self.tableView.reloadData()
    }
    //sort by departure time
    @IBAction func departureSort(sender: UIButton) {
        self.flightData?.sortInPlace { (element1, element2) -> Bool in
            return element1.takeoffTime < element2.takeoffTime }
        self.tableView.reloadData()
    }
    //sort by arrival time
    @IBAction func arrivalSort(sender: UIButton) {
        self.flightData?.sortInPlace { (element1, element2) -> Bool in
            return element1.landingTime < element2.landingTime }
        self.tableView.reloadData()
    }
    
    // tableview delegates
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return flightData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(FLIGHT_CELL, forIndexPath: indexPath) as! TableViewCell
        if let flightData = self.flightData{
            cell.price.text = flightData[indexPath.row].price
            cell.flightClass.text = flightData[indexPath.row].planeClass
            let airlineCode = flightData[indexPath.row].airlineCode
            let originCode = flightData[indexPath.row].originCode
            let destinationCode = flightData[indexPath.row].destinationCode
            if let airlineMap = self.airlineMap {
                cell.airlineCode.text = airlineMap[airlineCode]
            }
            if let airportOrigin = self.airportMap?[originCode], let airportDestination = self.airportMap?[destinationCode]{
                cell.departArrivalAirport.text = airportOrigin + HYPHEN + airportDestination
            }
            let takeOffTime : NSDate = dateUtil(flightData[indexPath.row].takeoffTime)
            let landingTime : NSDate = dateUtil(flightData[indexPath.row].landingTime)
            cell.departArrivalTime.text = dateConverter(takeOffTime) + HYPHEN + dateConverter(landingTime)
            let durationHours = landingTime.hoursFrom(takeOffTime)
            let durationMinutes = landingTime.minutesFrom(takeOffTime) - durationHours*60
            cell.duration.text = String(durationHours) + HOUR + WHIGHTSPACE + String(durationMinutes) + MINUTE
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62.0
    }
    
    func dateConverter(date :NSDate)->String{
        let dateFormater : NSDateFormatter = NSDateFormatter()
        dateFormater.dateFormat = HOUR_MIN_FORMATE
        return dateFormater.stringFromDate(date)
    }
    
    
    func dateUtil(dateStr :String)->NSDate {
        let timeIntervalInMilliSec : NSTimeInterval = (dateStr as NSString).doubleValue // convert it in to NSTimeInteral
        let timeIntervalInSec = timeIntervalInMilliSec/1000
        let dateFromServer = NSDate(timeIntervalSince1970:timeIntervalInSec)
        // Here i create a simple date formatter and print the string from DATE object. you can do it vise-versa.
        return dateFromServer
    }
    
    
    //fetching data from server
    func data_request(url_to_request:String)
    {
        let url:NSURL = NSURL(string: url_to_request)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTP_METHOD_GET
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData

        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            do {
                let object : AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                if let flightModelobject = (FlightModal.Map(object)){
                    if let flightObject = flightModelobject.flightsData  {
                        self.flightData = flightObject
                    }
                    if let airportMap = flightModelobject.airportMap  {
                        self.airportMap = airportMap
                    }
                    if let airlineMap = flightModelobject.airlineMap  {
                        self.airlineMap = airlineMap
                    }
                }
                

            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.hideActivityView()
                self.tableView.reloadData()
            })
            
        }
        
        task.resume()
        
    }
    
}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
