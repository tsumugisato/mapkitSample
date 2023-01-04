
import UIKit
import MapKit
import NCMB


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate,UISearchBarDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var switchMapButton:UIButton!
    //
    
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    var locManager =  CLLocationManager()
    
    var pinlist = Array<MKPointAnnotation>()
    
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    var myRegion: MKCoordinateRegion!
    

    
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
//        setSearchBar()
        mapView.delegate = self
        longPressGesRec.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        switchMapButton.layer.cornerRadius = 20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadPin()
        mapView.delegate = self
        longPressGesRec.delegate = self
    }
    
    //⑧UISearchBarDelegateをプロトコルに入れる
    //⑧
//    func setSearchBar() {
//        // NavigationBarにSearchBarをセット
//        mySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
//        mySearchBar.layer.position = CGPoint(x: self.view.frame.width/2, y: 80)
//        mySearchBar.delegate = self
//        mySearchBar.layer.shadowColor = UIColor.blue.cgColor
//        mySearchBar.layer.shadowOpacity = 0.5
//        mySearchBar.layer.masksToBounds = false
//        mySearchBar.showsCancelButton = true
//        mySearchBar.showsBookmarkButton = false
//        mySearchBar.prompt = "ローカル検索"
//        mySearchBar.placeholder = "ここに入力してください"
//        mySearchBar.tintColor = UIColor.red
//        mySearchBar.showsSearchResultsButton = false
//
//                // searchBarをviewに追加.
//        self.view.addSubview(mySearchBar)
//        }
    
    
    //NCMBから読み込み
    func loadPin() {
        print("ああああ")
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
                        print(pointAno3.title,"タイトル")
                        pointAno3.subtitle = self.detailsub[i]
                        print("これ")
                        print(self.detailId.count)
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
    
    @IBAction func changeMapButton(_ sender: UIButton) {
            if mapView.mapType == .standard {
                mapView.mapType = .satellite
            } else if mapView.mapType == .satellite{
                mapView.mapType = .hybrid
            } else if mapView.mapType == .hybrid{
                mapView.mapType = .satelliteFlyover
            } else if mapView.mapType == .satelliteFlyover{
                mapView.mapType = .hybridFlyover
            } else if mapView.mapType == .hybridFlyover{
                mapView.mapType = .mutedStandard
            } else {
                mapView.mapType = .standard
            }
        }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        // 編集終了.
//        self.view.endEditing(true)
//
//        // request生成.
//        let myRequest: MKLocalSearch.Request = MKLocalSearch.Request()
//
//        // 範囲を指定.
//        myRequest.region = myRegion
//
//        // 検索するワードをsearchBarのテキストに指定.
//        myRequest.naturalLanguageQuery = searchBar.text
//
//        // LocalSearchを生成.
//        let mySearch: MKLocalSearch = MKLocalSearch(request: myRequest)
//
//        // 検索開始.
//        mySearch.start { (response, error) -> Void in
//
//            if error != nil {
//                print("地名無し")
//            }
//            else if response!.mapItems.count > 0 {
//                for item in response!.mapItems {
//
//                    // 検索結果の内名前を出力.
//                    print(item.name)
//                }
//            }
//        }
//    }

//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        textField.resignFirstResponder()
//
//        //入力された値をsearchKeywordに格納する
//        let searchKeyword = textField.text
//
//        print(searchKeyword!)
//
//        //CLGeocoderインスタンスを生成
//        let geocoder = CLGeocoder()
//
//        /*CLGeocoderクラスを使うと、緯度経度から住所を算出することができる。また、逆もできる。*/
//        geocoder.geocodeAddressString(searchKeyword!, completionHandler: {(placemarks:[CLPlacemark]?, error:Error?) in
//
//            if let placemark = placemarks?[0]{
//
//                if let targetCoordinate = placemark.location?.coordinate{
//
//                    print(targetCoordinate)
//
//                    let location: CLLocation = CLLocation(latitude: targetCoordinate.latitude, longitude: targetCoordinate.longitude)
//                    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//
//                        if(error == nil) {
//                            for placemark in placemarks! {
//
//                                self.pointAno.coordinate = targetCoordinate
//
//                                self.pointAno.title = searchKeyword
//
//                                if placemark.administrativeArea == nil {
//                                    self.pointAno.subtitle = "住所が取得できません"
//                                } else if placemark.thoroughfare == nil {
//                                    self.pointAno.subtitle = "\(placemark.administrativeArea!)\(placemark.locality!)"
//                                } else if placemark.subThoroughfare == nil {
//                                    self.pointAno.subtitle = "\(placemark.administrativeArea!)\(placemark.locality!)\(placemark.thoroughfare!)"
//                                } else {
//                                    self.pointAno.subtitle = "\(placemark.administrativeArea!)\(placemark.locality!)\(placemark.thoroughfare!)\(placemark.subThoroughfare!)"
//                                }
//
//                                self.pinlist.append(self.pointAno)
//
//                                let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//                                let theRegion = MKCoordinateRegion(center: targetCoordinate, span: span)
//
//                                self.mapView.setRegion(theRegion, animated: true)
//                                self.mapView.addAnnotation(self.pointAno)
//                            }
//                        }
//                    }
//                }
//            }
//        })
//        return true
//    }
//
//}

}
