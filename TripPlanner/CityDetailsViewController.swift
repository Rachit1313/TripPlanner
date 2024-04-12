//
//  CityDetailsViewController.swift
//  TripPlanner
//
//  Created by Rachit Chawla on 12/04/24.
//

import UIKit

class CityDetailsViewController: UIViewController, UITableViewDataSource {

    var cityName: String?
    var places: [String] = []
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("City Name: \(cityName ?? "nil")")
        navigationItem.title = cityName
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
            if let placeName = textField.text, !placeName.isEmpty {
                places.append(placeName) // Add the new place to the array
                tableView.reloadData() // Refresh the table view to show the new place
                textField.text = "" // Clear the text field
            }
        }
    
    // UITableViewDataSource methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return places.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
            cell.textLabel?.text = places[indexPath.row]
            return cell
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
