import Foundation
import UIKit
import FirebaseFirestore

class AddPostViewController: UIViewController {
    
    // MARK: Properties
    let addPostView: AddPostView = .init(frame: .zero)
    let myFirestore = MyFirestore() // Firebase
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        // NavigationBar 숨김.
    //        navigationController?.isNavigationBarHidden = true
    //    }
    
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
    
    func uploadButtonTapped() {
        let feedId: String = "현재 로그인된 ID"
        let feedImage: [String] = ["여러 이미지"]
        let feedPost: String = addPostView.postTextView.text
        let feedLike: [String] = [""] // 처음에 생성할 때는 좋아요 수가 없음.
        let feedComment: [[String: String]] = [[:]] // 처음에 생성할 때는 댓글이 없음.
        
        let data = FeedData(id: feedId, image: feedImage, post: feedPost, like: feedLike, comment: feedComment)
        myFirestore.saveUserFeed(feedData: data) { error in
            print("error: \(error)")
        }
        dismiss(animated: true)
    }
    
    func imageViewTapped(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
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
