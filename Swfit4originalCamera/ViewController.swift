//
//  ViewController.swift
//  Swfit4originalCamera
//
//  Created by tatsumi kentaro on 2018/02/12.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {

    var input:AVCaptureDeviceInput!
    var output:AVCapturePhotoOutput!
    var session:AVCaptureSession!
    @IBOutlet var preView:UIView!
    var camera:AVCaptureDevice!
    
    
    @IBOutlet weak var yellowButton: UIButton!
    private var photoData: Data?
    var imageData:Data?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面タップでシャッターを切るための設定
//        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self, action: #selector(ViewController.tapped(_:)))
        // デリゲートをセット
//        tapGesture.delegate = self;
        // Viewに追加.
//        self.view.addGestureRecognizer(tapGesture)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // スクリーン設定
//        setupDisplay()
        // カメラの設定
        setupCamera()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //初期化
        // camera stop メモリ解放
        session.stopRunning()
        
        for output in session.outputs {
            //session.removeOutput((output as? AVCaptureOutput)!)
            session.removeOutput(output)
        }
        
        for input in session.inputs {
            //session.removeInput((input as? AVCaptureInput)!)
            session.removeInput(input)
        }
        session = nil
        camera = nil
    }
    
//    func setupDisplay(){
//        スクリーンの幅
//        let screenWidth = UIScreen.main.bounds.size.width;
//        //スクリーンの高さ
//        let screenHeight = UIScreen.main.bounds.size.height;
//
//        // プレビュー用のビューを生成
//        preView = UIView(frame: CGRect(x: 0.0, y: 0.0,
//                                       width: screenWidth, height: screenHeight))
//
//    }
    
    // camera initialize
    func setupCamera(){
        // セッション
        session = AVCaptureSession()
        
        // 背面・前面カメラの選択
        camera = AVCaptureDevice.default(
            AVCaptureDevice.DeviceType.builtInWideAngleCamera,
            for: AVMediaType.video,
            position: .back) // position: .front
        
        // カメラからの入力データ
        do {
            input = try AVCaptureDeviceInput(device: camera)
            
        } catch let error as NSError {
            print(error)
        }
        // 入力をセッションに追加
        if(session.canAddInput(input)) {
            session.addInput(input)
        }
        
        // 静止画出力のインスタンス生成
        output = AVCapturePhotoOutput()
        
        // 出力をセッションに追加
        if(session.canAddOutput(output)) {
            session.addOutput(output)
        }
        
        // セッションからプレビューを表示を
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer.frame = preView.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // レイヤーをViewに設定
        // これを外すとプレビューが無くなる、けれど撮影はできる
        self.view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    
    // タップイベント.
    @IBAction func tapped(_ sender:Any){
        print("タップ")
        takeStillPicture()
    }
    
    
    func takeStillPicture(){
        //写真を撮るときの設定
        let photoSettings = AVCapturePhotoSettings()
        //フラッシュオート
        photoSettings.flashMode = .auto
        //手ぶれ補正
        photoSettings.isAutoStillImageStabilizationEnabled = true
        //撮る写真の最大化
        photoSettings.isHighResolutionPhotoEnabled = false
        //キャプチャ先から撮影データを取得
        output?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    //    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // AVCapturePhotoOutput.jpegPhotoDataRepresentation deprecated in iOS11
        imageData = photo.fileDataRepresentation()
        
        let photo = UIImage(data: imageData!)
        // アルバムに追加.
        UIImageWriteToSavedPhotosAlbum(photo!, self, nil, nil)
         performSegue(withIdentifier: "goResult", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goResult"{
            let resultViewContoroller = segue.destination as! ResultViewController
            resultViewContoroller.imageData = self.imageData
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

