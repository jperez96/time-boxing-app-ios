//
//  CustomResponse.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 25/06/22.
//

import Foundation

struct BaseResponse<T> {
    var responseMessage: String = ""
    var responseData: T?
    let responseCode: BaseResponseStatus
    
    static func success<T>(data: T, msg : String = "Ok." ) -> BaseResponse<T> {
        return BaseResponse<T>(responseData: data, responseCode: .Success)
    }
    static func error<T>(msg : String = "Error." ) -> BaseResponse<T> {
        return BaseResponse<T>(responseData: nil, responseCode: .Error)
    }
}

enum BaseResponseStatus {
    case Success, Error
}
