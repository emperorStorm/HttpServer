//
//  ViewController.swift
//  HttpServer
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 Jon. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - 发送网络请求
    @IBAction func action(sender: UIButton) {
        HttpServer.httpRequest(.GET, URL: "https://httpbin.org/get", params: ["foo": "bar"], success: { (successData) in
                print(successData)
            }) { (faileData) in
                print(faileData)
        }
    }

    //MARK: - 上传文件
    @IBAction func upload(sender: UIButton) {
        let fileURL = NSBundle.mainBundle().URLForResource("123", withExtension: "zip")

        HttpServer.httpUpload(.POST, URL: "http://www.hangge.com/upload.php", fileURL: fileURL!, progress:{
            (speed, current, total) in
            
                self.progressView.progress = Float(current) / Float(total)
                print(self.progressView.progress)
            }, success: { (successData) in
                
                print("上传成功!")
            }) { (faileData) in
                print(faileData)
        }
    }
    
    //MARK: - 上传MultipartFormData类型的文件数据(多个参数以Data形式传入)
    @IBAction func upload2(sender: UIButton) {

        let path1 = NSBundle.mainBundle().pathForResource("123", ofType: "zip")!
        let fileData1 = NSData(contentsOfFile: path1)
        let path2 = NSBundle.mainBundle().pathForResource("QK_Manage_A", ofType: "png")!
        let fileData2 = NSData(contentsOfFile: path2)
        let  param = ["file1" : fileData1, "file2" : fileData2]
        
        HttpServer.httpUploadWithData(.POST, URL: "", param: param, success: { (successData) in
                print("上传成功!")
            }) { (faileData) in
                print(faileData)
        }
//        Alamofire.upload(.POST, "", multipartFormData: { (multipartFormData) in
//            
//                multipartFormData.appendBodyPart(fileURL: fileURL1!, name: "file1")
//                multipartFormData.appendBodyPart(fileURL: fileURL2!, name: "file2")
//            }) { (encodingResult) in
//                
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON(completionHandler: { (response) in
//                        debugPrint(response)
//                    })
//                case .Failure(let error):
//                    print(error)
//                }
//        }
        
    }
    
}

