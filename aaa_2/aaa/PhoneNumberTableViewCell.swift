//
//  PhoneNumberTableViewCell.swift
//  aaa
//
//  Created by Apple on 16/6/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {

    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
