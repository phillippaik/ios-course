//
//  WeeklyTableTableViewController.swift
//  Stormy
//
//  Created by Phillip Paik on 2/24/16.
//  Copyright © 2016 Phillip Paik. All rights reserved.
//

import UIKit
import CoreLocation



class WeeklyTableTableViewController: UITableViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    @IBOutlet weak var currentCustomLabel: UILabel?
    
    
    // LOCATION
    var locationManager = CLLocationManager()

    var latitude1: Double?
    var longitude: Double?
    var coordinate: (lat:Double, long: Double) = (12.3222, 12.222)
    private let forecastAPIKey = "248840f3c64ecba0f40103aeb73864e1"

    
    var weeklyWeather: [DailyWeather] = []
    
    var temp1: Int = 7777
    var precip1: Int = 7777
    
    
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        retrieveWeatherForcast()
        configureView()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        coordinate = (locValue.latitude,locValue.longitude)
        retrieveWeatherForcast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView(){
        // Set table views background views property
        tableView.backgroundView = BackgroundView()
        
        // Set custom height for tableview
        tableView.rowHeight = 64
        
        // Change Font and Size of Nav Bar Text
        let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0)
        let navBarAttributesDictionary: [String: AnyObject]? = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: navBarFont!]
        
        
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        // Position refresh control above background view
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func refreshWeather() {
        retrieveWeatherForcast()
        refreshControl?.endRefreshing()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDaily" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let dailyWeather = weeklyWeather[indexPath.row]
                
                (segue.destinationViewController as! ViewController).dailyWeather = dailyWeather
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weeklyWeather.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! DailyWeatherTableViewCell
        
        let dailyWeather = weeklyWeather[indexPath.row]
        if let maxTemp = dailyWeather.maxTemperature{
            cell.temperatureLabel.text = "\(maxTemp)º"
        }
        cell.weatherIcon.image = dailyWeather.icon
        cell.dayLabel.text = dailyWeather.day
        
        
        return cell
    }
    
    // MARK: - Delegate Methods
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red:0.16, green:0.74, blue:1.0, alpha:1.0)
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            header.textLabel?.textColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor(red:0.16, green:0.74, blue:1.0, alpha:1.0)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red:0.16, green:0.74, blue:1.0, alpha:1.0)
        cell?.selectedBackgroundView = highlightView
    }
    
    // MARK: - Weather Fetching
    
    func retrieveWeatherForcast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, lon: coordinate.long){
            (let forecast) in
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    //Execute Closures
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                        self.temp1 = temperature
                    }

                    if let precip = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "Rain: \(precip)%"
                        self.precip1 = precip
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    
                    self.weeklyWeather = weatherForecast.weekly
                    
                    if let highTemp = self.weeklyWeather.first?.maxTemperature,
                        let lowTemp = self.weeklyWeather.first?.minTemperature {
                            self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º ↓\(lowTemp)º"
                    }
                    
                    if self.precip1 <= 5 {
                        switch self.temp1 {
                        case -40..<40: self.currentCustomLabel?.text = "It's Freaking Cold Jags! Wear a Jacket!"
                        case 40..<55: self.currentCustomLabel?.text = "Little Bit Chilly Jags. Bring a Jacket."
                        case 55..<60: self.currentCustomLabel?.text = "It's Nice Outside... But Bring a Sweater Love."
                        case 60..<80: self.currentCustomLabel?.text = "Perfect Weather for My Perfect Wife!"
                        case 80..<110: self.currentCustomLabel?.text = "Pretty Hot(Just Like You) Outside. Bring Sunscreen."
                        default: self.currentCustomLabel?.text = "Blank"
                        }
                    } else if self.precip1 > 5 && self.precip1 <= 20 {
                        switch self.temp1{
                        case -40..<40: self.currentCustomLabel?.text = "Tiny Chance of Rain! And It's Cold Jags!"
                        case 40..<55: self.currentCustomLabel?.text = "Hey Beautiful. Jacket and an Umbrella Just in Case."
                        case 55..<60: self.currentCustomLabel?.text = "Probably a Sweater and an Umbrella. You Look Amazing"
                        case 60..<80: self.currentCustomLabel?.text = "Hello Perfect. It's Nice Out, But Bring an Umbrella."
                        case 80..<110: self.currentCustomLabel?.text = "Pretty Hot(Just Like You) Outside. Bring Sunscreen."
                        default: self.currentCustomLabel?.text = "Blank"
                        }
                    } else if self.precip1 > 20 && self.precip1 <= 70 {
                        switch self.temp1{
                        case -40..<40: self.currentCustomLabel?.text = "It May Rain! And It's Cold Jags!"
                        case 40..<55: self.currentCustomLabel?.text = "Hey Beautiful. Jacket and an Umbrella Today."
                        case 55..<60: self.currentCustomLabel?.text = "Probably a Sweater and an Umbrella. You Look Amazing"
                        case 60..<80: self.currentCustomLabel?.text = "Hello Perfect. It May Rain, So Bring an Umbrella."
                        case 80..<110: self.currentCustomLabel?.text = "Pretty Hot(Just Like You) Outside. Bring Sunscreen."
                        default: self.currentCustomLabel?.text = "Blank"
                        }
                    } else if self.precip1 > 70 {
                        switch self.temp1{
                        case -40..<40: self.currentCustomLabel?.text = "Freezing Rain Most Likely. I love you."
                        case 40..<55: self.currentCustomLabel?.text = "Hey Beautiful. Jacket and an Umbrella Today."
                        case 55..<60: self.currentCustomLabel?.text = "Probably a Sweater and an Umbrella. You Look Amazing"
                        case 60..<80: self.currentCustomLabel?.text = "Hello Perfect. It's Raining, So Bring an Umbrella."
                        case 80..<110: self.currentCustomLabel?.text = "Pretty Hot(Just Like You) Outside. Bring Sunscreen."
                        default: self.currentCustomLabel?.text = "Blank"
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
    }



}





