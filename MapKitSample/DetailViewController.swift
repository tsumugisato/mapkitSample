
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
    
    @IBAction func delete() {
        let query = NCMBQuery(className: "Map")
        query?.whereKey("text", equalTo: nextText!)
        print(postTextField.text,"kkkkk")
        // 削除したいデータに対して、削除を実行
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                print(result,"ppppp")
                let text = result as! [NCMBObject]
                // 配列の最初の要素(0番目)を表示
                print(text,"llllll")
                let textObject = text[0]
                textObject.deleteInBackground { (error) in
                    if error != nil {
                        // エラーが発生した場合
                        print(error)
                    } else {
                        // 削除に成功した場合、元の画面に戻る(NavigationControllerにおける戻り方)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            //ここに処理
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    
                }
                
            }
            
        })
    }
                                       
}
