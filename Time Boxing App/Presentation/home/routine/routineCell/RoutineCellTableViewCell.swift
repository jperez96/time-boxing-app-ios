//
//  RoutineCellTableViewCell.swift
//  Time Boxing App
//
//  Created by Julio Perez on 2/07/22.
//

import UIKit

class RoutineCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentCell: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpStyle()
    }
    
    private func setUpStyle(){
        contentCell.backgroundColor = .primary
        contentCell.setShadow()
        contentCell.layer.cornerRadius = 5
        titleLabel.textColor = .white
        subtitleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func setData(_ routine: Routine) {
        titleLabel.text = routine.name
        subtitleLabel.text = "Tareas: \(routine.tasks.count)"
    }
    
}
