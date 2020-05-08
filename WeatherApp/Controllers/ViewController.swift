//
//  ViewController.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//

import UIKit

class ViewController: WeatherBaseViewController {
    
    @IBOutlet weak var weatherTableViewHt: NSLayoutConstraint!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherTodayDescription: UILabel!
    @IBOutlet weak var weatherDetailsTableView: UITableView!
    @IBOutlet weak var weatherTableView: UITableView!
    var weatherModel = WeatherModel()
    var cityName: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherdetails(city: self.cityName?.stringTrim() ?? "")
        self.registerNib()
        
    }
    
    func registerNib() {
        let weatherCollNib = UINib.init(nibName: Constant.weatherCollectionViewCell, bundle: nil)
        self.weatherCollectionView.register(weatherCollNib, forCellWithReuseIdentifier: Constant.weatherCollectionViewCell)
    }
    
    override func loadTableViewCell() {
        let weather        = UINib.init(nibName: Constant.weatherCell, bundle: nil)
        let weatherDetails = UINib.init(nibName: Constant.weatherDetailsCell, bundle: nil)
        self.weatherTableView.register(weather, forCellReuseIdentifier: Constant.weatherCell)
        self.weatherDetailsTableView.register(weatherDetails, forCellReuseIdentifier: Constant.weatherDetailsCell)
    }
    
    override func setupSubviews() {
        
        self.weatherTodayDescription.text = "Today: Mostly sunny currently.The high will be 42º. Clear tonight with a low of 17º"
        self.cityNameLabel.text           = self.cityName ?? ""
        self.weatherDescription.text      = "Mostly Sunny"
        self.weatherDetailsTableView.tableFooterView = UIView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.weatherTableViewHt.constant = self.weatherTableView.contentSize.height
    }
    
    @IBAction private func closeButtonClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func getWeatherdetails(city: String){
        self.showLoader()
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constant.API_KEY)"
        WeatherAPIConnection.shard.weatherConnection(url: url, successBlock: { (result) in
            self.weatherModel = WeatherModel()
            self.weatherModel.initWith(dictionary: result)
            DispatchQueue.main.async {
                self.weatherDetailsTableView.reloadData()
                self.hideLoader()
            }
            
        }, failureBlock: { (error) in
            print(error)
            self.hideLoader()
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == weatherTableView){
            return 7
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == weatherTableView){
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Constant.weatherCell, for: indexPath) as? weatherTableViewCell else {return UITableViewCell()}
            switch indexPath.row {
            case 1:
                cell.dayNameLbl.text  = "Tuesday"
                cell.weatherImg.image = #imageLiteral(resourceName: "cloud")
                cell.tempMaximum.text = "32"
                cell.tempMinimum.text = "23"
            case 2:
                cell.dayNameLbl.text  = "Wednesday"
                cell.weatherImg.image = #imageLiteral(resourceName: "cloud")
                cell.tempMaximum.text = "35"
                cell.tempMinimum.text = "37"
            case 3:
                cell.dayNameLbl.text  = "Thursday"
                cell.weatherImg.image = #imageLiteral(resourceName: "sun")
                cell.tempMaximum.text = "35"
                cell.tempMinimum.text = "24"
            case 4:
                cell.dayNameLbl.text  = "Friday"
                cell.weatherImg.image = #imageLiteral(resourceName: "sun")
                cell.tempMaximum.text = "28"
                cell.tempMinimum.text = "23"
            case 5:
                cell.dayNameLbl.text  = "Saturday"
                cell.weatherImg.image = #imageLiteral(resourceName: "sun")
                cell.tempMaximum.text = "42"
                cell.tempMinimum.text = "36"
            case 6:
                cell.dayNameLbl.text  = "Sunday"
                cell.weatherImg.image = #imageLiteral(resourceName: "sun")
                cell.tempMaximum.text = "32"
                cell.tempMinimum.text = "27"
            case 0:
                cell.dayNameLbl.text  = "Monday"
                cell.weatherImg.image = #imageLiteral(resourceName: "sun")
                cell.tempMaximum.text = "32"
                cell.tempMinimum.text = "23"
            default:
                break
            }
            cell.selectionStyle         = .none
            return cell
        }else{
            guard let cell = weatherDetailsTableView.dequeueReusableCell(withIdentifier: Constant.weatherDetailsCell, for: indexPath) as? weatherDetailsTableViewCell else {return UITableViewCell()}
            switch indexPath.row {
            case 0:
                cell.titleLeft.text = "SUNRISE"
                cell.titleRight.text = "SUNSET"
                cell.leftValue.text   = DateHelper.getSunTimings(time: weatherModel.sunrisetime ?? 0)
                cell.rightValue.text   = DateHelper.getSunTimings(time: weatherModel.sunSetTime ?? 0)
            case 1:
                cell.titleLeft.text  = "CHANCE OF RAIN"
                cell.titleRight.text = "HUMIDITY"
                cell.leftValue.text  = "0%"
                cell.rightValue.text = "\(weatherModel.humidity ?? 0)%"
            case 2:
                cell.titleLeft.text  = "WIND"
                cell.titleRight.text = "FEELS LIKE"
                cell.leftValue.text  = "SW \(weatherModel.windSpeed ?? 0) kph"
                cell.rightValue.text = DateHelper.getCelsiusValueFrom(kelvin: weatherModel.feels_like ?? 0)
            case 3:
                cell.titleLeft.text  = "PRECIPITATION"
                cell.titleRight.text = "PRESSURE"
                cell.leftValue.text  = "0 cm"
                cell.rightValue.text = "\(weatherModel.pressure ?? 0) hPa"
            case 4:
                cell.titleLeft.text  = "VISIBILITY"
                cell.titleRight.text = "UV INDEX"
                cell.leftValue.text  = "\(weatherModel.visibility ?? 0) km"
                cell.rightValue.text = "11"
                
            default:
                break
            }
            cell.selectionStyle      = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == weatherTableView){
            return 35
        }else{
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
}
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.weatherCollectionViewCell, for: indexPath) as? weatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.tempLabel.text   = "32º"
            cell.timelabel.text   = "NOW"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 1:
            cell.tempLabel.text   = "34º"
            cell.timelabel.text   = "11AM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 2:
            cell.tempLabel.text   = "36º"
            cell.timelabel.text   = "12AM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 3:
            cell.tempLabel.text   = "32º"
            cell.timelabel.text   = "1PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 4:
            cell.tempLabel.text   = "37º"
            cell.timelabel.text   = "2PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 5:
            cell.tempLabel.text   = "32º"
            cell.timelabel.text   = "3AM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 6:
            cell.tempLabel.text   = "32º"
            cell.timelabel.text   = "4PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 7:
            cell.tempLabel.text   = "30º"
            cell.timelabel.text   = "5PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 8:
            cell.tempLabel.text   = "27º"
            cell.timelabel.text   = "6PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 9:
            cell.tempLabel.text   = "23º"
            cell.timelabel.text   = "7PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        default:
            break
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}
