//
//  SearchWeatherInformationViewController.swift
//  epiFiProject
//
//  Created by Devank Karanwal on 12/03/23.
//

import UIKit

class SearchWeatherInformationViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var recentSearches: [String] = []
     var dataSearch: [String] = []
    var indexPath = 0
    var globaldata:String?
    var custModel:LocationElementElement?
    var getWeatherInfo: [GetWeatherInfoElement]?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        if let searches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
            recentSearches = searches
        }
        
        
    }
    
       func addRecentSearch(_ query: String) {
           recentSearches.insert(query, at: 0)
           if recentSearches.count > 5 {
               recentSearches.removeLast()
           }
           tableView.reloadData()
           UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
       }
           
           
           
    func getWeatherData(for city: String) {
           let apiKey = "8gY6a5t1S8dHIxdZSMEFJkW9Jtn618Do"
           let baseUrl = "https://dataservice.accuweather.com/locations/v1/cities/search"
           let params = ["apikey": apiKey, "q": city]
        
        print(params)
        
           var components = URLComponents(string: baseUrl)!
           components.queryItems = params.map { key, value in URLQueryItem(name: key, value: value) }
           
           let url = components.url!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    let locations = try JSONDecoder().decode([LocationElementElement].self, from: data)
                    if let location = locations.first {
                        self.getWeatherInfo(for: location.key ?? "", cityName: location.localizedName ?? "")
                    }
                } catch {
                    print("Error decoding location data: \(error)")
                }
            } else {
                print("Error: Data is nil")
            }
        }
           task.resume()
       }

    
    
    
    func getWeatherInfo(for locationKey: String, cityName: String) {
        let apiKey = "8gY6a5t1S8dHIxdZSMEFJkW9Jtn618Do"
            let baseUrl = "https://dataservice.accuweather.com/currentconditions/v1/\(locationKey)"
            let params = ["apikey": apiKey]

            var components = URLComponents(string: baseUrl)!
            components.queryItems = params.map { key, value in URLQueryItem(name: key, value: value) }

            let url = components.url!

            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error!)")
                    return
                }
                do {
                    let conditions = try JSONDecoder().decode([GetWeatherInfoElement].self, from: data)
                    print(conditions)
                    self?.getWeatherInfo = conditions
                    
                    if let condition = conditions.first {
                        let temp = condition.temperature?.metric?.value
                        let unit = condition.temperature?.metric?.unit
                        let text = "\(cityName): \(temp) \(unit)"
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                } catch {
                    print("Error decoding weather data: \(error)")
                }
            }
            task.resume()
        }
    
}


extension SearchWeatherInformationViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        getWeatherData(for: query)
       
        searchBar.resignFirstResponder()
        addRecentSearch(query)
    }

   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



extension SearchWeatherInformationViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
                 return recentSearches.count
               } else {
                   return 1
               }

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if indexPath.section == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath)as! SearchTableViewCell
            
            let query = recentSearches[indexPath.row]
            cell.lblName?.text = query
                globaldata = query
            
        return cell
            
           }
        
        else if indexPath.section == 1{
               
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath)as! DataTableViewCell
            if let weatherInfo = getWeatherInfo {
                  let condition = weatherInfo[indexPath.row]
                let weatherlbl = condition.weatherText
                cell.lblWeather.text = weatherlbl
                
                let temperature = condition.temperature?.metric?.value.map { "\($0)" } ?? "N/A"
                cell.lblTemperature.text = temperature
                
                let time = condition.epochTime
                cell.lblTime.text = time.map { String($0) } ?? ""
                
                let lblWeatherIcon = condition.weatherIcon
                cell.lblWeatherIcon.text = lblWeatherIcon.map{(String($0))} ?? ""
                
              } else {
                  print("no data")
              }
            
            return cell
            
           }
        
        
        return UITableViewCell()
    }

 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailViewController")as! WeatherDetailViewController
        
            searchBar.text = recentSearches[indexPath.row]
        getWeatherData(for: searchBar.text ?? "")
            guard let query = searchBar.text else { return }
            getWeatherData(for: query)
       
        
        let condition = self.getWeatherInfo?[indexPath.row]
          
       UserDefaults.standard.set(condition?.epochTime!, forKey: "time")
       UserDefaults.standard.set(condition?.weatherText, forKey: "weatherText")
       UserDefaults.standard.set(condition?.weatherIcon, forKey: "weatherIcon")
      UserDefaults.standard.set(condition?.temperature?.metric?.value!, forKey: "metrix")

      self.present(controller, animated: true)
        
    }

 

}
