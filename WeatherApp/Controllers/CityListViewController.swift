//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CityListViewController: WeatherBaseViewController {
    @IBOutlet weak var cityListTableView: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var cityNameTF: UITextField!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var popUpViewOnScreen = Bool()
    var weatherModel : WeatherModel!
    var weatherCoreDatamodel = [NSManagedObject]()
    var weatherList          = [WeatherModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewPopUp.fadeOut()
        getSavedData()
    }
    
    override func setupSubviews() {
        self.cityListTableView.tableFooterView = UIView()
        self.addButton.roundingView(value: 2)
        self.viewPopUp.roundingView(value: 11)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cityListTableViewTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.cityListTableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func cityListTableViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        self.viewPopUp.fadeOut(0.5) {
            self.cityNameTF.resignFirstResponder()
            self.popUpViewOnScreen = false
        }
        
    }
    
    override func loadTableViewCell() {
        let cityNameNib = UINib.init(nibName: Constant.cityListCell, bundle: nil)
        self.cityListTableView.register(cityNameNib, forCellReuseIdentifier: Constant.cityListCell)
    }
    
    @IBAction private func addButtonClicked(_ sender: Any) {
        let (status, message) = validate()
        self.errorLbl.text = nil
        guard status else {
            return self.errorLbl.text = message
        }
        self.addCity(cityName: self.cityNameTF.textTrim())
    }
    
    @IBAction private func cancelbuttonClicked(_ sender: Any) {
        self.cityNameTF.resignFirstResponder()
        self.popUpViewOnScreen = false
        self.viewPopUp.fadeOut(0.5, onCompletion: nil)
    }
    
    @IBAction private func addCityButtonClicked(_ sender: Any) {
        self.popUpViewOnScreen = true
        self.cityNameTF.text = nil
        self.viewPopUp.fadeIn(0.5, onCompletion: nil)
        self.cityNameTF.becomeFirstResponder()
    }
    
    private func validate()->(Bool, String){
        
        guard !((self.cityNameTF?.text?.isEmpty)!) else {
            return (false, "empty".localized)
        }
        
        return(true, "")
    }
    
    private func addCity(cityName: String){
        self.showLoader()
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(Constant.API_KEY)"
        WeatherAPIConnection.shard.weatherConnection(url: url, successBlock: { (result) in
            self.weatherModel = WeatherModel()
            self.weatherModel.initWith(dictionary: result)
            if(self.weatherModel.cityName != nil){
                self.weatherList.append(self.weatherModel)
                self.storeDataToLocal(model: self.weatherModel)
                DispatchQueue.main.async {
                    self.cityListTableView.reloadData()
                    self.viewPopUp.fadeOut(0.5, onCompletion: nil)
                    self.popUpViewOnScreen = false
                    self.hideLoader()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorLbl.text = "Make sure enter valid city name"
                    self.hideLoader()
                    self.popUpViewOnScreen = true
                }
            }
            
        }, failureBlock: { (error) in
            print(error)
            self.hideLoader()
        })
    }
    private  func storeDataToLocal(model: WeatherModel){
        DispatchQueue.main.async {
            guard let appDelegate    = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let entityWeather        = NSEntityDescription.entity(forEntityName: "Weather", in: managedObjectContext)!
            let weather              = NSManagedObject(entity: entityWeather, insertInto: managedObjectContext)
            weather.setValue(model.cityName, forKey: "cityName")
            weather.setValue(model.temp, forKey: "temp")
            weather.setValue(model.timeZone, forKey: "timeZone")
            do{
                try managedObjectContext.save()
                self.getSavedData()
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }
    private func getSavedData(){
        self.showLoader()
        guard let appDelegate    = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequestOne      = NSFetchRequest<NSManagedObject>(entityName: "Weather")
        do {
            self.weatherCoreDatamodel = try managedObjectContext.fetch(fetchRequestOne)
            DispatchQueue.main.async {
                self.cityListTableView.reloadData()
                self.hideLoader()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherCoreDatamodel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cityListTableView.dequeueReusableCell(withIdentifier: Constant.cityList) as? CityListTableViewCell else {
            let cell             = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
            
        }
        
        if (weatherCoreDatamodel.count > 0){
            cell.cityLbl.text = weatherCoreDatamodel[indexPath.row].value(forKey: "cityName") as? String
            cell.timeLbl.text      = DateHelper.getTimeFromTimeZone(timeZone: weatherCoreDatamodel[indexPath.row].value(forKey: "timeZone")  as? Int ?? 0 )
            cell.temperatureLabel.text      = DateHelper.getCelsiusValueFrom(kelvin: weatherCoreDatamodel[indexPath.row].value(forKey: "temp") as? Double ?? 0)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.popUpViewOnScreen == false {
            let storyBoard          = UIStoryboard.init(name: "Main", bundle: nil)
            self.popUpViewOnScreen = false
            guard let controller    = storyBoard.instantiateViewController(withIdentifier: Constant.weatherDetailsViewController) as? ViewController else {return}
            controller.cityName     = weatherCoreDatamodel[indexPath.row].value(forKey: "cityName") as? String
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.popUpViewOnScreen = false
            self.cityNameTF.resignFirstResponder()
            return self.viewPopUp.fadeOut(0.5, onCompletion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

