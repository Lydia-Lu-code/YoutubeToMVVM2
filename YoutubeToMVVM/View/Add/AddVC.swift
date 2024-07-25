import UIKit
import Photos

class AddVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddVC viewDidLoad 被呼叫了")

        // 檢查相簿許可權並顯示照片選擇器
        checkPhotoLibraryPermission()
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // 如果已授權，顯示照片選擇器
            showPhotoPicker()
        case .denied, .restricted:
            // 如果被拒絕或受限制，提示用戶開啟設置中的權限
            print("AddVC 相簿訪問權限已被拒絕或受限制。請在設置中啟用相簿訪問權限。")
        case .notDetermined:
            // 如果尚未決定，向用戶請求權限
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.showPhotoPicker()
                    } else {
                        print("AddVC 用戶未授予相簿訪問權限。")
                    }
                }
            }
        @unknown default:
            fatalError("AddVC 意外情況發生，無法處理。")
        }
    }
    
    func showPhotoPicker() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension AddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 獲取選擇的照片
        if let pickedImage = info[.originalImage] as? UIImage {
            // 在這裡使用選擇的照片進行後續處理
            print("Add 成功選擇了照片")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
