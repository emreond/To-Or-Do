//
//  SomeTableViewCell.swift
//  To Or Do Project
//
//  Created by Emre on 21.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit

class TableViewCellWithIcon: UITableViewCell {
    @IBOutlet weak var cellIcon: UIImageView!
    
    @IBOutlet weak var taskTitle: UILabel!
    
    var data: CustomList? {
        didSet{
            self.taskTitle.text = data?.listName
            self.cellIcon.image = UIImage(named: data!.imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellIcon.tintColor = Colors.iconsColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
