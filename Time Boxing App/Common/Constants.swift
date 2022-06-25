//
//  Constants.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 21/06/22.
//

import Foundation

enum CellViewName : String {
    case task = "TaskCellView"
}

enum ViewControllerName: String {
    case TabView = "TabViewController"
}

enum StoryboardName : String {
    case Home = "HomeStoryboard"
}

enum AssetsName : String {
    case checkBoxChecked = "check_box_checked"
    case checkBoxUnchecked = "check_box_unchecked"
}

enum DateFormat : String {
    case format1 = "EEEE, MMM d - HH:mm"
    case format2 = "dd-MM-yyyy"
    case format3 = "HH:mm"
}

enum LoginType {
    case AppleId, Google, Other
}
