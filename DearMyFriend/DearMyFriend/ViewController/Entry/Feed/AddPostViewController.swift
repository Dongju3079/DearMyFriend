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
        
        self.addPostView.imageCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // CommentViewController 클래스 내에서 viewWillAppear(_:) 함수 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 키보드 관련 Notification 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // CommentViewController 클래스 내에서 viewWillDisappear(_:) 함수 추가
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 화면이 나갈 때 Notification 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { // 현재동작하는 키보드의 frame을 받아옴.
            return
        }
        self.addPostView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        print("hide")
        self.addPostView.transform = .identity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        // 추후 현재 로그인된 ID를 받아와서 닉네임 표시
        let currentUID: String = MyFirestore().getCurrentUser() ?? "" // 사용자 ID 확인
        // 사용자 UID의 username 확인.
        addPostView.userNicknameLabel.text = "_zerohyeon"
        
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

    func uploadButtonTapped() {
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
        let feedLike: [String] = ["pikachu", "ironMan"] // 처음에 생성할 때는 좋아요 수가 없음.
        let feedLikeCount: Int = 0 // 초기 생성 시 좋아요 수는 0
        let feedComment: [[String: String]] = [["A":"a"], ["B":"b"]] // 처음에 생성할 때는 댓글이 없음.
        
        // Firebase Storage에 이미지 업로드
        // Firebase Storage 인스턴스, 스토리지 참조 생성
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let group = DispatchGroup() // Dispatch Group 생성
        // 선택한 이미지 전체 확인
        for image in selectedImages.enumerated() {
            group.enter() // Dispatch Group 진입
            
            let savePath = "Feed/\(feedId)/\(formattedDate)/image\(image.offset).jpg" // Firebase Storage 이미지 업로드 경로
            let imageRef = storageRef.child(savePath)
            
            if let imageData = image.element.jpegData(compressionQuality: 0.8) { // JPEG형식의 데이터로 변환. compressionQuality 이미지 품질(0.8 일반적인 값)
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
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
                            group.leave()
                        }
                    }
                }
            }
        }
        
        // 모든 이미지 업로드 및 URL 저장 작업 완료시까지 대기
        group.notify(queue: .main) {
            let data = FeedData(id: feedId, image: feedImage, post: feedPost, like: feedLike, comment: feedComment)
            
            // 현재 시간
            let currentDate = Date()
            print("currentDate: \(currentDate)")
            
            let feedData = FeedModel(uid: feedId, date: currentDate, imageUrl: feedImage, post: feedPost, like: feedLike, likeCount: feedLikeCount, comment: feedComment)
            
            self.myFirestore.saveFeed(feedData: feedData) { error in
                print("error: \(error)")
            }
            
            self.myFirestore.saveUserFeed(feedData: data) { error in
                print("error: \(error)")
            }
            self.dismiss(animated: true)
        }
    }
    
    func imageViewTapped(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10 // 선택한 이미지 수 제한 (옵션)
        
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
        print("selectedImages.count: \(selectedImages.count)")
        
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
        
        var loadedImages: [UIImage] = [] // 이미지를 로드한 배열
        let dispatchGroup = DispatchGroup() // 디스패치 그룹 생성
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter() // 디스패치 그룹 진입
                
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        
                        loadedImages.append(image) // 이미지 로드한 배열에 추가
                    }
                    dispatchGroup.leave() // 디스패치 그룹 이탈
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // 모든 이미지 로드가 완료된 후에 실행됨
            self.selectedImages.append(contentsOf: loadedImages) // 선택한 이미지를 배열에 추가
            
            self.setupCollectionView()
            
            self.addPostView.postImageView.isHidden = true
            self.addPostView.imageCollectionView.isHidden = false
            self.addPostView.pageControl.isHidden = false
        }
    }
}
