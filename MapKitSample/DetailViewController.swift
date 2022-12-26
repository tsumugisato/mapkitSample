
import UIKit
import NCMB

class DetailViewController: UIViewController {
    
    var nextText : String?
    var nextTitle: String?
    
    var detailTitle = [String]()
    var detailImage = [String]()
    var detailtext = [String]()
    
    @IBOutlet var postTextField : UITextField!
    @IBOutlet var postTextView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextField.text = nextText
        postTextView.text = nextTitle
     
    }
        
}

