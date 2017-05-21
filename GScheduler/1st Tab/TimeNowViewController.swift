
import UIKit
import RealmSwift


class TimeNowViewController: UIViewController {
    
    var GMT: Date!
    
    var realm: Realm!
    var cities: Results<City>!
    
    // ピンされたcityのセル番号
    var pinedCityCell = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    ///////////////////
    // MARK: Life Cycle
    ///////////////////
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Realmのパス
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        realm = try! Realm()
        
        cities = realm.objects(City.self).filter("isSelected == true").sorted(byKeyPath: "orderNo", ascending: true)
        
        
        let ud = UserDefaults.standard
        if ud.object(forKey: "pinedCityCell") != nil {
            pinedCityCell = ud.integer(forKey: "pinedCityCell")
            print("データあり！ pinedCityCell は \(pinedCityCell)")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        

        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(
        [NSFontAttributeName: UIFont(name: "quicksand", size: 18) as Any],
            for: .normal)

        
        // 初回起動時のみ
        if cities.count == 0 { initialEnrollCities() }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        GMT = Date()
        
        cities = realm.objects(City.self).filter("isSelected == true").sorted(byKeyPath: "orderNo", ascending: true)
        
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // ビュー消滅時、編集モードを解除しているけど、ボタンの設定が解除されない
        tableView.isEditing = false
        
        // 現在のピンされた都市を保存
        let ud = UserDefaults.standard
        ud.set(pinedCityCell, forKey: "pinedCityCell")
        ud.synchronize()
    }

    
    @IBAction func rightButtonTapped(_ sender: Any) {
    
        let vc = storyboard?.instantiateViewController(withIdentifier: "cityTable")
        
        if let vc = vc {
            self.present(vc, animated: true, completion: nil)
        }
    }
}


extension TimeNowViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TimeNowViewCell
        
        cell.cityNameLabel.text = cities[indexPath.row].name.uppercased()
        
        if indexPath.row == pinedCityCell {
            let a = "\u{1F4CC} "
            cell.cityNameLabel.text = a + cities[indexPath.row].name.uppercased()
        }
        
        
        cell.DayYearLabel.text  = DateUtils.stringFromDate(
            date: GMT,
            format: "",
            tz: NSTimeZone(name: cities[indexPath.row].timeZone)!
        )
        
        
        cell.timeLabel.text = DateUtils.stringFromDate(
            date: GMT,
            format: "HH:mm",
            tz: NSTimeZone(name: cities[indexPath.row].timeZone)!
        )
        
        cell.timeLabel.kern(kerningValue: 2)
        
        cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        
        
        if isEditing == true {
            cell.timeLabel.isHidden = true
        } else {
            cell.timeLabel.isHidden = false
        }
        
        return cell
    }
    
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) ->UITableViewCellEditingStyle {
        return tableView.isEditing ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 並び替え可能なセルの指定(今回は"すべて")
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルの並び替えが発動した時の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath == destinationIndexPath { return }
        
        try! realm.write {
            
            print("ターゲットのセル: \(sourceIndexPath.row)")
            print("移動先: \(destinationIndexPath.row)")
            
            let indexFrom = sourceIndexPath.row
            let indexTo   = destinationIndexPath.row
            
            for city in cities {
                
                // case1: from > to(上に行く場合)
                if indexFrom > indexTo {
                    
                    // なにも処理せず次のセルの判定へ
                    if indexFrom < city.orderNo {
                        print("\(city.name)はスルーで。")
                        continue
                    }
                    
                    // もうひとつ、
                    if city.orderNo < indexTo {
                        print("\(city.name)はスルーで。")
                        continue
                    }
                    
                }
                
                // case2: from < to(下に行く場合)
                if indexFrom < indexTo {
                    // なにも処理せず次のセルの判定へ
                    if indexFrom > city.orderNo {
                        print("\(city.name)はスルーで。")
                        continue
                    }
                    
                    // もうひとつ、
                    if indexTo < city.orderNo {
                        print("\(city.name)はスルーで。")
                        continue
                    }
                }
                
                let tmp = city.orderNo
                
                if city.orderNo < indexFrom {
                    city.orderNo += 1
                } else if city.orderNo > indexFrom {
                    city.orderNo -= 1
                } else if city.orderNo == indexFrom {
                    city.orderNo = indexTo
                }
                
                print("\(city.name)は、\(tmp)から \(city.orderNo)に 移動しました")
            }
            
            // 文字のピンを再設定するためだ、致し方ない。。
            tableView.reloadData()
        }
    }
    
    
    // セルをdeleteするときの処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let tmp = pinedCityCell
            
            // pinedCityCellの振り直し
            if indexPath.row > pinedCityCell {
            
            }
                
            else if indexPath.row == pinedCityCell {
                if indexPath.row != 0 {
                    pinedCityCell -= 1
                }
            }
                
            else if indexPath.row  < pinedCityCell {
                pinedCityCell -= 1
            }
            
            print("ピン都市が、\(tmp) から \(pinedCityCell)になりました")
            
            try! realm.write {
                
                for city in cities {
                    
                    if city.orderNo < indexPath.row {
                        // 何もなし
                        print("\(city.name)は なにもなし！")
                    } else if city.orderNo > indexPath.row {
                        city.orderNo -= 1
                        print("\(city.name)の orderNoが \(city.orderNo)に なった！")
                    } else if city.orderNo == indexPath.row {
                        city.orderNo = -1
                        city.isSelected = false
                        print("\(city.name)が 削除！")
                    }
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        tableView.isEditing = editing
        
        for cell in tableView.visibleCells {
            (cell as? TimeNowViewCell)?.timeLabel.isHidden = tableView.isEditing ? true : false
        }
    }
    
    
    func initialEnrollCities() {
        
        var citiesAry: [City] = []
        
        let csvFilePath = Bundle.main.path(forResource: "CityNameSeed", ofType: "csv")
        
        let csvStringData = try! String(contentsOfFile: csvFilePath!, encoding: String.Encoding.utf8)
        
        var id = 0
        
        // csvを1行ずつ読み込む
        csvStringData.enumerateLines{ (line, stop) in
            
            // カンマ区切りで分割
            let cityDataArray = line.components(separatedBy: ",")
            citiesAry.append(
                City(id: id, name: cityDataArray[0], timeZone: cityDataArray[1], isSelected: false)
            )
            id += 1
        }
        
        
        try! realm.write {
            for city in citiesAry {
                self.realm.add(city, update: true)
                print("\(city.name)")
            }
        }
        
        // 都市の初期設定(いくつかの都市をあらかじめプリセット)
        setInitCities()
        
    } // 初期化処理
    
    
    func setInitCities() {
        
        try! realm.write {
            
            var dynamicOrderNo = 0
            
            var localTimeZoneName: String {
                return TimeZone.current.identifier
            }
            
            // 端末の現在位置の都市のID
            let currentCityID = realm.objects(City.self).filter("timeZone == '\(localTimeZoneName)'").first?.id
            
            // 端末のタイムゾーンをもとにしたプリセット
            if let currentCityID = currentCityID {
                realm.create(City.self, value: ["id": currentCityID, "isSelected": true, "orderNo": dynamicOrderNo], update: true)
                dynamicOrderNo += 1
            }
            
            if currentCityID != 201 {
                // 東京
                realm.create(City.self, value: ["id": 201, "isSelected": true, "orderNo": dynamicOrderNo], update: true)
                dynamicOrderNo += 1
            }
            
            if currentCityID != 202 {
                // ナイロビ
                realm.create(City.self, value: ["id": 202, "isSelected": true, "orderNo": dynamicOrderNo], update: true)
                dynamicOrderNo += 1
            }
            
            if currentCityID != 108 {
                // バンクーバー
                realm.create(City.self, value: ["id": 108, "isSelected": true, "orderNo": dynamicOrderNo], update: true)
            }
        }
    }
}


extension TimeNowViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ピン都市を更新
        pinedCityCell = indexPath.row
        
        tableView.reloadData()
    }
}


extension UILabel {
    
    func kern(kerningValue: CGFloat) {
        
        self.attributedText = NSAttributedString(
            string: self.text ?? "",
            attributes: [NSKernAttributeName: kerningValue,
                         NSFontAttributeName: font,
                         NSForegroundColorAttributeName: self.textColor
            ]
        )
    }
}
