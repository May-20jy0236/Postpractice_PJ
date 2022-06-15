//
//  MainViewController.swift
//  Postpractice_PJ
//
//  Created by HL株式会社 on 14/6/2022.
//

import UIKit
import MapKit
class MainViewController: UIViewController {

    @IBOutlet weak var userLocationMap: MKMapView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userInfotable: UITableView!
    var session = URLSession(configuration: .default)
    var user : MyInformation?
     
    var a : Double = 0.0
    var b : Double = 0
    let url = "https://randomuser.me/api/"
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfotable.delegate = self
        userInfotable.dataSource = self
        userInfotable.tableFooterView = UIView()
        getUserInfo()
    }
    func getUserInfo() {
        guard let url = URL(string: url) else {
             return
           }
//        let url = URL(string : url)
        let task = URLSession.shared.dataTask(with: url , completionHandler: { data , response, error in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
           }
            if let data = data{
                print(data)
                self.parseJson(data: data)
           }
        })
        task.resume()
    }
    func parseJson(data:Data){
        do {
            let json = try JSONDecoder().decode(PostUserModel.self, from: data)
            print(json)
            let result = json.results[0]
            user = MyInformation(name: "\(result.name.first) \(result.name.last)", email: result.email, sexual: result.gender , birthdate: String(result.dob.date.prefix(10)) , photoUrl: result.picture.large , latitude: result.location.coordinates.latitude, longitude: result.location.coordinates.longitude)
            if let latitude = Double(user!.latitude) {
                a = latitude
                print(a)
            }else{
                print("数値に変換できません")
               
            }
            if let longitude = Double(user!.longitude) {
                b = longitude
                print(b)
            }else{
                print("数値に変換できません")
            }
         
            let location = CLLocationCoordinate2DMake(a, b)
            // マップビューに緯度・軽度を設定
            userLocationMap.setCenter(location, animated:true)
            
            print(json)
            if let url = URL(string: user?.photoUrl ?? "") , let imageData = try? Data(contentsOf: url){
                DispatchQueue.main.async {
                    self.userPhoto.image = UIImage(data: imageData)
                    self.userInfotable.reloadData()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myinfocell", for: indexPath) as? MyInformationTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Name"
            cell.detailLabel.text = user?.name
        case 1:
            cell.titleLabel.text = "Sexual"
            cell.detailLabel.text = user?.sexual
        case 2:
            cell.titleLabel.text = "Birthday"
            cell.detailLabel.text = user?.birthdate
        case 3:
            cell.titleLabel.text = "Email"
            cell.detailLabel.text = user?.email
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

