//
//  TaskCellTableViewCell.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 21/06/22.
//

import UIKit

protocol TaskCellTableViewCellDelegate {
    func onEditTask(_ task : Task)
}

class TaskCellTableViewCell: UITableViewCell {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconTask: UIImageView!
    private var task : Task?
    var delegate:TaskCellTableViewCellDelegate? = nil
    private let updateTaskUseCase = UpdateTaskUseCase()
    
    func setData(obj: Task, _ taskRoutine : Bool = false){
        task = obj
        titleLabel.text = obj.name
        let hourDif = "\(obj.initDate.string(format: .format3)) - \(obj.finishDate.string(format: .format3))"
        subtitleLabel.text = hourDif
        iconTask.isHidden = !taskRoutine
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle(){
        self.containerView.layer.cornerRadius = 5
        self.containerView.backgroundColor = .primary
        containerView.setShadow()
        titleLabel.textColor = .white
        subtitleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: true)
    }
    
}

extension TaskCellTableViewCell : CheckBoxDelegate {
    func onChangeCheck(_ isCheck: Bool) {
        if(self.task == nil){
            return
        }
        self.task!.finished = isCheck
        self.delegate?.onEditTask(self.task!)
    }
    
}
