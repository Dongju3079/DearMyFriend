//
//  FeedFirebase.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class MyFirestore {
    
    let collectionUsers = "Users"
    let collectionInfo = "Info"
    let collectionFeed = "Feed"
    
    private var documentListener: ListenerRegistration? // 데이터 변경 이벤트를 수신하기 위한 리스너의 등록과 해제를 관리하는 역할. (데이터의 실시간 업데이트)
    
    // 해당되는 ID의 데이터를 구독 및 해당 데이터에 대한 변경 사항 실시간 모니터링
    func subscribe(collection: String, id: String, completion: @escaping (Result<[UserData], FeedFirebaseError>) -> Void) {
        let collectionPath = "\(collectionUsers)/\(id)/\(collection)"
        removeListener() // 이전에 등록된 Firestore 리스너 제거
        let collectionListener = Firestore.firestore().collection(collectionPath) // 사용자 데이터가 있는 Firestore Collection을 참조하는 리스너 설정
        
        documentListener = collectionListener.addSnapshotListener { querySnapshot, error in // 실시간 변경사항 감지.
            guard let querySnapshot = querySnapshot else {
                // 오류 처리
                completion(.failure(FeedFirebaseError.firestoreError(error)))
                return
            }
            // 데이터 변경 이벤트 처리
            // querySnapshot에 접근하여 변경 데이터 접근.
            
            var data = [UserData]()
            // 변경된 document에 따른 반복 작업
            // documentChanges의 type 종류 '.added', '.modified', '.removed'
            querySnapshot.documentChanges.forEach { change in
                switch change.type {
                case .added, .modified:
                    do {
                        if let documentData = try change.document.data(as: UserData.self) as UserData? { // UserData 모델로 디코딩
                            data.append(documentData)
                        }
                    } catch {
                        completion(.failure(.decodedError(error)))
                    }
                default: break
                }
            }
            print("수정된 데이터 : \(data)")
            completion(.success(data))
        }
    }
    
    func saveUserInfo(userData: UserData, completion: ((Error?) -> Void)? = nil) {
        let collectionPath = "\(collectionUsers)/\(userData.id)/\(collectionInfo)"
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        guard let dictionary = userData.asDictionary else { // Firestore에 저장 가능한 형식으로 변환할 수 잇는 dictionary
            print("decode error")
            return
        }
        // document : 사용자의 이름(userData.id)
        collectionListener.document("\(userData.id)").setData(dictionary){ error in // Firestore Collection에 데이터를 추가.
            completion?(error)
        }
    }
    
    func saveUserFeed(feedData: FeedData, completion: ((Error?) -> Void)? = nil) {
        let collectionPath = "\(collectionUsers)/\(feedData.id)/\(collectionFeed)"
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        guard let dictionary = feedData.asDictionary else { // Firestore에 저장 가능한 형식으로 변환할 수 잇는 dictionary
            print("decode error")
            return
        }
        // document : 사용자의 이름(userData.id)
        collectionListener.document("\(feedData.id)").setData(dictionary){ error in // Firestore Collection에 데이터를 추가.
            completion?(error)
        }
    }
    
    // 리스너 제거
    func removeListener() {
        documentListener?.remove()
    }
}
