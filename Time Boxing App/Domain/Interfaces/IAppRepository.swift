//
//  AppRepository.swift
//  Time Boxing App
//
//  Created by Julio Perez on 14/07/22.
//

import Foundation
import RxSwift

protocol IAppRepository {
    func syncDataToApp()
    func syncDataToCloud()
}
