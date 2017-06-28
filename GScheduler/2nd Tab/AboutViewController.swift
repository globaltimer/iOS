
import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension AboutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 110 }
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // section = 0
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutApp")!
            return cell
        }
        
        // section = 1
        let cell = tableView.dequeueReusableCell(withIdentifier: "License")!
        if indexPath.row == 0 { cell.textLabel?.text = "Our team" }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}


extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "toTeamMember", sender: nil)
            }
        }
    }
}

