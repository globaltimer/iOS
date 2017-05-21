
import UIKit

class TeamSalmonMemberListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let teamMemberList = ["creaaa", "HoNKoT", "Saayaman", "Yoooo410"]
    
    override func viewDidLoad() {
        
        tableView.delegate   = self
        tableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    

    
    /* delegate */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMemberList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberlist", for: indexPath) as! TeamMemberTableViewCell
        
        cell.selectionStyle = .none
        
        cell.githubName.text = teamMemberList[indexPath.row]
        
        cell.moveToGithubButton.tag = indexPath.row
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    
    @IBAction func githubButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toGithub", sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! TeamMemberGithubViewController
        
        if let button = sender as? UIButton {
            vc.teamMemberURL = teamMemberList[button.tag]
        }
    }
}
