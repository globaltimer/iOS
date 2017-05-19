
import UIKit

class TimeNowViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var DayYearLabel:  UILabel!
    @IBOutlet weak var timeLabel:     UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    }
}
