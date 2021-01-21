//
//  EditProfileViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/21.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos
import Firebase
import FirebaseDatabase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editIDTextField: UITextField!
    @IBOutlet weak var editIntroTextField: UITextField!
    
    let picker = UIImagePickerController()
    var localFile = "" // 넘겨줄 사진 파일 url
    
    func settingAlert(){
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String{
            let alert = UIAlertController(title: "Alert", message: "\(appName)이(가) 카메라 접근이 허용되지 않았습니다. 설정화면으로 이동하시겠습니까?", preferredStyle:  .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default){ (action) in
                //
            }
            let confirmAction = UIAlertAction(title: "확인", style: .default){ (action) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            //
        }
    }


    @IBAction func addImage(_ sender: Any) {
        let alert =  UIAlertController(title: "사진을 등록하세요!", message: " ", preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        switch PHPhotoLibrary.authorizationStatus(){
        case .denied:
            settingAlert()
        case .restricted:
            break
//        case .limited:
            
        case .authorized:
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ state in
                if state == .authorized{
                    DispatchQueue.main.async{
                        alert.addAction(library)
                        alert.addAction(camera)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
        default:
            break
        }

//        alert.addAction(library)
//        alert.addAction(camera)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)

    }
    
    // picker = UIImagePickerController
    // 사진앨범을 누르면 picker의 소스타입을 사진 라이브러리로
    // 카메라를 누르면 소스타입을 카메라로 지정
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else{
            print("Camera not available")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }

}

extension EditProfileViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            userImage.image = image
        }
        let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as? NSURL
        let imageName=imageUrl?.lastPathComponent//파일이름
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let photoURL = NSURL(fileURLWithPath: documentDirectory)
        print("photoURL\(photoURL)")
        
//        let localPath = photoURL.appendingPathComponent(imageName!)//파일경로
//        let data=NSData(contentsOf: imageUrl as! URL)!
//        print("lastURL:\(localPath!.path)")
        //localFile = String(describing: localPath)
//        var str = "file:///"
//        let fileURL = "\(localPath!.path)"
//        str.append(fileURL)
//        localFile = str
        //localFile = String(decoding: localPath!, as: UTF8.self)
//        print("localFile:"+localFile)
        dismiss(animated: true, completion: nil)

    }
}