
import UIKit
import MapKit
import NCMB


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    var locManager: CLLocationManager!
    
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    
    var detailId = [String]()
    var detailsub = [String]()
    var detailImage = [String]()
    var detailtext = [String]()
    var likes = [Bool]()
    var smileCounts = [Int]()
    var userImages = [String]()
    var userNames = [String]()
    var blockUserIdArray = [String]()
    var nextId : String?
    var nextText : String?
    var nextTitle: String?
    var nextImage: String?
    
    
    
    var new:Bool?
    
    var latitude : Double!
    var longitude : Double!
    var latitudes = [Double]()
    var longitudes = [Double]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
      
        longPressGesRec.delegate = self
        
        loadPin()
        
    }
    
    
    //NCMBから読み込み
    func loadPin() {
        let query = NCMBQuery(className: "Map")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                
            }else {
                self.detailId = []
                
                let objects = result as! [NCMBObject]
                for object in objects{
                    
                    let latitude = object.object(forKey: "latitude") as! Double
                    let longitude = object.object(forKey: "longitude") as! Double
                    
                    // 投稿の情報を取得
                    let text = object.object(forKey: "text") as! String
                    let sub  = object.object(forKey: "subtext") as! String
                    
                    self.detailId.append(object.objectId)
                    self.detailtext.append(text)
                    self.detailsub.append(sub)
                    self.latitudes.append(latitude)
                    self.longitudes.append(longitude)
                    
                }
                
                
                //複数ピンをfor文を回して立てる
                for i in 0...self.detailId.count{
                    
                    if i == self.detailId.count {
                        break
                    }else {
                        var pointAno3 : MKPointAnnotation = MKPointAnnotation()
                        pointAno3.title = self.detailtext[i]
                        pointAno3.subtitle = self.detailsub[i]
                        let x = self.latitudes[i]
                        let y = self.longitudes[i]
                        pointAno3.coordinate = CLLocationCoordinate2DMake(x, y)
                        self.mapView.addAnnotation(pointAno3)
                        continue
                    }
                    
                }
                
            }
            }
        )}
    
    
    // UILongPressGestureRecognizerのdelegate：ロングタップを検出する
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        loadPin()
        // ロングタップ開始
        if sender.state == .began {
        }
            // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            // タップした位置（CGPoint）を指定してMkMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let lonStr = center.longitude
            let latStr = center.latitude
            
            latitude = latStr
            longitude = lonStr
            
            new = false
            // 新規でピンを定義する
            pointAno.title = "タイトル"
            pointAno.subtitle = "サブタイトル"
            // ロングタップを検出した位置にピンを立てる
            pointAno.coordinate = center
            mapView.addAnnotation(pointAno)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            let addVC = segue.destination as! AddViewController
            addVC.latitude = latitude
            addVC.longitude = longitude
        }else {
            let detailVC = segue.destination as! DetailViewController
            detailVC.nextTitle = self.nextTitle
            detailVC.nextText = self.nextText
            
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = false
            pinView?.pinTintColor = UIColor.purple
            pinView?.canShowCallout = true
            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //処理
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gestureRecognizer:)))
        
        
        if self.detailId.count != 0{
            for i in 0...self.detailId.count{
                if i == self.detailId.count {
                    break
                }else {
                    if (view.annotation!.title!)! == self.detailtext[i]{
                        
                        self.nextId = self.detailId[i]
                        self.nextText = self.detailtext[i]
                        self.nextTitle = self.detailsub[i]
                        new = true
                    }else{
                        
                    }
                }
            }
        }
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func tapGesture(gestureRecognizer: UITapGestureRecognizer){
        let view = gestureRecognizer.view
        let tapPoint = gestureRecognizer.location(in: view)
        //ピン部分のタップだったらリターン
        if tapPoint.x >= 0 && tapPoint.y >= 0 {
            return
        }
        
        if new == true{
            self.performSegue(withIdentifier: "toDetail", sender: nil)
        }else{
            self.performSegue(withIdentifier: "toAdd", sender: nil)
        }
        
    }
    
    
    
}
