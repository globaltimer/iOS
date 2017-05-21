

import UIKit

class TeamMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var githubName: UILabel!
    @IBOutlet weak var moveToGithubButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
