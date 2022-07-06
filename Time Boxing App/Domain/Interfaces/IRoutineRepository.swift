//
//  IRoutineRepository.swift
//  Time Boxing App
//
//  Created by Julio Perez on 4/07/22.
//

import Foundation
import RxSwift

protocol IRoutineRepository {
    func createRoutine(_ task : Routine) -> Single<BaseResponse<Routine>>
    func removeRoutine(_ task : Routine) -> Single<BaseResponse<Bool>>
    func updateRoutine(_ task : Routine) -> Single<BaseResponse<Bool>>
    func getRoutines() -> Single<BaseResponse<[Routine]>>
}
