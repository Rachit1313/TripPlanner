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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        tableView.reloadData() // Refresh the table view to display the new data
    }
}
