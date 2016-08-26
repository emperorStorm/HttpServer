//
//  HttpServer.swift
//  HttpServer
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 Jon. All rights reserved.
//

import Foundation
import Alamofire

class HttpServer {
    
    //MARK: - 发送Request请求，返回JSON形式的返回值
    class func httpRequest(
        method: Alamofire.Method,
        URL: String,
        params: [String: AnyObject],
        success:(successData: AnyObject) -> Void,
        faile:(faileData:AnyObject) -> Void) {
        
        Alamofire.request(method, URL, parameters: params).responseJSON {
            (response) in
            switch response.result {
            case .Success:
                if let JSON = response.result.value {
                    success(successData: JSON)
                }
            case .Failure(let error):
                faile(faileData: error)
            }
        }
        
    }
    
    //MARK: - 使用文件流形式上传文件
    class func httpUpload(
        method: Alamofire.Method,
        URL: String,
        fileURL: NSURL,
        progress:(speed: Int, current: Int, total: Int) -> Void,
        success:(successData: AnyObject) -> Void,
        faile:(faileData: ErrorType) -> Void) {
        
        Alamofire.upload(method, URL, file: fileURL).progress {
            (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
            
            //将代码块的工作转会主线程，使数据与UI界面效果持续变化
            dispatch_async(dispatch_get_main_queue(), { 
                progress(speed: Int(bytesWritten), current: Int(totalBytesWritten), total: Int(totalBytesExpectedToWrite))
            })
        }.responseJSON { (response) in
            
            switch response.result {
            case .Success:
                if let JSON = response.result.value {
                    success(successData: JSON)
                }
            case .Failure(let error):
                faile(faileData: error)
            }
        }
    }
    
    //MARK: - 上传MultipartFormData类型的文件数据(多个参数以Data形式传入)
    class func httpUploadWithData(
        method: Alamofire.Method,
        URL: String,
        param: [String: NSData?],
        success:(successData: AnyObject) -> Void,
        faile:(faileData: ErrorType) -> Void) {
        
        Alamofire.upload(method, URL, multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.appendBodyPart(data: value!, name: key)
            }
        }) { (encodingResult) in
            
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if let JSON = response.result.value {
                        success(successData: JSON)
                    }
                })
            case .Failure(let error):
                faile(faileData: error)
            }
        }
    }
    
}