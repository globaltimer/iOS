
import Foundation
import UIKit

class TeamMemberGithubViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var teamMemberURL: String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("")
        
        let url = URL(string: "https://github.com/" + teamMemberURL)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
    }

}
