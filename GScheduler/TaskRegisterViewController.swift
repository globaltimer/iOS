//
//import UIKit
//import RealmSwift
//
//
//class TaskRegisterViewController: UIViewController {
//
//    let realm = try! Realm()
//    
//    @IBOutlet weak var taskNameTextField: UITextField!
//    @IBOutlet weak var taskDescTextField: UITextField!
//    @IBOutlet weak var datePicker: UIDatePicker!
//    
//    
//    @IBAction func addButtonTapped(_ sender: AnyObject) {
//        
//        if taskNameTextField.text?.characters.count == 0 {
//            
//            print("なにもせずに終了")
//            
//            dismiss(animated: true, completion: nil)
//            
//            // 有効。なので、↓のように、dismiissのあとにreturnは書かないといけない、ということだ。
//            //print("unko")
//            
//            return
//        }
//        
//        
//        let taskNo = try! Realm().objects(Task.self).count
//        
//        let date = datePicker.date
//                
//        try! realm.write {
//            
//            let task = Task(id: taskNo + 1, name: taskNameTextField.text!, desc: taskDescTextField.text!, date: date)
//
//            self.realm.add(task, update: true)
//            
//            print("\(task.name) was enrolled!")
//        }
//        
//        //Navigation Controllerを取得 →　これ、モーダルだとクラッシュするのでNG。
//        //let nav = self.navigationController!
//        
//        // ダメダメ
//        //nav.popViewController(animated: true)
//        
//        // ので、これを使う
//        dismiss(animated: true, completion: nil)
//    }
//    
//    
//    // フォーマッタの初期設定
//    func setConfigToFormatter(fm: inout DateFormatter) {
//        
////        // タイムゾーン
////        let timeZone = cities[cellIdx].timeZone
////        
////        fm.dateFormat = "MM/dd HH:mm"
//        
////        // タイムゾーンを取得
////        let timeZone = datePicker.timeZone
////        
////        fm.timeZone = TimeZone(abbreviation: TimeZone)
//        
//    }
//
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TaskRegisterViewController.dismissKeyboard))
//        self.view.addGestureRecognizer(tapGesture)
//    }
//    
//    func dismissKeyboard(){
//        // キーボードを閉じる
//        view.endEditing(true)
//    }
//}
