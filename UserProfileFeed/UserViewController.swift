//
//  UserViewController.swift
//  UserProfileFeed
//
//  Created by BHARATHI K on 04/04/22.
//  Copyright © 2022 BHARATHI K. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    var url: String = ""
    var userDetails : UserProfile?
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        avatarImageView.clipsToBounds = true
        
        getUserProfile(url: url)
        
        self.view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
    }
    
    // MARK: - Image Loading
    func loadImage(url: String , completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
           
            let url = URL(string: url)!
            
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    func getUserProfile(url: String) {
        
        let urlString = url
        Service.shared.getResults(url: urlString) {[weak self] Data in
            switch Data {
            case .success(let results):
                print(results)
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(UserProfile.self, from: results)
                    print(results)
                    self?.userDetails = results
                    self?.configureLabels()
                }catch let error {
                    print("error", error)
                }
                
            case .failure(let error):
                print("error",error.localizedDescription)
            }
        }
    }
    
    
    
    func configureLabels()  {
        
        print(self.userDetails as Any)
        
        DispatchQueue.main.async {
            
            self.nameLabel.text = self.userDetails?.name
            self.companyLabel.text = self.userDetails?.company
            self.locationLabel.text = self.userDetails?.location
            self.followersLabel.text = String(format: "%d", self.userDetails?.followers as! CVarArg)
            self.loadImage(url:self.userDetails?.avatarUrl ?? "" ) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                
                
                self.avatarImageView.image = image
            }
            
            
        }
        
        
    }
    
    
    
}
