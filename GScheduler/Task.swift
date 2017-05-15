//
//import Foundation
//import RealmSwift
//
//class Task: Object {
//    
//    // 管理用 ID。プライマリーキー
//    dynamic var id = 0
//    
//    dynamic var name: String = ""
//    dynamic var desc: String = ""
//    
//    dynamic var date: Date = Date()
//    
//    /**
//     id をプライマリーキーとして設定
//     */
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//    
//    // Realmオブジェクトにイニシャライザを設定するには、この書き方でないとダメ
//    convenience init(id: Int, name: String, desc: String, date: Date) {
//        
//        self.init()
//        
//        self.id = id
//        self.name = name
//        self.desc = desc
//        self.date = date
//    }
//}
