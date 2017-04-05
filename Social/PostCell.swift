//
//  PostCell.swift
//  Social
//
//  Created by Tyler Brady on 4/4/17.
//  Copyright © 2017 Tyler Brady. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
