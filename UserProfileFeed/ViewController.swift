//
//  ViewController.swift
//  UserProfileFeed
//
//  Created by BHARATHI K on 31/03/22.
//  Copyright © 2022 BHARATHI K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private var gradientLayer = CAGradientLayer()
    
    var githubProfiles = [Profile]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    
    @IBAction func GetGitHubUseList(_ sender: Any) {
        
        getAllGitHubUsers()
       
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.tableview.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getAllGitHubUsers() {
        let  urlString = "https://api.github.com/users"
               
               Service.shared.getResults(url: urlString) {[weak self] Data in
                   switch Data {
                   case .success(let results):
                       print(results)
                       
                       do {
                           let deconder = JSONDecoder()
                           deconder.keyDecodingStrategy = .convertFromSnakeCase
                           let results = try deconder.decode([Profile].self, from: results)
                           self?.githubProfiles = results
                           
                           DispatchQueue.main.async {
                               self?.tableview.reloadData()
                           }
                           
                           
                       }catch {
                           //
                       }
                       
                   case .failure(let error):
                       print(error)
                   }
               }
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "customCell", bundle: nil)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(nib, forCellReuseIdentifier: "customCell")
        getAllGitHubUsers()
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
    }
    // MARK: - Image Loading
    func loadImage(url: String , completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            //  let url = URL(string: "https://picsum.photos/200")!
            
            let url = URL(string: url)!
            
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
       // let topColor = UIColor(red: 16.0/255.0, green: 12.0/255.0, blue: 54.0/255.0, alpha: 1.0)
     //   let bottomColor = UIColor(red: 57.0/255.0, green: 33.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        
        let topColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = tableview.bounds
        let backgroundView = UIView(frame: tableview.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableview.backgroundView = backgroundView
        
        self.view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(githubProfiles.count)
        return githubProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //  let text = githubProfiles[indexPath.row].login
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customCell
        
        
        //  }
        cell.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        cell.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        cell.jsonLabel.text = githubProfiles[indexPath.row].login
        cell.idLabel.text = String(githubProfiles[indexPath.row].id)
        let itemNumber = NSNumber(value: indexPath.item)
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            print("Using a cached image for item: \(itemNumber)")
            //  cell.imageView?.image = cachedImage
            cell.avatarView.image = cachedImage
        } else {
            // 4
            self.loadImage(url:githubProfiles[indexPath.row].avatarUrl ) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                
                //   cell.imageView?.image = image
                cell.avatarView.image = image
                // 5
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "UserViewController") as! UserViewController
        vc.url = githubProfiles[indexPath.row].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
