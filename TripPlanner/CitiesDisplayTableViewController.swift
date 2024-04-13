//
//  CitiesDsiplayTableViewController.swift
//  TripPlanner
//
//  Created by Rachit Chawla on 12/04/24.
//

import UIKit

class CitiesDisplayTableViewController: UITableViewController {

    var cities = [String]() // This array will store the list of cities
    var todoPlaces = [String: [String]]() // Dictionary to store places for each city
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1 // Assuming you have one section
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cities.count // The number of rows is equal to the number of places
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for: indexPath)
                cell.textLabel?.text = cities[indexPath.row]
                return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    // This assumes you have a segue or some method to navigate to CitySearchTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CitiesToCitySearch", let citySearchVC = segue.destination as? CitySearchTableViewController {
            citySearchVC.delegate = self
        }
        else if segue.identifier == "displayToDetails", let destinationVC = segue.destination as? CityDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
                let selectedCity = cities[indexPath.row]
                destinationVC.cityName = selectedCity
                destinationVC.places = todoPlaces[selectedCity] ?? []
                destinationVC.delegate = self // Ensure CityDetailsViewController can pass data back
            }
    }
}
// In CitiesDisplayTableViewController.swift
extension CitiesDisplayTableViewController: CityDetailsViewControllerDelegate {
    func didSavePlaces(for city: String, places: [String]) {
            if !cities.contains(city) {
                cities.append(city) // Append the new city to the array if it's not already there
            }
            todoPlaces[city] = places
            tableView.reloadData() // Refresh the table view to display the new data
        }
}
