//
//  ViewController.swift
//  GetOnTheBus
//
//  Created by Cindy Barnsdale on 6/14/16.
//  Copyright © 2016 Salar Kohnechi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    var busStops = NSDictionary()
    var busStopsArray = [NSDictionary]()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        let url = NSURL(string: "https://s3.amazonaws.com/mmios8week/bus.json")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            do {
                self.busStops = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                self.busStopsArray = self.busStops.objectForKey("row") as! [NSDictionary]
            }
            catch let error as NSError {
                print("JSON Error: \(error.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        task.resume()
    }





    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStopsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID")!
        let stops = self.busStopsArray[indexPath.row] as NSDictionary
        cell.textLabel!.text = stops.objectForKey("cta_stop_name") as? String
        cell.detailTextLabel?.text = stops.objectForKey("routes") as? String
        
        
        return cell
    }

    
    @IBAction func segmentedControlTapped(sender: UISegmentedControl) {
    
    if sender.selectedSegmentIndex == 0 {
    mapView.hidden = false
    self.title = "Map"
    }
    else {
    mapView.hidden = true
    self.title = "List"

}

}
}
//MVP
//1. As a user, I want to view all transit stops on a map
//On a map, show a pin for each stop from: https://s3.amazonaws.com/mmios8week/bus.json
//2. As a user, I want to see the name and routes of a stop when tapping its pin
//Show a callout for each stop that shows the name and routes
//
//Hint: It would be overkill to show data in a whole new ViewController, also having to tap through to a new ViewController to get such fundamental information would be a bad user-experience
//3. As a user, I want to see the map zoomed to Chicago
//The map should be zoomed such that all pins can be seen
//
//Hint: You can determine the map region by hand, but challenge yourself. Do it programmatically. After all, more bus stops will probably be added in the future.
//4. As a user, I want to see the details of a stop
//Make it so tapping annotationView callouts shows a new detail screen
//
//Hint: A whole new ViewController
//
//Show the bus stop’s name as the screen’s title
//
//Show the stop’s address
//
//Show the bus routes
//
//Show any intermodal transfers (to the suburban Pace bus system or the Metra commuter rail line)
//
//5. As a user, I want to see stop transfers on the map
//Create a custom annotation for stops with transfer options to Metra
//
//Create a custom annotation for stops with transfer options to Pace
//6. As a user, I want to see all of the stops in a list
//Add a segmented control to toggle between a TableView and a MapView
//
//Add the functionality to view the stops in a TableView
//
//Selected TableView items should also display the detail ViewController
//Previous  Next
//Activity Details
