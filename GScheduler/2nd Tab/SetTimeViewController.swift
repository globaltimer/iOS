
import UIKit
import RealmSwift


class SetTimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum AdjustTimeType {
        case goBack
        case ahead
        case none
        case timePicker
    }
    
    
    // ピンされた都市のID。 -1 = isSelectedな都市が1件もなく、テーブルセルが一行もない状態
    var pinedCityCell = -1

    // タイム調整バフ・デバフ
    // var adjustTimeStat = 0
    
    
    // GMT標準時刻
    var fixedTime: Date! = Date() {
        
        didSet {
            print("変わったw")
        }
        
    }
    
    var realm: Realm! // = try! Realm()
    
    var cities: Results<City>!
    //  = try! Realm().objects(City.self).filter("isSelected == true").sorted(byKeyPath: "orderNo", ascending: true)
    
    
    /* UI Components */
    @IBOutlet weak var cityNameLabel:  UILabel!
    @IBOutlet weak var MDYLabel:       UILabel!
    @IBOutlet weak var timeLabel:      UILabel!
    @IBOutlet weak var timeAheadLabel: UILabel!
    
    @IBOutlet weak var tableView:      UITableView!
    
    @IBOutlet weak var adjustTimeBeforeLabel: UILabel!
    @IBOutlet weak var adjustTimeNowLabel:    UILabel!
    @IBOutlet weak var adjustTimeAheadLabel:  UILabel!
    
    
    @IBAction func adjustTimeBeforeButton(_ sender: Any) {
        
        self.fixedTime = Date.init(timeInterval: -1800, since: self.fixedTime)
        renewAllTimeLabels(adjustType: .goBack)
    }
    
    
    @IBAction func adjustTimeAheadButton(_ sender: Any) {
        self.fixedTime = Date.init(timeInterval: 1800, since: self.fixedTime)
        renewAllTimeLabels(adjustType: .ahead)
    }

    
    func renewAllTimeLabels(adjustType: AdjustTimeType) {
        
        print("")
        
        if cities.isEmpty {
            print("なにもしない")
            return
        }
        
        /*
        switch adjustType {
            case .goBack:
                adjustTimeStat -= 1
            case .ahead:
                adjustTimeStat += 1
            case .none, .timePicker:
                adjustTimeStat += 0
        }
        */
        
        /*
        print("バフレベル: \(adjustTimeStat)")
        
        let bef30 = 60 * 30 * (adjustTimeStat-1)
        let new   = 60 * 30 * (adjustTimeStat+0)
        let aft30 = 60 * 30 * (adjustTimeStat+1)
        */
        
        
        let before30m = Date(timeInterval: TimeInterval(-1800), since: fixedTime)
        let newtral   = Date(timeInterval: TimeInterval(0),   since: fixedTime)
        let after30m  = Date(timeInterval: TimeInterval(1800), since: fixedTime)
        
        
        MDYLabel.text = DateUtils.stringFromDate(
            date: newtral,
            format: "",
            tz: NSTimeZone(name: cities[pinedCityCell].timeZone) as! TimeZone
        )
        
        
        timeLabel.text = DateUtils.stringFromDate(
            date: newtral,
            format: "HH:mm",
            tz: NSTimeZone(name: cities[pinedCityCell].timeZone) as! TimeZone
        )
        
        
        adjustTimeBeforeLabel.text = DateUtils.stringFromDate(
            date: before30m,
            format: "HH:mm",
            tz: NSTimeZone(name: cities[pinedCityCell].timeZone) as! TimeZone
        )
        
        
        adjustTimeNowLabel.text = DateUtils.stringFromDate(
            date: newtral,
            format: "HH:mm",
            tz: NSTimeZone(name: cities[pinedCityCell].timeZone) as! TimeZone
        )
        
        
        adjustTimeAheadLabel.text = DateUtils.stringFromDate(
            date: after30m,
            format: "HH:mm",
            tz: NSTimeZone(name: cities[pinedCityCell].timeZone) as! TimeZone
        )
        
        
        if adjustType == .none {
            timeAheadLabel.text = "now"
            // テーブル再描画
            tableView.reloadData()
            return
        }
        
        
        // オプショナルチェーンで関数実行すると、返り値が非オプショナルでもオプショナルになるんやね...
        // let diff = fixedTime?.timeIntervalSince(self.GMT)
        
        
        var diff = self.fixedTime.timeIntervalSinceNow
        
        
        if -30 <= diff && diff < 30 {
            timeAheadLabel.text = "now"
            // テーブル再描画
            tableView.reloadData()
            return
        }
        
        
        
        let adjustSec = diff >= 0 ? 30.0 : -30.0 // ±30秒の修正
        diff += adjustSec
        
        
        
        let sec  = Int(diff)   // 秒
        let s = sec % 60
        
        // let min = (sec - s) / 60 % 60
        let min = (sec - s) / 60 % 60
        
        let hour = (((sec - s - min * 60) / 3600) % 3600) % 24
        let day = abs(sec) > 86400 ? abs(sec) / 86400 : 0
        
        print("\(day)日 \(hour)時間 \(min)分 ")
        
        
        let minusOrPlus  = diff >= 0 ? "+ " : "- "
        let diffDay      = "\(day)day "
        let diffHour     = "\(abs(hour)):"
        let diffMinutes  = String(format: "%02d", abs(min))
        let pastOrFuture = diff >= 0 ? " in the future" : " in the past"

        timeAheadLabel.text = minusOrPlus + diffDay + diffHour + diffMinutes + pastOrFuture

        
        
        // テーブル再描画
        tableView.reloadData()
    }
    
    
    
    ////////////////////
    // MARK: Life Cycle
    ////////////////////
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //
        tableView.delegate = self
        tableView.dataSource = self
        
        // Realmのパス
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        realm = try! Realm()
        
        /*
        let btn = UIBarButtonItem()
        btn.image = UIImage(named: "info2.png")?
                    .resizeUIImage(width: 24, height: 24)
                    .withRenderingMode(.alwaysOriginal)
        
        btn.style = .plain
        btn.action = #selector(SetTimeViewController.showCredit)
        btn.target = self
 
        self.navigationItem.setLeftBarButton(btn, animated: true)
 
        */
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cities = realm.objects(City.self).filter("isSelected == true").sorted(byKeyPath: "orderNo", ascending: true)
        
        self.fixedTime = Date()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let ud = UserDefaults.standard
        if ud.object(forKey: "pinedCityCell") != nil {
            pinedCityCell = ud.integer(forKey: "pinedCityCell")
            print("データあり！ pinedCityCell は \(pinedCityCell)")
        }
        
        // ↓のreloadは、↑のUserDefaultを呼んだ後でないとダメ
        tableView.reloadData()
        
        
        // ラベルに表示する内容は、 viewWillAppearだと、早すぎる。こっちに書かないとだめ。
        if !cities.isEmpty {
            let pin = "\u{1F4CC} "
            cityNameLabel.text = pin + cities[pinedCityCell].name.uppercased()
        }

        
        // adjustTimeStat = 0
        
        renewAllTimeLabels(adjustType: .none)
        
    }
    
    
    ///////////////////
    // MARK: Table View
    ///////////////////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // case 1: バフ・デバフ != 0
        
        /*
        if adjustTimeStat != 0 {
            
            let interval = 60 * 30 * (adjustTimeStat+0)
            let newtral = Date(timeInterval:  TimeInterval(interval), since: self.fixedTime)
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SetTimeViewCell
            
            cell.cityNameLabel.text = cities[indexPath.row].name.uppercased()
            
            
            cell.yearAndMonthLabel.text = DateUtils.stringFromDate(
                date: newtral,
                format: "",
                tz: NSTimeZone(name: cities[indexPath.row].timeZone) as! TimeZone
            )
            
            
            cell.timeLabel.text = DateUtils.stringFromDate(
                date: newtral,
                format: "HH:mm",
                tz: NSTimeZone(name: cities[indexPath.row].timeZone) as! TimeZone
            )
            
            //cell.timeLabel.textColor = UIColor(red:0.22, green:0.62, blue:0.67, alpha:1.0)
            
            cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            
            return cell
            
        } // 特別時のセル設定 完了
        */
        
        
        // case 2: バフ・デバフ == 0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SetTimeViewCell
        
        cell.cityNameLabel.text = cities[indexPath.row].name.uppercased()
        
        cell.yearAndMonthLabel.text = DateUtils.stringFromDate(
            date: self.fixedTime,
            format: "",
            tz: NSTimeZone(name: cities[indexPath.row].timeZone) as! TimeZone
        )

        cell.timeLabel.text = DateUtils.stringFromDate(
            date: self.fixedTime,
            format: "HH:mm",
            tz: NSTimeZone(name: cities[indexPath.row].timeZone) as! TimeZone
        )

        cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)

        return cell
    }
    
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) ->UITableViewCellEditingStyle {
        
        if tableView.isEditing {
            return .delete
        } else {
            return .none
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // 並び替え可能なセルの指定(今回は"すべて")
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // セルをdeleteするときの処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let delatingCity = cities[indexPath.row]
            
            try! realm.write {
                delatingCity.isSelected = false
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == pinedCityCell {
            return 0
        }
        return 75
    }
    
    

    @IBAction func tap(_ sender: UIButton) {
        
        let title = ""
        let message = "\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        let datePicker = UIDatePicker()
        alert.view.addSubview(datePicker)
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
            
            // Step 1: renew model
            self.fixedTime = datePicker.date
            
            // Step 2: renew view
            self.renewAllTimeLabels(adjustType: .timePicker)
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    /* target action */
    
    /*
    func showCredit() {

        let sb = self.storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "credit") as! CreditScrollController
        self.present(vc, animated: true, completion: nil)
    }
    */
    
}





