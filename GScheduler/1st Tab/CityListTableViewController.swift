
import UIKit
import RealmSwift

class CityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    var realm: Realm! // = try! Realm()

    var cities: Results<City>!

    var filteredCities: [City] = []
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        realm = try! Realm()

        cities = realm.objects(City.self).sorted(byKeyPath: "name", ascending: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
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
            [NSFontAttributeName: UIFont(name: "quicksand", size: 18) as Any],
            for: .normal
        )
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityListViewCell
        
        // リアルタイムサーチ時の挙動
        if (searchBar.text?.characters.count)! > 0 {
            
            cell.cityNameLabel.text = filteredCities[indexPath.row].name
            
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
        //cell.cityNameLabel.textColor = UIColor(red:0.22, green:0.62, blue:0.67, alpha:1.0)
        
        
        cell.diffGMTLabel.text = DateUtils.stringFromDate(
            date: Date(),
            format: "ZZZZ",
            tz: NSTimeZone(name: cities[indexPath.row].timeZone)!
        )
            
        
        if cell.diffGMTLabel.text == "GMT" {
            cell.diffGMTLabel.text = "GMT ±00:00"
        }
        
        
        //cell.diffGMTLabel.textColor = UIColor(red:0.77, green:0.42, blue:0.42, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)

        return cell
    }
    
    
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
    
    
    ///////////////
    // MARK: Index
    ///////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (searchBar.text?.characters.count)! > 0 {
            return 1
        }
        
        return sections.count // 26だよ
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchBar.text?.characters.count)! > 0 {
            return filteredCities.count
        }
        
        let head_character = sections[section]
        let cityStartFromABC = cities.filter("name BEGINSWITH '\(head_character)'")

        return cityStartFromABC.count
        
    }
    
    var sections = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        // searchBarに文字があればインデックスは表示しない
        if (searchBar.text?.characters.count)! > 0 {
            return nil
        }
        
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    
    /// セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (searchBar.text?.characters.count)! > 0 {
            return nil
        }
        
        print("セクションのタイトル: \(sections[section])")
        return sections[section]
    }
    
    
    // インデックスリストをタップ時のコールバック
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title:String, at index: Int) -> Int {
        return index
    }
    
    
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCities = []
        
        let searchWord = searchBar.text
        
        // 小文字・大文字を無視して検索
        filteredCities = cities.filter{ $0.name.lowercased().contains((searchWord?.lowercased())!) }
        
        print("まず、filteredCitiesのフィルタリングが行われる")
        
        tableView.reloadData()
    }
    */
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        filteredCities = []
        
        // let searchWord = searchBar.text
        
        let searchWord = searchBar.text
        
        
        // 小文字・大文字を無視して検索
        filteredCities = cities.filter{ $0.name.lowercased().contains((searchWord?.lowercased())!) }
        
        print("まず、filteredCitiesのフィルタリングが行われる")
        
        tableView.reloadData()
        
        
        
        return true
        
    }
    
    
    
    
    
    
    
    // テキストフィールド入力開始前に呼ばれる
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
}

