//
//import UIKit
//import RealmSwift
//
//
//class RegisteredTaskTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
//    
//
//    // GMT標準時刻
//    var GMT: Date = Date()
//    
//    let realm = try! Realm()
//    
//    let cities = try! Realm().objects(StoredCity.self).filter("isSelected == true").sorted(byKeyPath: "id", ascending: true)
//    
//    let task = try! Realm().objects(Task.self).sorted(byKeyPath: "id", ascending: true)
//    
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var pickerView: UIPickerView!
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //
//        tableView.delegate = self
//        tableView.dataSource = self
//        //
//        pickerView.delegate = self
//        pickerView.dataSource = self
//
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(animated)
//        //
//        
//        print(task)
//        
//        tableView.reloadData()
//        pickerView.reloadAllComponents()
//        
//        
//    }
//    
//    
//    /////////////////
//    // Picker View //
//    /////////////////
//    
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return task.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        // let id = row
//        
//        //let title = realm.objects(Task.self).filter("id = '\(id)'")
//        
//       return task[row].name
//        
////        return "unko"
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//        print("hoge")
//        
//        // ここで基準となるDateを切り替える(テーブルに反映させるために)
//        GMT = task[row].date
//        
//        tableView.reloadData()
//        
//    }
//    
//    
//    ////////////////
//    // Table View //
//    ////////////////
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cities.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    
//        var formatter = DateFormatter()
//        
//        // フォーマッタの初期設定
//        setConfigToFormatter(fm: &formatter, cellIdx: indexPath.row)
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RegisteredTaskTableViewCell
//        
//        cell.cityNameLabel.text = cities[indexPath.row].name
//        
//        cell.timeLabel.text = formatter.string(from: GMT)
//        
//        if indexPath.row % 2 == 0 {
//            
//            cell.backgroundColor = UIColor(hue: 0.61, saturation: 0.09, brightness: 0.99, alpha: 1.0)
//            
//        } else {
//            cell.backgroundColor = UIColor.white
//        }
//        
//        return cell
//    }
//    
//    
//    // フォーマッタの初期設定
//    func setConfigToFormatter(fm: inout DateFormatter, cellIdx: Int) {
//        
//        // タイムゾーン
//        let timeZone = cities[cellIdx].timeZone
//        
//        fm.dateFormat = "MM/dd HH:mm"
//        
//        fm.timeZone = TimeZone(abbreviation: timeZone)
//        
//    }
//}
