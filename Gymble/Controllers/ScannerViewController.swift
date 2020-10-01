//
//  ScannerViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 30/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import AVFoundation
import UIKit
import Alamofire
import Firebase
class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let rightNow = Date()
    var objectID: String?
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 13
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getObjectID()
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        cancelButtonLayout()
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    private func cancelButtonLayout(){
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let checkInURL = "http://13.233.119.231:3000/checkIn2"
            let currentTime = rightNow.getCurrentTime()
            guard let ID = objectID else {return}
            let parameters: [String: Any] = [
                "qr_code": stringValue,
                "cur_time": currentTime,
                "object_id": ID
            ]
            
            AF.request(checkInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
                response in
                switch (response.result) {
                case .success:
                    if let status = response.response?.statusCode {
                        print(status)
                        print(response.result)
                        print(response)
                        if status == 200{
                            let alert = UIAlertController(title: "Hoorayyy", message: "Check-In successful!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "Yikes!", message: "Something went wrong.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(alert: UIAlertAction!) in self.captureSession.startRunning()}))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    break
                case .failure:
                    print(Error.self)
                    return
                }
            }
        }
    }
    
    func dismissView(){
        dismiss(animated: true)
    }
    
    func getObjectID(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        APIServices.sharedInstance.checkForSlotBooking(date: rightNow.asString(), userID: userID) { (getObjectID) in
            self.objectID = getObjectID.already_booked?._id
        }
    }
    
    func found(code: String) {
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
