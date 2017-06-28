//
//import UIKit
//
//class LicenseDetailViewController: UIViewController {
//
//
//    @IBOutlet weak var myLicense: UILabel!
//    @IBOutlet weak var myHeight: NSLayoutConstraint!
//    
//    
//    var name    = ""
//    var license = ""
//    
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        self.title = name
//        self.myLicense.text = license
//        
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        
//        let frame = CGSize(width: self.myLicense.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
//        
//        myHeight.constant = myLicense.sizeThatFits(frame).height + 900
//        
//        view.layoutIfNeeded()
//    }
//    
//}
//
//
