//
//  SearchViewController.swift
//  bumerang
//
//  Created by Billiard ball on 05.02.2020.
//  Copyright © 2020 RMS. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit


protocol SearchViewControllerDelegate:class {
    func myVCDidFinish(city: String, lat: Double, lng: Double)
}


class SearchViewController: UIViewController {

    weak var delegate: SearchViewControllerDelegate?
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var ui_mapView: GMSMapView!
    @IBOutlet weak var ui_tableView: UITableView!
    @IBOutlet weak var report_product: UIButton!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var cameraPosition = GMSCameraPosition.camera(withLatitude: 41.015137, longitude: 28.979530, zoom: 11.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ui_mapView.delegate = self
        
        ui_mapView.camera = cameraPosition
        ui_tableView.isHidden = true;
        searchCompleter.delegate = self
    }
       
    //MARK:- product report func
    @IBAction func didReportPro(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) -> Void in
            print("kkk")
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func didcancelBtn(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any)
    {
        delegate?.myVCDidFinish(city: searchbar.text!, lat: cameraPosition.target.latitude, lng: cameraPosition.target.longitude)
        self.dismiss(animated: true, completion: nil)
    }


}

extension SearchViewController : GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        let coordinate = CLLocationCoordinate2DMake(position.target.latitude, position.target.longitude)
        
        GMSGeocoder().reverseGeocodeCoordinate(coordinate) { (response, error) in
            
            if let address = response?.firstResult() {
                //let lines = address.lines! as [String]

                var str = "";
                if let subLocality = address.subLocality {
                    str = subLocality;
                }
                
                if let locality = address.locality {
                    
                    if str.count > 0 {
                        
                        str = String(format: "%@, %@", str, locality)
                    } else {
                        str = locality;
                    }
                }
                
                if let county = address.country {
                    
                    if str.count > 0 {
                        
                        str = String(format: "%@, %@", str, county)
                    } else {
                        str = county;
                    }
                }
                
                self.searchbar.text = str
                print()
            }
        }
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        if searchResults.count > 0 {
            ui_tableView.isHidden = false
        } else {
            ui_tableView.isHidden = true
        }
        
        ui_tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}


extension SearchViewController : UISearchBarDelegate {
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        
        if searchResults.count > 0 {
            ui_tableView.isHidden = false
        } else {
            ui_tableView.isHidden = true
        }
        
        ui_tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText

    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //showToast("searchBarSearchButtonClickedlogin", duration: 2, position: .center)
        searchBar.endEditing(true)
        
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(format: "%@, %@", searchResult.title, searchResult.subtitle)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
            
            self.cameraPosition = GMSCameraPosition.camera(withLatitude: coordinate!.latitude, longitude: coordinate!.longitude, zoom: 11.0)
            self.ui_mapView.camera = self.cameraPosition
        }
        
        self.searchbar.text = String(format: "%@, %@", completion.title, completion.subtitle)
        self.ui_tableView.isHidden = true;
        self.searchbar.endEditing(true)
    }
}
