//
//  GeoCodingViewController.swift
//  MapKitSample
//
//  Created by 佐藤紬 on 2022/12/28.
//  Copyright © 2022 com.erica. All rights reserved.
//

import UIKit
import MapKit

class GeoCodingViewController: UIViewController,UISearchBarDelegate,CLLocationManagerDelegate {
    
    //⑧searchbarをつける
    var mySearchBar: UISearchBar!
    
    @IBOutlet var addressTextLabel: UILabel!
    
    var addressString = ""
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setSearchBar()
        
    }
    
    //⑧UISearchBarDelegateをプロトコルに入れる
    //⑧
    func setSearchBar() {
        // NavigationBarにSearchBarをセット
        mySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        mySearchBar.layer.position = CGPoint(x: self.view.frame.width/2, y: 80)
        mySearchBar.delegate = self
        mySearchBar.layer.shadowColor = UIColor.blue.cgColor
        mySearchBar.layer.shadowOpacity = 0.5
        mySearchBar.layer.masksToBounds = false
        mySearchBar.showsCancelButton = true
        mySearchBar.showsBookmarkButton = false
        mySearchBar.prompt = "ローカル検索"
        mySearchBar.placeholder = "ここに入力してください"
        mySearchBar.tintColor = UIColor.red
        mySearchBar.showsSearchResultsButton = false
                // searchBarをviewに追加.
        self.view.addSubview(mySearchBar)
        }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        geoCording(address: nil)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        geoCording(address: mySearchBar.text)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    //住所検索
    func geoCording(address:String?) {
        // 検索で入力した値を代入(今回は固定で東京駅)
        var resultlat: CLLocationDegrees!
        var resultlng: CLLocationDegrees!
        // 住所から位置情報に変換
        CLGeocoder().geocodeAddressString(address!) { placemarks, error in
            if let lat = placemarks?.first?.location?.coordinate.latitude {
                // 問題なく変換できたら代入
                print("緯度 : \(lat)")
                resultlat = lat

            }
            if let lng = placemarks?.first?.location?.coordinate.longitude {
                // 問題なく変換できたら代入
                print("経度 : \(lng)")
                resultlng = lng
            }
            // 値が入ってれば
            if (resultlng != nil && resultlat != nil) {
                // 位置情報データを作成
                let cordinate = CLLocationCoordinate2DMake(resultlat, resultlng)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                // 照準を合わせる
                let region = MKCoordinateRegion(center: cordinate, span: span)
                self.mapView.region = region

                // 同時に取得した位置にピンを立てる
                let pin = MKPointAnnotation()
                pin.title = "タイトル"
                pin.subtitle = "サブタイトル"

                pin.coordinate = cordinate
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    
    @IBAction func tappedGesture(_ sender: UITapGestureRecognizer) {
           if sender.state == .ended {
               let location = mapView.convert(sender.location(in: view), toCoordinateFrom: mapView)
               convert(lat: location.latitude, log: location.longitude)
           }
       }

       func convert(lat: CLLocationDegrees, log: CLLocationDegrees){
           let geocorder = CLGeocoder()
           let location = CLLocation(latitude: lat, longitude: log)

           geocorder.reverseGeocodeLocation(location) { (placeMarks, error) in
               if let placeMark = placeMarks?.first {
                   self.addressString = """
                   郵便番号：\(placeMark.postalCode ?? "検出不可")
                   名前：\(placeMark.name ?? "検出不可")
                   都道府県：\(placeMark.administrativeArea ?? "検出不可")
                   市区町村：\(placeMark.locality ?? "検出不可")
               """
                   self.addressTextLabel.text = self.addressString
               }
           }
       }
}
