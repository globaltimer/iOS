
import UIKit
import RealmSwift

class CityListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var realm:  Realm!
    var cities: Results<City>!
    var filteredCities: [City] = []
    
    // "A" ~ "Z" の配列
    let sections = (65...90).map{ String(Character(UnicodeScalar($0)!)) }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.realm = try! Realm()
        self.cities = realm.objects(City.self).sorted(byKeyPath: "name", ascending: true)
        
        tableView.delegate   = self
        tableView.dataSource = self
        searchBar.delegate   = self
        
        searchBar.barTintColor = UIColor(red:0.14, green:0.68, blue:0.73, alpha:1.0)
        
        // searchBarの中の配色
        for subView in searchBar.subviews {
            for secondSubView in subView.subviews {
                if secondSubView.isKind(of: UITextField.self) {
                    secondSubView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0).withAlphaComponent(1)
                }
            }
        }
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont(name: "quicksand", size: 18) as Any],
            for: .normal
        )
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension CityListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        try! realm.write {
            
            if (searchBar.text?.characters.count)! == 0 {
                
                let selectedCN = ((tableView.cellForRow(at: indexPath)) as! CityListViewCell).cityNameLabel.text
                
                let selectedCityName = selectedCN!
                
                let tmp_id = realm.objects(City.self).filter("name == '\(selectedCityName)'").first?.id
                
                let id = tmp_id!
                
                let orderNo: Int
                
                // もしまだユーザーによってaddされていなければ、orderNo付与
                if realm.object(ofType: City.self, forPrimaryKey: id)?.orderNo == -1 {
                    orderNo = realm.objects(City.self).filter("isSelected == true").count
                } else { // 既にaddされている都市がまた選ばれたら、OrderNoはそのまま
                    orderNo = (realm.object(ofType: City.self, forPrimaryKey: id)?.orderNo)!
                }
                
                realm.create(City.self, value: ["id": id, "isSelected": true, "orderNo": orderNo], update: true)
                
                print("\(String(describing: cities.filter("id == \(id)").first?.name)) was enrolled!")
                
            } else {  // フィルタされた状態でセルがクリックされた場合
                
                let id = filteredCities[indexPath.row].id
                
                let orderNo = realm.objects(City.self).filter("isSelected == true").count
                
                realm.create(City.self, value: ["id": id, "isSelected": true, "orderNo": orderNo], update: true)
                
                print("\(filteredCities[indexPath.row].name) was enrolled!")
            }
        }
        
        //閉じる(ナビゲーションバーで遷移してきたなら、こうすれば戻れるんだよ)
        dismiss(animated: true, completion: nil)
        
    }
}


extension CityListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityListViewCell
        
        // リアルタイムサーチ時の挙動 (= searchbarに文字が1文字以上ある)
        if (self.searchBar.text?.characters.count)! > 0 {
            
            // ここが ver 1.0.0のバグの張本人！
            // self.filteredCitiesがemptyの場合があるので、その場合はソッコーリターン！
            guard !self.filteredCities.isEmpty else {
                let cell = cell
                return cell
            }
            
            // この行で a 入れたら、 Out of range きたー！！！
            cell.cityNameLabel.text = self.filteredCities[indexPath.row].name
            
            cell.diffGMTLabel.text = DateUtils.stringFromDate(
                date: Date(),
                format: "ZZZZ",
                tz: NSTimeZone(name: filteredCities[indexPath.row].timeZone)!
            )
            
            if cell.diffGMTLabel.text == "GMT" {
                cell.diffGMTLabel.text = "GMT ±00:00"
            }
            
            return cell
        }
        
        let head_character = sections[indexPath.section]
        
        print("都市のインデックスは、\(head_character)")
        
        let cities = self.cities.filter("name BEGINSWITH '\(head_character)'")
        
        cell.cityNameLabel.text =  cities[indexPath.row].name
        
        cell.diffGMTLabel.text = DateUtils.stringFromDate(
            date: Date(),
            format: "ZZZZ",
            tz: NSTimeZone(name: cities[indexPath.row].timeZone)!
        )
        
        
        if cell.diffGMTLabel.text == "GMT" {
            cell.diffGMTLabel.text = "GMT ±00:00"
        }
        
        cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        
        return cell
    }
    
    
    // INDEX
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /*
         if (searchBar.text?.characters.count)! > 0 { return 1 }
         return sections.count // 26
         */
        
        return (searchBar.text?.characters.count)! > 0 ? 1 : self.sections.count
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchBar.text?.characters.count)! > 0 {
            let count = filteredCities.count
            return count
        }
        
        let head_character   = self.sections[section]
        let cityStartFromABC = cities.filter("name BEGINSWITH '\(head_character)'")
        
        return cityStartFromABC.count
        
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        // searchBarに文字があればインデックスは表示しない
        if (searchBar.text?.characters.count)! > 0 {
            return nil
        }
        
        // "A" ~ "Z" の配列
        return self.sections //(65...90).map{ String(Character(UnicodeScalar($0)!)) }
    }
    
    
    /// セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (searchBar.text?.characters.count)! > 0 ? nil : self.sections[section]
    }
    
    
    // インデックスリストをタップ時のコールバック
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title:String, at index: Int) -> Int {
        return index
    }
    
}


extension CityListViewController: UISearchBarDelegate {
    
    // テキストフィールド入力開始前に呼ばれる
    // (= フォーカスが当たった時に即発動)
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    // キャンセルボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    // 文字がインプットされたときに発動
    // 未選択(=決定ボタンが押される前)のときに即発動している
    // と同時に、決定したときにも発動する。
    func searchBar(_                  searchBar: UISearchBar,
                   shouldChangeTextIn range:     NSRange,
                   replacementText    text:      String) -> Bool {
        
        self.filteredCities = []
        
        let searchWord = searchBar.text
        
        // 小文字・大文字を無視して検索
        self.filteredCities = self.cities.filter{ $0.name.lowercased().contains((searchWord?.lowercased())!) }
        
        tableView.reloadData()
        
        return true
        
    }
}

