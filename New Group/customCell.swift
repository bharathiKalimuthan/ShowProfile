//
//  customCell.swift
//  UserProfileFeed
//
//  Created by BHARATHI K on 01/04/22.
//  Copyright © 2022 BHARATHI K. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    @IBOutlet weak var jsonLabel: UILabel!
    
   
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  makeAvatar()
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
        avatarView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func makeAvatar(){
        
        let radius = self.frame.width / 2
        avatarView.layer.cornerRadius = radius
        avatarView.layer.masksToBounds = true
    }
    
}
