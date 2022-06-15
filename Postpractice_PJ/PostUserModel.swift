import Foundation

struct PostUserModel:Decodable{
    var results : [ResultModel]
}
struct ResultModel:Decodable{
    var gender : String
    var name : NameModel
    var email : String
    var dob : DobModel
    var picture : PictureModel
    var location : CoordinatesModel
}
struct NameModel:Decodable{
    var first : String
    var last : String
}
struct DobModel:Decodable{
    var date : String
    var age : Int
}
struct PictureModel:Decodable{
    var large : String
}
struct CoordinatesModel : Decodable{
    var coordinates : CurrentModel
    
}
struct CurrentModel : Decodable{
    var latitude : String
    var longitude : String
}
