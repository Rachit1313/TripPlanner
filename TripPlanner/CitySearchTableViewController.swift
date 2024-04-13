//
//  CitySearchTableViewController.swift
//  TripPlanner
//
//  Created by Rachit Chawla on 08/04/24.
//

import UIKit

class CitySearchTableViewController: UITableViewController, UISearchResultsUpdating {

    
    weak var delegate: CityDetailsViewControllerDelegate?
    var cities = [String]()
    var filteredCities = [String]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filteredCities.count : cities.count
    }
    
    @objc func getData() {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            print("Search text is empty")
            return
        }
        print("Fetching data for search text: \(searchText)")
        
        // Use your API key here
        let apiKey = "pk.d6db7db10a4b86174a65b3ef9a6bce10"
        let urlString = "https://api.locationiq.com/v1/autocomplete.php?key=\(apiKey)&q=\(searchText)&limit=5&tag=place:city"
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: encodedUrlString!) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error fetching places: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let places = jsonResult.compactMap { $0["display_name"] as? String }
                    DispatchQueue.main.async {
                        self?.filteredCities = places
                        self?.tableView.reloadData()
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }.resume()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
                filteredCities = cities
                tableView.reloadData()
                return
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getData), object: nil)
            perform(#selector(getData), with: nil, afterDelay: 0.3)
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            let city = searchController.isActive ? filteredCities[indexPath.row] : cities[indexPath.row]
            cell.textLabel?.text = city
            return cell
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCityDetails",
           let destinationVC = segue.destination as? CityDetailsViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedCity = searchController.isActive ? filteredCities[indexPath.row] : cities[indexPath.row]
            // Split the selectedCity using the comma as a delimiter and take the first part
            let cityNameBeforeComma = selectedCity.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces)
            destinationVC.cityName = cityNameBeforeComma
        }
        
        if segue.identifier == "showCityDetails", let cityDetailsVC = segue.destination as? CityDetailsViewController {
            cityDetailsVC.delegate = delegate
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
