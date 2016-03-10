//
//  ViewController.swift
//  Stormy
//
//  Created by Phillip Paik on 2/14/16.
//  Copyright © 2016 Phillip Paik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dailyWeather: DailyWeather? {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var sunriseTime: UILabel?
    @IBOutlet weak var sunsetTIme: UILabel?
    @IBOutlet weak var lowTemperatureLabel: UILabel?
    @IBOutlet weak var highTemperatureLabel: UILabel?
    @IBOutlet weak var precipitationLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()

    }

    func configureView(){
        if let weather = dailyWeather{
            self.title = weather.day
            weatherIcon?.image = weather.largeIcon
            summaryLabel?.text = weather.summary
            sunriseTime?.text = weather.sunsetTime
            sunsetTIme?.text = weather.sunriseTime
            
            if let lowTemp = weather.minTemperature, let highTemp = weather.maxTemperature, let rain = weather.precipChance, let humidity = weather.humidity {
                lowTemperatureLabel?.text = "\(lowTemp)º"
                highTemperatureLabel?.text = "\(highTemp)º"
                precipitationLabel?.text = "\(rain)%"
                humidityLabel?.text = "\(humidity)%"
            }
        }
        
        // Configure navBar back button
        let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0)
        let barButtonAttributesDictionary: [String: AnyObject]? = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: buttonFont!]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, forState: .Normal)
        
        // Update UI with Info from the data model
        
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}





