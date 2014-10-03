
import UIKit
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    // セッション
    var mySession : AVCaptureSession!
    // デバイス
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット
    var myImageOutput : AVCaptureStillImageOutput!
    // ビデオのアウトプット
    var myVideoOutput : AVCaptureMovieFileOutput!
    // スタートボタン
    var myButtonStart : UIButton!
    // ストップボタン
    var myButtonStop : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得
        let devices = AVCaptureDevice.devices()
        
        // バックライトをmyDeviceに格納
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as AVCaptureDevice
            }
        }
        
        // バックカメラを取得.
        let videoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as AVCaptureDeviceInput
        
        // ビデオをセッションのInputに追加
        mySession.addInput(videoInput)
        
        // マイクを取得.
        let audioCaptureDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeAudio)
        
        // マイクをセッションのInputに追加
        let audioInput = AVCaptureDeviceInput.deviceInputWithDevice(audioCaptureDevice[0] as AVCaptureDevice, error: nil)  as AVCaptureInput
        
        // オーディオをセッションに追加
        mySession.addInput(audioInput);
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 動画の保存
        myVideoOutput = AVCaptureMovieFileOutput()
        
        // ビデオ出力をOutputに追加.
        mySession.addOutput(myVideoOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as AVCaptureVideoPreviewLayer
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始
        mySession.startRunning()
        
        // UIボタンを作成
        myButtonStart = UIButton(frame: CGRectMake(0,0,120,50))
        myButtonStop = UIButton(frame: CGRectMake(0,0,120,50))
        
        // 背景色を設定
        myButtonStart.backgroundColor = UIColor.redColor();
        myButtonStop.backgroundColor = UIColor.grayColor();
        
        // 枠を丸くする
        myButtonStart.layer.masksToBounds = true
        myButtonStop.layer.masksToBounds = true
        
        // タイトルを設定
        myButtonStart.setTitle("撮影", forState: .Normal)
        myButtonStop.setTitle("停止", forState: .Normal)
        
        // コーナーの半径
        myButtonStart.layer.cornerRadius = 20.0
        myButtonStop.layer.cornerRadius = 20.0
        
        // ボタンの位置を指定
        myButtonStart.layer.position = CGPoint(x: self.view.bounds.width/2 - 70, y:self.view.bounds.height-50)
        myButtonStop.layer.position = CGPoint(x: self.view.bounds.width/2 + 70, y:self.view.bounds.height-50)
        
        
        // イベントを追加
        myButtonStart.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        myButtonStop.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加
        self.view.addSubview(myButtonStart);
        self.view.addSubview(myButtonStop);
        
     }


    //
    // ボタンイベント
    //
    func onClickMyButton(sender: UIButton){
        
        if( sender == myButtonStart ){
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            
            // フォルダ
            let documentsDirectory = paths[0] as String
            
            // ファイル名
            let filePath : String? = "\(documentsDirectory)/test.mp4"
            
            // URI
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
            
            // 録画開始
            myVideoOutput.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
        } else if ( sender == myButtonStop ){
            myVideoOutput.stopRecording()
        }
        
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        //AssetsLibraryを生成する
        let assetsLib = ALAssetsLibrary()
        
        //動画のパスから動画をフォトライブラリに保存する
        assetsLib.writeVideoAtPathToSavedPhotosAlbum(outputFileURL, completionBlock: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

