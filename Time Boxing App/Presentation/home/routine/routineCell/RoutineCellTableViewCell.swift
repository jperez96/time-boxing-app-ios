//
//  RoutineCellTableViewCell.swift
//  Time Boxing App
//
//  Created by Julio Perez on 2/07/22.
//

import UIKit

class RoutineCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ routine: Routine) {
        self.textLabel?.text = routine.name
    }
    
}
