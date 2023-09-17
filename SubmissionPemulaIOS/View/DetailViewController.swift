//
//  DetailViewController.swift
//  SubmissionPemulaIOS
//
//  Created by Ifvo Deky Wirawan on 12/06/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantDescriptionLabel: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    private var restaurantDetail: RestaurantDetail?
    var id: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let result = id {
            Task{ await getRestaurantDetail(id: result)}
        }
    }
    
    func getRestaurantDetail(id: String) async {
        let network = NetworkService()
        do {
            restaurantDetail = try await network.getRestaurantDetail(id: id )
            
            if restaurantDetail != nil {
                restaurantNameLabel.text = restaurantDetail!.name
                restaurantAddressLabel.text = "\(restaurantDetail!.address), \(restaurantDetail!.city)"
                restaurantDescriptionLabel.text = restaurantDetail!.description
                
                if restaurantDetail!.state == .new {
                    indicatorLoading.isHidden = false
                    indicatorLoading.startAnimating()
                    startDownload(restaurant: restaurantDetail!)
                } else {
                    indicatorLoading.stopAnimating()
                    indicatorLoading.isHidden = true
                }
            }
            
        } catch {
            fatalError("Error: connection failed.")
        }
    }
    
    fileprivate func startDownload(restaurant: RestaurantDetail){
        let imageDownloader = ImageDownloader()
        
        if restaurant.state == .new {
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: restaurant.pictureId)
                    restaurant.state = .downloaded
                    restaurant.image = image
                    restaurantImageView.image = restaurant.image
                } catch {
                    restaurant.state = .failed
                    restaurant.image = nil
                }
            }
        }
    }
}
