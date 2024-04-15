//
//  CitiesDsiplayTableViewController.swift
//  TripPlanner
//
//  Created by Rachit Chawla on 12/04/24.
//

import UIKit

class CitiesDisplayTableViewController: UITableViewController, UISearchResultsUpdating {

    var cities = [String]() // This array will store the list of cities
    var todoPlaces = [String: [String]]() // Dictionary to store places for each city
    var filteredCities = [String]() // Array to hold search results
    let searchController = UISearchController(searchResultsController: nil)
    var weatherData = [String: WeatherResult]()
    let iconCache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        fetchWeatherForAllCities()
    }
    
    func fetchWeatherForAllCities() {
        cities.forEach { city in
            fetchWeather(for: city)
        }
    }
    
    func fetchIcon(named iconName: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = iconCache.object(forKey: iconName as NSString) {
            completion(cachedImage)
            return
        }
        
        let urlString = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.iconCache.setObject(image, forKey: iconName as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    func fetchWeather(for city: String) {
        print("fetch function called for " + city)
        let apiKey = "d1b122163b84a6185bda2808a0dc8f3d"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        print(url)
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("Error fetching weather: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received")
                }
                return
            }
            
            do {
                let weatherResult = try JSONDecoder().decode(WeatherResult.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData[city] = weatherResult
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    print("JSON decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredCities = cities.filter { (city: String) -> Bool in
            return city.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCities.count : cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for: indexPath)
        let city: String
        if isFiltering {
            city = filteredCities[indexPath.row]
        } else {
            city = cities[indexPath.row]
        }
        cell.textLabel?.text = city

        // Configure the cell with weather data if available
        if let weatherResult = weatherData[city] {
            let temp = weatherResult.main.temp
            cell.detailTextLabel?.text = "\(temp)"
            
            if let iconName = weatherResult.weather.first?.icon {
                fetchIcon(named: iconName) { icon in
                    guard let icon = icon else { return }
                    cell.imageView?.image = icon
                    cell.layoutSubviews() // Ensure the cell updates its layout to accommodate the icon
                }
            }
        } else {
            cell.detailTextLabel?.text = "Loading..."
            cell.imageView?.image = nil
        }

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CitiesToCitySearch", let citySearchVC = segue.destination as? CitySearchTableViewController {
            citySearchVC.delegate = self
        }
        else if segue.identifier == "displayToDetails", let destinationVC = segue.destination as? CityDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            let selectedCity: String
            if isFiltering {
                selectedCity = filteredCities[indexPath.row]
            } else {
                selectedCity = cities[indexPath.row]
            }
            destinationVC.cityName = selectedCity
            destinationVC.places = todoPlaces[selectedCity] ?? []
            destinationVC.delegate = self // Ensure CityDetailsViewController can pass data back
        }
    }
}

// MARK: - CityDetailsViewControllerDelegate
extension CitiesDisplayTableViewController: CityDetailsViewControllerDelegate {
    func didSavePlaces(for city: String, places: [String]) {
        if !cities.contains(city) {
            cities.append(city) // Append the new city to the array if it's not already there
            
        }
        todoPlaces[city] = places
        fetchWeatherForAllCities()
        tableView.reloadData() // Refresh the table view to display the new data
    }
}
