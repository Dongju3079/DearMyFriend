import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class AddPostViewController: UIViewController {
    
    // MARK: Properties
    let addPostView: AddPostView = .init(frame: .zero)
    let myFirestore = MyFirestore() // Firebase
    
    let db = Firestore.firestore()
    
    // 선택된 이미지 CollectionView
    var selectedImages: [UIImage] = []
    
    private func setupCollectionView() {
        addPostView.imageCollectionView.delegate = self
        addPostView.imageCollectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
        setupAddPostView()
    }
    
    private func setupAddPostView() {
        view.addSubview(addPostView)
        addPostView.translatesAutoresizingMaskIntoConstraints = false
        addPostView.delegate = self
        
        NSLayoutConstraint.activate([
            addPostView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addPostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addPostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addPostView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AddPostViewController: AddPostViewDelegate {
    func cancelButtonTapped() {
        dismiss(animated: true)
    }
    //    let id: String
    //    let image: [String]
    //    let post: String
    //    let like: [String]
    //    let comment: [[String: String]]
    
    func uploadButtonTapped() {
        print("_zerohyeon")
        print("selectedImages: \(selectedImages)")
        
        // document : 현재 시간
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 표시 형식을 원하는 대로 설정

        let now = Date() // 현재 시간 가져오기
        let formattedDate = dateFormatter.string(from: now) // 형식에 맞게 날짜를 문자열로 변환

        print("현재 시간: \(formattedDate)")
        
        let feedId: String = "_zerohyeon"
        var feedImage: [String] = []
        let feedPost: String = addPostView.postTextView.text
        let feedLike: [String] = [""] // 처음에 생성할 때는 좋아요 수가 없음.
        let feedComment: [[String: String]] = [["A":"a"], ["B":"b"]] // 처음에 생성할 때는 댓글이 없음.
        
//        let image = selectedImages[0]
        
        // Firebase Storage에 이미지 업로드
        let storage = Storage.storage()
        let storageRef = storage.reference()
        for image in selectedImages.enumerated() {
            let savePath = "Feed/\(feedId)/\(formattedDate)/image\(image.offset).jpg"
            let imageRef = storageRef.child(savePath)
            
            if let imageData = image.element.jpegData(compressionQuality: 0.8) {
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    print("put")
                    if let error = error {
                        print("이미지 업로드 실패: \(error.localizedDescription)")
                    } else {
                        print("이미지 업로드 성공")
                        
                        // 이미지 다운로드 URL 가져오기
                        imageRef.downloadURL { (url, error) in
                            if let error = error {
                                print("URL 가져오기 실패: \(error.localizedDescription)")
                            } else {
                                if let downloadURL = url?.absoluteString {
                                    // Firestore에 URL 저장
                                    feedImage.append(downloadURL)
                                    print("feedImage: \(feedImage)")
                                }
                            }
                        }
                    }
                }
            }
        }
        print("feedImage: \(feedImage)")
        
        let data = FeedData(id: feedId, image: feedImage, post: feedPost, like: feedLike, comment: feedComment)
        myFirestore.saveUserFeed(feedData: data) { error in
            print("error: \(error)")
        }
        dismiss(animated: true)
    }
    
    func imageViewTapped(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5 // 선택한 이미지 수 제한 (옵션)
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension AddPostViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // page control 설정.
        if scrollView.frame.size.width != 0 {
            let value = (scrollView.contentOffset.x / scrollView.frame.width)
            addPostView.pageControl.currentPage = Int(round(value))
        }
    }
}

extension AddPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(selectedImages.count, "!!!!!!")
        
        addPostView.pageControl.numberOfPages = selectedImages.count
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        print(indexPath.item, "indexPath.item")
        print(selectedImages.count, "selected image count")
        print(selectedImages[indexPath.item], "selected image")
        cell.configure(image: selectedImages[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            addPostView.postImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            addPostView.postImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else {
            return
        }
        print("results: \(results.count)")
        print("results: \(results)")
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        // 선택한 이미지를 배열에 추가
                        self.selectedImages.append(image)
                        // 선택한 이미지를 화면에 표시 (예: 이미지 뷰에 추가)
                        DispatchQueue.main.async {
                            self.setupCollectionView()
                        }
                    }
                }
            }
        }
        
        self.addPostView.postImageView.isHidden = true
        
        self.addPostView.imageCollectionView.isHidden = false
        self.addPostView.pageControl.isHidden = false
    }
}
