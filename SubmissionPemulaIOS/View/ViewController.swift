//
//  ViewController.swift
//  SubmissionPemulaIOS
//
//  Created by Ifvo Deky Wirawan on 11/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var restaurantTableView: UITableView!
    private var restaurants: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        
        restaurantTableView.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{ await getRestaurants()}
    }
    
    func getRestaurants() async {
        let network = NetworkService()
        do {
            restaurants = try await network.getRestaurants()
            restaurantTableView.reloadData()
        } catch {
            fatalError("Error: connection failed.")
        }
    }
    
    @IBAction func moveToProfile(_ sender: Any) {
        performSegue(withIdentifier: "moveToProfile", sender: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "restaurantTableViewCell",
            for: indexPath
        ) as? RestaurantTableViewCell { // Mencari UITableViewCell berdasarkan Identifier.
            let restaurant = restaurants[indexPath.row]
            cell.restaurantLabel.text = restaurant.name
            
            cell.restaurantImageView.image = restaurant.image
            
            if restaurant.state == .new {
                cell.indicatorLoading.isHidden = false
                cell.indicatorLoading.startAnimating()
                startDownload(restaurant: restaurant, indexPath: indexPath)
            } else {
                cell.indicatorLoading.stopAnimating()
                cell.indicatorLoading.isHidden = true
            }
            
            return cell
        } else {
            return UITableViewCell() // Mengembalikan UITableViewCell jika tidak ditemukan.
        }
    }
    
    
    fileprivate func startDownload(restaurant: Restaurant, indexPath: IndexPath){
        let imageDownloader = ImageDownloader()
        
        if restaurant.state == .new {
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: restaurant.pictureId)
                    restaurant.state = .downloaded
                    restaurant.image = image
                    self.restaurantTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    restaurant.state = .failed
                    restaurant.image = nil
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "moveToDetail", sender: restaurants[indexPath.row].id)
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "moveToDetail" {
            if let detaiViewController = segue.destination as? DetailViewController {
                detaiViewController.id = sender as? String
            }
        }
    }
}



