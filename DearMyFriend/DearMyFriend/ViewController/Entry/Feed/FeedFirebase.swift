//
//  FeedFirebase.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class MyFirestore {
    
    let collectionUsers = "Users"
    let collectionInfo = "Info"
    let collectionFeed = "Feeds"
    
    func getCurrentUser() -> String? {
        if let user = Auth.auth().currentUser {
            print("getCurrentUser : \(type(of: user))")
            return user.uid
        } else {
            print("not login")
            return nil
        }
    }
    
    private var documentListener: ListenerRegistration? // 데이터 변경 이벤트를 수신하기 위한 리스너의 등록과 해제를 관리하는 역할. (데이터의 실시간 업데이트)
    
    // 해당되는 ID의 데이터를 구독 및 해당 데이터에 대한 변경 사항 실시간 모니터링 - 아직 기능을 잘 모르겠다.
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
    
    //이거 참고해서 만들면됨
    func saveUserInfo(userData: UserData, completion: ((Error?) -> Void)? = nil) {
        let collectionPath = "\(collectionUsers)/\(userData.id)/\(collectionInfo)" //Users/_zerohyeon/Info
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
    
    // 리스너 제거
    func removeListener() {
        documentListener?.remove()
    }
    
    // MARK: Create
//    func saveUserFeed(feedData: FeedData, completion: ((Error?) -> Void)? = nil) {
//        // Feed/Feed UID
//        let collectionPath = "\(collectionFeed)" // Feed collection
//        let collectionListener = Firestore.firestore().collection(collectionPath)
//
//        guard let dictionary = feedData.asDictionary else { // Firestore에 저장 가능한 형식으로 변환할 수 잇는 dictionary
//            print("decode error")
//            return
//        }
//        // document : 현재 시간
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 표시 형식을 원하는 대로 설정
//
//        let now = Date() // 현재 시간 가져오기
//        let formattedDate = dateFormatter.string(from: now) // 형식에 맞게 날짜를 문자열로 변환
//
//        print("현재 시간: \(formattedDate)")
//
//        //        collectionListener.document("\(formattedDate)").setData(dictionary){ error in // Firestore Collection에 데이터를 추가.
//        collectionListener.document().setData(dictionary){ error in // Firestore Collection에 데이터를 추가.
//            completion?(error)
//        }
//    }
    
    func saveFeed(feedData: FeedModel, completion: ((Error?) -> Void)? = nil) {
        // Feed/Feed UID
        let collectionPath = "\(collectionFeed)" // Feed collection
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        // Firestore에 저장 가능한 형식으로 변환할 수 잇는 dictionary
        guard let dictionary = feedData.asDictionary else {
            print("decode error")
            return
        }
        
        collectionListener.document().setData(dictionary) { error in // Firestore Collection에 데이터를 추가.
            completion?(error)
        }
    }
    
    // MARK: Read
    func getModelFeed(completion: @escaping ([[String: FeedData]]) -> Void) { //} -> [[String: FeedData]] {
        // 계정 순서대로 날짜 순으로 데이터를 받는다.
        // 데이터에 대한 기준은 5일.
        // 전체 사용자들의 게시물이 5일 안에 없을 경우.
        // 추가적으로 5일 동안의 데이터를 더 받아온다.
        // 없는 경우, 이를 계속 반복한다.
        // 최대 30일로 하자.
        var feedAllData: [[String: FeedData]] = [] // key : 업로드 날짜, value : 데이터
        
        // 'Users' collection. 확인
        let collectionListener = Firestore.firestore().collection(collectionUsers)
        
        collectionListener.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let dispatchGroup = DispatchGroup() // 디스패치 그룹 생성
                // Users에 있는 사용자들의 ID 정보 획득
                for document in querySnapshot!.documents {
                    //                    print("등록된 사용자 : \(document.documentID)")
                    dispatchGroup.enter() // 디스패치 그룹 진입 - 작업이 시작될 때마다 내부 카운터가 증가
                    
                    // 사용자 정보에 있는 게시물을 저장한다.
                    collectionListener.document(document.documentID).collection(self.collectionFeed).getDocuments() { (querySnapshot, error) in
                        defer { // defer 내에 코드를 작성하면 해당 블록을 빠져나갈 때 실행됨. - 조건문에서 return이 실행되면 실행됨. 작업이 어떤 이유로 종료되어도 'dispatchGroup.leave()'를 실행 시키기 위해 사용.
                            dispatchGroup.leave() // 디스패치 그룹 이탈
                        }
                        
                        if let error = error {
                            print("error???")
                            print("Error getting documents: \(error)")
                        } else {
                            // 게시물을 정보를 나열한다.
                            for document in querySnapshot!.documents {
                                
                                print("게시물 업로드 날짜 : \(document.documentID)")
                                //                                print("게시물 : \(document.data())")
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                                
                                var feedUploadDate: Date // 게시물의 업로드 날짜를 Date로 바꿈.
                                if let calculatedDate = dateFormatter.date(from: document.documentID) {
                                    // fiveDaysAgo를 사용하여 작업 수행
                                    //                                    print("게시물 업로드 날짜 : \(calculatedDate)")
                                    feedUploadDate = calculatedDate
                                } else {
                                    // 날짜 계산 실패 시 대체 처리 수행
                                    print("날짜 계산 실패")
                                    break
                                }
                                
                                let currentDate = Date() // 현재 날짜
                                var calendar = Calendar.current
                                
                                var fiveDaysAgo: Date
                                if let calculatedDate = calendar.date(byAdding: .day, value: -5, to: currentDate) {
                                    // fiveDaysAgo를 사용하여 작업 수행
                                    //                                    print("5일 전 날짜: \(calculatedDate)")
                                    fiveDaysAgo = calculatedDate
                                } else {
                                    // 날짜 계산 실패 시 대체 처리 수행
                                    print("날짜 계산 실패")
                                    break
                                }
                                
                                // 20231030 Test
                                /*
                                 // 업로드 날짜가 게시글 날짜보다 작으면 5일보다 더 과거다! 그러면 필요가 없다!
                                 if feedUploadDate < fiveDaysAgo {
                                 // 다음 항목을 가지고 온나!
                                 continue
                                 } else {
                                 // 5일 내 데이터가 없는 경우
                                 }
                                 */
                                
                                // Firestore 문서의 데이터를 딕셔너리로 가져옴
                                var userFeedId: String = ""
                                var userFeedImage: [String] = []
                                var userFeedPost: String = ""
                                var userFeedLike: [String] = []
                                var userFeedComment: [[String: String]] = []
                                
                                let data = document.data()
                                if let id = data["id"] as? String {
                                    userFeedId = id
                                }
                                
                                if let image = data["image"] as? [String] {
                                    userFeedImage = image
                                }
                                
                                if let post = data["post"] as? String {
                                    userFeedPost = post
                                }
                                
                                if let like = data["like"] as? [String] {
                                    userFeedLike = like
                                }
                                
                                if let comment = data["comment"] as? [[String: String]] {
                                    userFeedComment = comment
                                }
                                
                                let userFeedData = FeedData(id: userFeedId, image: userFeedImage, post: userFeedPost, like: userFeedLike, comment: userFeedComment)
                                feedAllData.append([document.documentID : userFeedData])
                            }
                        }
                    }
                }
                // Users에 저장된 Feed 데이터 중 5일 내의 데이터가 없는 경우
                // 검색 범위를 5일에서 10일로 증가해서 진행.
                // 만약에 계속 없을 경우 30일까지 증가시켜서 확인
                // 계속 없을 경우는 없다고 표시.
                dispatchGroup.notify(queue: .main) {
                    // 시간 순으로 재배열
                    // Date로 변환하고 정렬
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    
                    feedAllData.sort { (dictionary1, dictionary2) in
                        guard let dateString1 = dictionary1.keys.first,
                              let dateString2 = dictionary2.keys.first,
                              let date1 = dateFormatter.date(from: dateString1),
                              let date2 = dateFormatter.date(from: dateString2) else {
                            return false
                        }
                        
                        return date1 > date2
                    }
                    completion(feedAllData)
                }
            }
        }
    }
    
    func getFeed(completion: @escaping ([[String: FeedModel]]) -> Void) { //} -> [[String: FeedData]] {
//        var allFeedData: [[String: FeedModel]] = [] // key : 업로드 날짜, value : 데이터
        var resultFeedData: [[String: FeedModel]] = [] // key : Feed ID(Document ID), value : Feed 데이터
        
        // 'Users' collection. 확인
        let collectionListener = Firestore.firestore().collection(collectionFeed)
        
        collectionListener.getDocuments() { (querySnapshot, error) in
            print("querySnapshot:\(querySnapshot)")
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let dispatchGroup = DispatchGroup() // 디스패치 그룹 생성
                // Users에 있는 사용자들의 ID 정보 획득
                for document in querySnapshot!.documents {
                    print("등록된 documentID : \(document.documentID)")
                    dispatchGroup.enter() // 디스패치 그룹 진입 - 작업이 시작될 때마다 내부 카운터가 증가
                    
                    defer { // defer 내에 코드를 작성하면 해당 블록을 빠져나갈 때 실행됨. - 조건문에서 return이 실행되면 실행됨. 작업이 어떤 이유로 종료되어도 'dispatchGroup.leave()'를 실행 시키기 위해 사용.
                        dispatchGroup.leave() // 디스패치 그룹 이탈
                    }
                    
                    // Firestore 문서의 데이터를 딕셔너리로 가져옴
                    var feedUid: String = ""
                    var feedDate: Date = Date()
                    var feedImageUrl: [String] = []
                    var feedPost: String = ""
                    var feedLike: [String] = []
                    var feedLikeCount: Int = 0
                    var feedComment: [[String: String]] = []
                    
                    let data = document.data()
                    print("data: \(data)")
                    if let uid = data["uid"] as? String {
                        feedUid = uid
                    }
                    
                    if let date = data["date"] as? Date {
                        feedDate = date
                    }
                    print("feedDate: \(feedDate)")
                    
                    if let imageUrl = data["imageUrl"] as? [String] {
                        feedImageUrl = imageUrl
                    }
                    
                    if let post = data["post"] as? String {
                        feedPost = post
                    }
                    
                    if let like = data["like"] as? [String] {
                        feedLike = like
                    }
                    
                    if let likeCount = data["likeCount"] as? Int {
                        feedLikeCount = likeCount
                    }
                    
                    if let comment = data["comment"] as? [[String: String]] {
                        feedComment = comment
                    }
                    
                    let feedData = FeedModel(uid: feedUid, date: feedDate, imageUrl: feedImageUrl, post: feedPost, like: feedLike, likeCount: feedLikeCount, comment: feedComment)
                    
                    // document ID를 key값으로 저장.
                    resultFeedData.append([document.documentID : feedData])
                }
                dispatchGroup.notify(queue: .main) {
                    // 받아온 데이터를 날짜순으로 배열
                    resultFeedData.sort { (feedData1, feedData2) in
                        guard let date1 = feedData1.values.first?.date,
                              let date2 = feedData2.values.first?.date else {
                            return false
                        }
                        
                        return date1 > date2
                    }
                    
                    completion(resultFeedData)
                }
            }
        }
    }
    
    // MARK: Update
    func updateFeedLikeData(documentID: String, updateFeedData: FeedModel, completion: ((Error?) -> Void)? = nil) {
        print("updateFeedLikeData")
        
        let collectionPath = "\(collectionFeed)" // Feeds/Document ID
        let collectionListener = Firestore.firestore().collection(collectionPath)
        print("collectionListener: \(collectionListener)")
        
        guard let dictionary = updateFeedData.asDictionary else { // Firestore에 저장 가능한 형식으로 변환할 수 있는 dictionary
            print("decode error")
            return
        }
        
        collectionListener.document("\(documentID)").setData(dictionary){ error in // Firestore Collection에 데이터 변경.
            completion?(error)
        }
    }
    
    // MARK: Delete
}
