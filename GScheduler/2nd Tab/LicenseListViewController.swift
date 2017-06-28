//
//import UIKit
//
//class LicenseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    private struct Software {
//        var name:    String
//        var license: String
//    }
//    private var softwares = [Software]()
//    
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        tableView.delegate   = self
//        tableView.dataSource = self
//        
//        // plistからソフトウェア名とライセンス文章を取得
//        guard let path = Bundle.main.path(forResource: "Licenses", ofType: "plist") else {
//            return
//        }
//        
//        guard let items = NSArray(contentsOfFile: path) else {
//            return
//        }
//        
//        for item in items {
//            
//            guard let software = item as? NSDictionary else {
//                continue
//            }
//            
//            guard let name = software["Name"] as? String else {
//                continue
//            }
//            
//            guard let license = software["License"] as? String else {
//                continue
//            }
//            
//            softwares.append(Software(name: name, license: license))
//        }
//    }
//    
//    
//    /* delegate */
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//        self.performSegue(withIdentifier: "PushLicenseDetail", sender: indexPath)
//        
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Software")!
//        
//        cell.textLabel?.text = softwares[indexPath.row].name
//        
//        return cell
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return softwares.count
//    }
//    
//    
//    // navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "PushLicenseDetail" {
//            
//            let vc = segue.destination as! LicenseDetailViewController
//            
//            if let indexPath = sender as? IndexPath {
//                
//                vc.name    = softwares[indexPath.row].name
//                vc.license = softwares[indexPath.row].license
//            }
//        }
//    }
//}
//
