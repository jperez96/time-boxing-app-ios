//
//  Constants.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 21/06/22.
//

import Foundation
import UIKit

enum CoreDataEntity : String {
    case TaskEntity = "TaskEntity"
    case RoutineEntity = "RoutineEntity"
}

enum CellViewName : String {
    case task = "TaskCellView"
    case routine = "RoutineCellView"
}

enum ViewControllerName: String {
    case TabView = "TabViewController"
    case LoginView = "LoginViewController"
}

enum StoryboardName : String {
    case Home = "HomeStoryboard"
    case Login = "Main"
}

enum AssetsName : String {
    case checkBoxChecked = "check_box_checked"
    case checkBoxUnchecked = "check_box_unchecked"
}

enum DateFormat : String {
    case format1 = "EEEE, MMM d - HH:mm"
    case format2 = "dd/MM/yyyy"
    case format3 = "HH:mm"
}

enum LoginType : Int {
    case AppleId = 1
    case Google = 2
    case Other = 3
}


let loginCarousel : [CarouselData] = [.init(image: UIImage(named: "on_image1"), text: "Organiza tu tiempo"),.init(image: UIImage(named: "on_image2"), text: "Enfocate en lo que necesitas"), .init(image: UIImage(named: "on_image3"), text: "Pon recordatorios para lo que necesites")]
