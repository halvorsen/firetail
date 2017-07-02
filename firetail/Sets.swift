//
//  Practice.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/9/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import Firebase

public struct Set1 {
    
    public static func logoutFirebase() {
        try! Auth.auth().signOut()
    }
    
    public static var flashOn: Bool = false
    public static var smsOn: Bool = false
    public static var emailOn: Bool = false
    public static var pushOn: Bool = false
    public static var allOn: Bool = false
    
    public static var token: String = ""
    
    public static var currentPrice: Double = 0.0
    
    public static var yesterday: Double = 0.0
    
    public static var alertCount: Int = 0
    
    public static var oneYearDictionary: [String:[Double]] = ["":[0.0]]
    
    public static var ti = [String]()
    
    public static var month = ["","","","","","","","","","","",""]
    
    public static var phone = "none"
    
    public static var email = "none"
    
    public static var brokerName = "none" {didSet{print("brokername: \(brokerName)")}}
    
    public static var username = "none"
    
    public static var fullName = "none"
    
    public static var premium = false
    
    public static var numOfAlerts = [Int]()
    
    public static var brokerURL = "none"
    
    public static var createdAt = "none"
    
    public static var weeklyAlerts: [String:Int] = ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
    
    public static var userAlerts = [String:String]()
    
    public static var alerts = [String:(name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:Bool,push:Bool,urgent:Bool,timestamp:Int)]()
    
    public static func saveUserInfo() {
        LoadSaveCoreData.saveUserInfoToFirebase(username: Set1.username, fullName: Set1.fullName, email: Set1.email, phone: Set1.phone, premium: Set1.premium, numOfAlerts: Set1.alertCount, brokerName: Set1.brokerName, brokerURL: Set1.brokerURL, weeklyAlerts: Set1.weeklyAlerts, userAlerts: Set1.userAlerts, token: Set1.token)
    }
}

public struct Set2 {
    public static var smallRectX = [CGFloat]()
    public static var bigRectX = [CGFloat]()
    public static var priceRectX = [CGFloat]()
    }
    
struct Set3 {

    static let shared = Set3()
   
    
    let priceRectX:[CGFloat] =
    [190.5, 265.5, 340.5, 415.5, 490.5, 565.5, 640.5, 715.5, 790.5, 865.5, 940.5, 1015.5, 1090.5, 1165.5, 1240.5, 1315.5, 1390.5, 1465.5, 1540.5, 1615.5, 1690.5, 1765.5, 1840.5, 1915.5, 1990.5, 2065.5, 2140.5, 2215.5, 2290.5, 2365.5, 2440.5, 2515.5, 2590.5, 2665.5, 2740.5, 2815.5, 2890.5, 2965.5, 3040.5, 3115.5, 3190.5, 3265.5, 3340.5, 3415.5, 3490.5, 3565.5, 3640.5, 3715.5, 3790.5, 3865.5, 3940.5, 4015.5, 4090.5, 4165.5, 4240.5, 4315.5, 4390.5, 4465.5, 4540.5, 4615.5, 4690.5, 4765.5, 4840.5, 4915.5, 4990.5, 5065.5, 5140.5, 5215.5, 5290.5, 5365.5, 5440.5, 5515.5, 5590.5, 5665.5, 5740.5, 5815.5, 5890.5, 5965.5, 6040.5, 6115.5, 6190.5, 6265.5, 6340.5, 6415.5, 6490.5, 6565.5, 6640.5, 6715.5, 6790.5, 6865.5, 6940.5, 7015.5, 7090.5, 7165.5, 7240.5, 7315.5, 7390.5, 7465.5, 7540.5, 7615.5, 7690.5, 7765.5, 7840.5, 7915.5, 7990.5, 8065.5, 8140.5, 8215.5, 8290.5, 8365.5, 8440.5, 8515.5, 8590.5, 8665.5, 8740.5, 8815.5, 8890.5, 8965.5, 9040.5, 9115.5, 9190.5, 9265.5, 9340.5, 9415.5, 9490.5, 9565.5, 9640.5, 9715.5, 9790.5, 9865.5, 9940.5, 10015.5, 10090.5, 10165.5, 10240.5, 10315.5, 10390.5, 10465.5, 10540.5, 10615.5, 10690.5, 10765.5, 10840.5, 10915.5, 10990.5, 11065.5, 11140.5, 11215.5, 11290.5, 11365.5, 11440.5, 11515.5, 11590.5, 11665.5, 11740.5, 11815.5, 11890.5, 11965.5, 12040.5, 12115.5, 12190.5, 12265.5, 12340.5, 12415.5, 12490.5, 12565.5, 12640.5, 12715.5, 12790.5, 12865.5, 12940.5, 13015.5, 13090.5, 13165.5, 13240.5, 13315.5, 13390.5, 13465.5, 13540.5, 13615.5, 13690.5, 13765.5, 13840.5, 13915.5, 13990.5, 14065.5, 14140.5, 14215.5, 14290.5, 14365.5, 14440.5, 14515.5, 14590.5, 14665.5, 14740.5, 14815.5, 14890.5, 14965.5, 15040.5, 15115.5, 15190.5, 15265.5, 15340.5, 15415.5, 15490.5, 15565.5, 15640.5, 15715.5, 15790.5, 15865.5, 15940.5, 16015.5, 16090.5, 16165.5, 16240.5, 16315.5, 16390.5, 16465.5, 16540.5, 16615.5, 16690.5, 16765.5, 16840.5, 16915.5, 16990.5, 17065.5, 17140.5, 17215.5, 17290.5, 17365.5, 17440.5, 17515.5, 17590.5, 17665.5, 17740.5, 17815.5, 17890.5, 17965.5, 18040.5, 18115.5, 18190.5, 18265.5, 18340.5, 18415.5, 18490.5, 18565.5, 18640.5, 18715.5, 18790.5, 18865.5, 18940.5, 19015.5, 19090.5, 19165.5, 19240.5, 19315.5, 19390.5, 19465.5, 19540.5, 19615.5, 19690.5, 19765.5, 19840.5, 19915.5, 19990.5, 20065.5, 20140.5, 20215.5, 20290.5, 20365.5, 20440.5, 20515.5, 20590.5, 20665.5, 20740.5, 20815.5, 20890.5, 20965.5, 21040.5, 21115.5, 21190.5, 21265.5, 21340.5, 21415.5, 21490.5, 21565.5, 21640.5, 21715.5, 21790.5, 21865.5, 21940.5, 22015.5, 22090.5, 22165.5, 22240.5, 22315.5, 22390.5, 22465.5, 22540.5, 22615.5, 22690.5, 22765.5, 22840.5, 22915.5, 22990.5, 23065.5, 23140.5, 23215.5, 23290.5, 23365.5, 23440.5, 23515.5, 23590.5, 23665.5, 23740.5, 23815.5, 23890.5, 23965.5, 24040.5, 24115.5, 24190.5, 24265.5, 24340.5, 24415.5, 24490.5, 24565.5, 24640.5, 24715.5, 24790.5, 24865.5, 24940.5, 25015.5, 25090.5, 25165.5, 25240.5, 25315.5, 25390.5, 25465.5, 25540.5, 25615.5, 25690.5, 25765.5, 25840.5, 25915.5, 25990.5, 26065.5, 26140.5, 26215.5, 26290.5, 26365.5, 26440.5, 26515.5, 26590.5, 26665.5, 26740.5, 26815.5, 26890.5, 26965.5, 27040.5, 27115.5, 27190.5, 27265.5, 27340.5, 27415.5, 27490.5, 27565.5, 27640.5, 27715.5, 27790.5, 27865.5, 27940.5, 28015.5, 28090.5, 28165.5, 28240.5, 28315.5, 28390.5, 28465.5, 28540.5, 28615.5, 28690.5, 28765.5, 28840.5, 28915.5, 28990.5, 29065.5, 29140.5, 29215.5, 29290.5, 29365.5, 29440.5, 29515.5, 29590.5, 29665.5, 29740.5, 29815.5, 29890.5, 29965.5, 30040.5, 30115.5, 30190.5, 30265.5, 30340.5, 30415.5, 30490.5, 30565.5, 30640.5, 30715.5, 30790.5, 30865.5, 30940.5, 31015.5, 31090.5, 31165.5, 31240.5, 31315.5, 31390.5, 31465.5, 31540.5, 31615.5, 31690.5, 31765.5, 31840.5, 31915.5, 31990.5, 32065.5, 32140.5, 32215.5, 32290.5, 32365.5, 32440.5, 32515.5, 32590.5, 32665.5, 32740.5, 32815.5, 32890.5, 32965.5, 33040.5, 33115.5, 33190.5, 33265.5, 33340.5, 33415.5, 33490.5, 33565.5, 33640.5, 33715.5, 33790.5, 33865.5, 33940.5, 34015.5, 34090.5, 34165.5, 34240.5, 34315.5, 34390.5, 34465.5, 34540.5, 34615.5, 34690.5, 34765.5, 34840.5, 34915.5, 34990.5, 35065.5, 35140.5, 35215.5, 35290.5, 35365.5, 35440.5, 35515.5, 35590.5, 35665.5, 35740.5, 35815.5, 35890.5, 35965.5, 36040.5, 36115.5, 36190.5, 36265.5, 36340.5, 36415.5, 36490.5, 36565.5, 36640.5, 36715.5, 36790.5, 36865.5, 36940.5, 37015.5, 37090.5, 37165.5, 37240.5, 37315.5, 37390.5, 37465.5, 37540.5, 37615.5, 37690.5, 37765.5, 37840.5, 37915.5, 37990.5, 38065.5, 38140.5, 38215.5, 38290.5, 38365.5, 38440.5, 38515.5, 38590.5, 38665.5, 38740.5, 38815.5, 38890.5, 38965.5, 39040.5, 39115.5, 39190.5, 39265.5, 39340.5, 39415.5, 39490.5, 39565.5, 39640.5, 39715.5, 39790.5, 39865.5, 39940.5, 40015.5, 40090.5, 40165.5, 40240.5, 40315.5, 40390.5, 40465.5, 40540.5, 40615.5, 40690.5, 40765.5, 40840.5, 40915.5, 40990.5, 41065.5, 41140.5, 41215.5, 41290.5, 41365.5, 41440.5, 41515.5, 41590.5, 41665.5, 41740.5, 41815.5, 41890.5, 41965.5, 42040.5, 42115.5, 42190.5, 42265.5, 42340.5, 42415.5, 42490.5, 42565.5, 42640.5, 42715.5, 42790.5, 42865.5, 42940.5, 43015.5, 43090.5, 43165.5, 43240.5, 43315.5, 43390.5, 43465.5, 43540.5, 43615.5, 43690.5, 43765.5, 43840.5, 43915.5, 43990.5, 44065.5, 44140.5, 44215.5, 44290.5, 44365.5, 44440.5, 44515.5, 44590.5, 44665.5, 44740.5, 44815.5, 44890.5, 44965.5, 45040.5, 45115.5, 45190.5, 45265.5, 45340.5, 45415.5, 45490.5, 45565.5, 45640.5, 45715.5, 45790.5, 45865.5, 45940.5, 46015.5, 46090.5, 46165.5, 46240.5, 46315.5, 46390.5, 46465.5, 46540.5, 46615.5, 46690.5, 46765.5, 46840.5, 46915.5, 46990.5, 47065.5, 47140.5, 47215.5, 47290.5, 47365.5, 47440.5, 47515.5, 47590.5, 47665.5, 47740.5, 47815.5, 47890.5, 47965.5, 48040.5, 48115.5, 48190.5, 48265.5, 48340.5, 48415.5, 48490.5, 48565.5, 48640.5, 48715.5, 48790.5, 48865.5, 48940.5, 49015.5, 49090.5, 49165.5, 49240.5, 49315.5, 49390.5, 49465.5, 49540.5, 49615.5, 49690.5, 49765.5, 49840.5, 49915.5, 49990.5, 50065.5, 50140.5, 50215.5, 50290.5, 50365.5, 50440.5, 50515.5, 50590.5, 50665.5, 50740.5, 50815.5, 50890.5, 50965.5, 51040.5, 51115.5, 51190.5, 51265.5, 51340.5, 51415.5, 51490.5, 51565.5, 51640.5, 51715.5, 51790.5, 51865.5, 51940.5, 52015.5, 52090.5, 52165.5, 52240.5, 52315.5, 52390.5, 52465.5, 52540.5, 52615.5, 52690.5, 52765.5, 52840.5, 52915.5, 52990.5, 53065.5, 53140.5, 53215.5, 53290.5, 53365.5, 53440.5, 53515.5, 53590.5, 53665.5, 53740.5, 53815.5, 53890.5, 53965.5, 54040.5, 54115.5, 54190.5, 54265.5, 54340.5, 54415.5, 54490.5, 54565.5, 54640.5, 54715.5, 54790.5, 54865.5, 54940.5, 55015.5, 55090.5, 55165.5, 55240.5, 55315.5, 55390.5, 55465.5, 55540.5, 55615.5, 55690.5, 55765.5, 55840.5, 55915.5, 55990.5, 56065.5, 56140.5, 56215.5, 56290.5, 56365.5, 56440.5, 56515.5, 56590.5, 56665.5, 56740.5, 56815.5, 56890.5, 56965.5, 57040.5, 57115.5, 57190.5, 57265.5, 57340.5, 57415.5, 57490.5, 57565.5, 57640.5, 57715.5, 57790.5, 57865.5, 57940.5, 58015.5, 58090.5, 58165.5, 58240.5, 58315.5, 58390.5, 58465.5, 58540.5, 58615.5, 58690.5, 58765.5, 58840.5, 58915.5, 58990.5, 59065.5, 59140.5, 59215.5, 59290.5, 59365.5, 59440.5, 59515.5, 59590.5, 59665.5, 59740.5, 59815.5, 59890.5, 59965.5, 60040.5, 60115.5, 60190.5, 60265.5, 60340.5, 60415.5, 60490.5, 60565.5, 60640.5, 60715.5, 60790.5, 60865.5, 60940.5, 61015.5, 61090.5, 61165.5, 61240.5, 61315.5, 61390.5, 61465.5, 61540.5, 61615.5, 61690.5, 61765.5, 61840.5, 61915.5, 61990.5, 62065.5, 62140.5, 62215.5, 62290.5, 62365.5, 62440.5, 62515.5, 62590.5, 62665.5, 62740.5, 62815.5, 62890.5, 62965.5, 63040.5, 63115.5, 63190.5, 63265.5, 63340.5, 63415.5, 63490.5, 63565.5, 63640.5, 63715.5, 63790.5, 63865.5, 63940.5, 64015.5, 64090.5, 64165.5, 64240.5, 64315.5, 64390.5, 64465.5, 64540.5, 64615.5, 64690.5, 64765.5, 64840.5, 64915.5, 64990.5, 65065.5, 65140.5, 65215.5, 65290.5, 65365.5, 65440.5, 65515.5, 65590.5, 65665.5, 65740.5, 65815.5, 65890.5, 65965.5, 66040.5, 66115.5, 66190.5, 66265.5, 66340.5, 66415.5, 66490.5, 66565.5, 66640.5, 66715.5, 66790.5, 66865.5, 66940.5, 67015.5, 67090.5, 67165.5, 67240.5, 67315.5, 67390.5, 67465.5, 67540.5, 67615.5, 67690.5, 67765.5, 67840.5, 67915.5, 67990.5, 68065.5, 68140.5, 68215.5, 68290.5, 68365.5, 68440.5, 68515.5, 68590.5, 68665.5, 68740.5, 68815.5, 68890.5, 68965.5, 69040.5, 69115.5, 69190.5, 69265.5, 69340.5, 69415.5, 69490.5, 69565.5, 69640.5, 69715.5, 69790.5, 69865.5, 69940.5, 70015.5, 70090.5, 70165.5, 70240.5, 70315.5, 70390.5, 70465.5, 70540.5, 70615.5, 70690.5, 70765.5, 70840.5, 70915.5, 70990.5, 71065.5, 71140.5, 71215.5, 71290.5, 71365.5, 71440.5, 71515.5, 71590.5, 71665.5, 71740.5, 71815.5, 71890.5, 71965.5, 72040.5, 72115.5, 72190.5, 72265.5, 72340.5, 72415.5, 72490.5, 72565.5, 72640.5, 72715.5, 72790.5, 72865.5, 72940.5, 73015.5, 73090.5, 73165.5, 73240.5, 73315.5, 73390.5, 73465.5, 73540.5, 73615.5, 73690.5, 73765.5, 73840.5, 73915.5, 73990.5, 74065.5, 74140.5, 74215.5, 74290.5, 74365.5, 74440.5, 74515.5, 74590.5, 74665.5, 74740.5, 74815.5, 74890.5, 74965.5, 75040.5, 75115.5, 75190.5, 75265.5, 75340.5, 75415.5, 75490.5, 75565.5, 75640.5, 75715.5, 75790.5, 75865.5, 75940.5, 76015.5, 76090.5, 76165.5, 76240.5, 76315.5, 76390.5, 76465.5, 76540.5, 76615.5, 76690.5, 76765.5, 76840.5, 76915.5, 76990.5, 77065.5, 77140.5, 77215.5, 77290.5, 77365.5, 77440.5, 77515.5, 77590.5, 77665.5, 77740.5, 77815.5, 77890.5, 77965.5, 78040.5, 78115.5, 78190.5, 78265.5, 78340.5, 78415.5, 78490.5, 78565.5, 78640.5, 78715.5, 78790.5, 78865.5, 78940.5, 79015.5, 79090.5, 79165.5, 79240.5, 79315.5, 79390.5, 79465.5, 79540.5, 79615.5, 79690.5, 79765.5, 79840.5, 79915.5, 79990.5, 80065.5, 80140.5, 80215.5, 80290.5, 80365.5, 80440.5, 80515.5, 80590.5, 80665.5, 80740.5, 80815.5, 80890.5, 80965.5, 81040.5, 81115.5, 81190.5, 81265.5, 81340.5, 81415.5, 81490.5, 81565.5, 81640.5, 81715.5, 81790.5, 81865.5, 81940.5, 82015.5, 82090.5, 82165.5, 82240.5, 82315.5, 82390.5, 82465.5, 82540.5, 82615.5, 82690.5, 82765.5, 82840.5, 82915.5, 82990.5, 83065.5, 83140.5, 83215.5, 83290.5, 83365.5, 83440.5, 83515.5, 83590.5, 83665.5, 83740.5, 83815.5, 83890.5, 83965.5, 84040.5, 84115.5, 84190.5, 84265.5, 84340.5, 84415.5, 84490.5, 84565.5, 84640.5, 84715.5, 84790.5, 84865.5, 84940.5, 85015.5, 85090.5, 85165.5, 85240.5, 85315.5, 85390.5, 85465.5, 85540.5, 85615.5, 85690.5, 85765.5, 85840.5, 85915.5, 85990.5, 86065.5, 86140.5, 86215.5, 86290.5, 86365.5, 86440.5, 86515.5, 86590.5, 86665.5, 86740.5, 86815.5, 86890.5, 86965.5, 87040.5, 87115.5, 87190.5, 87265.5, 87340.5, 87415.5, 87490.5, 87565.5, 87640.5, 87715.5, 87790.5, 87865.5, 87940.5, 88015.5, 88090.5, 88165.5, 88240.5, 88315.5, 88390.5, 88465.5, 88540.5, 88615.5, 88690.5, 88765.5, 88840.5, 88915.5, 88990.5, 89065.5, 89140.5, 89215.5, 89290.5, 89365.5, 89440.5, 89515.5, 89590.5, 89665.5, 89740.5, 89815.5, 89890.5, 89965.5, 90040.5, 90115.5, 90190.5, 90265.5, 90340.5, 90415.5, 90490.5, 90565.5, 90640.5, 90715.5, 90790.5, 90865.5, 90940.5, 91015.5, 91090.5, 91165.5, 91240.5, 91315.5, 91390.5, 91465.5, 91540.5, 91615.5, 91690.5, 91765.5, 91840.5, 91915.5, 91990.5, 92065.5, 92140.5, 92215.5, 92290.5, 92365.5, 92440.5, 92515.5, 92590.5, 92665.5, 92740.5, 92815.5, 92890.5, 92965.5, 93040.5, 93115.5, 93190.5, 93265.5, 93340.5, 93415.5, 93490.5, 93565.5, 93640.5, 93715.5, 93790.5, 93865.5, 93940.5, 94015.5, 94090.5, 94165.5, 94240.5, 94315.5, 94390.5, 94465.5, 94540.5, 94615.5, 94690.5, 94765.5, 94840.5, 94915.5, 94990.5, 95065.5, 95140.5, 95215.5, 95290.5, 95365.5, 95440.5, 95515.5, 95590.5, 95665.5, 95740.5, 95815.5, 95890.5, 95965.5, 96040.5, 96115.5, 96190.5, 96265.5, 96340.5, 96415.5, 96490.5, 96565.5, 96640.5, 96715.5, 96790.5, 96865.5, 96940.5, 97015.5, 97090.5, 97165.5, 97240.5, 97315.5, 97390.5, 97465.5, 97540.5, 97615.5, 97690.5, 97765.5, 97840.5, 97915.5, 97990.5, 98065.5, 98140.5, 98215.5, 98290.5, 98365.5, 98440.5, 98515.5, 98590.5, 98665.5, 98740.5, 98815.5, 98890.5, 98965.5, 99040.5, 99115.5, 99190.5, 99265.5, 99340.5, 99415.5, 99490.5, 99565.5, 99640.5, 99715.5, 99790.5, 99865.5, 99940.5, 100015.5, 100090.5, 100165.5, 100240.5, 100315.5, 100390.5, 100465.5, 100540.5, 100615.5, 100690.5, 100765.5, 100840.5, 100915.5, 100990.5, 101065.5, 101140.5, 101215.5, 101290.5, 101365.5, 101440.5, 101515.5, 101590.5, 101665.5, 101740.5, 101815.5, 101890.5, 101965.5, 102040.5, 102115.5, 102190.5, 102265.5, 102340.5, 102415.5, 102490.5, 102565.5, 102640.5, 102715.5, 102790.5, 102865.5, 102940.5, 103015.5, 103090.5, 103165.5, 103240.5, 103315.5, 103390.5, 103465.5, 103540.5, 103615.5, 103690.5, 103765.5, 103840.5, 103915.5, 103990.5, 104065.5, 104140.5, 104215.5, 104290.5, 104365.5, 104440.5, 104515.5, 104590.5, 104665.5, 104740.5, 104815.5, 104890.5, 104965.5, 105040.5, 105115.5, 105190.5, 105265.5, 105340.5, 105415.5, 105490.5, 105565.5, 105640.5, 105715.5, 105790.5, 105865.5, 105940.5, 106015.5, 106090.5, 106165.5, 106240.5, 106315.5, 106390.5, 106465.5, 106540.5, 106615.5, 106690.5, 106765.5, 106840.5, 106915.5, 106990.5, 107065.5, 107140.5, 107215.5, 107290.5, 107365.5, 107440.5, 107515.5, 107590.5, 107665.5, 107740.5, 107815.5, 107890.5, 107965.5, 108040.5, 108115.5, 108190.5, 108265.5, 108340.5, 108415.5, 108490.5, 108565.5, 108640.5, 108715.5, 108790.5, 108865.5, 108940.5, 109015.5, 109090.5, 109165.5, 109240.5, 109315.5, 109390.5, 109465.5, 109540.5, 109615.5, 109690.5, 109765.5, 109840.5, 109915.5, 109990.5, 110065.5, 110140.5, 110215.5, 110290.5, 110365.5, 110440.5, 110515.5, 110590.5, 110665.5, 110740.5, 110815.5, 110890.5, 110965.5, 111040.5, 111115.5, 111190.5, 111265.5, 111340.5, 111415.5, 111490.5, 111565.5, 111640.5, 111715.5, 111790.5, 111865.5, 111940.5, 112015.5, 112090.5, 112165.5, 112240.5, 112315.5, 112390.5, 112465.5, 112540.5, 112615.5, 112690.5, 112765.5, 112840.5, 112915.5, 112990.5, 113065.5, 113140.5, 113215.5, 113290.5, 113365.5, 113440.5, 113515.5, 113590.5, 113665.5, 113740.5, 113815.5, 113890.5, 113965.5, 114040.5, 114115.5, 114190.5, 114265.5, 114340.5, 114415.5, 114490.5, 114565.5, 114640.5, 114715.5, 114790.5, 114865.5, 114940.5, 115015.5, 115090.5, 115165.5, 115240.5, 115315.5, 115390.5, 115465.5, 115540.5, 115615.5, 115690.5, 115765.5, 115840.5, 115915.5, 115990.5, 116065.5, 116140.5, 116215.5, 116290.5, 116365.5, 116440.5, 116515.5, 116590.5, 116665.5, 116740.5, 116815.5, 116890.5, 116965.5, 117040.5, 117115.5, 117190.5, 117265.5, 117340.5, 117415.5, 117490.5, 117565.5, 117640.5, 117715.5, 117790.5, 117865.5, 117940.5, 118015.5, 118090.5, 118165.5, 118240.5, 118315.5, 118390.5, 118465.5, 118540.5, 118615.5, 118690.5, 118765.5, 118840.5, 118915.5, 118990.5, 119065.5, 119140.5, 119215.5, 119290.5, 119365.5, 119440.5, 119515.5, 119590.5, 119665.5, 119740.5, 119815.5, 119890.5, 119965.5, 120040.5, 120115.5, 120190.5, 120265.5, 120340.5, 120415.5, 120490.5, 120565.5, 120640.5, 120715.5, 120790.5, 120865.5, 120940.5, 121015.5, 121090.5, 121165.5, 121240.5, 121315.5, 121390.5, 121465.5, 121540.5, 121615.5, 121690.5, 121765.5, 121840.5, 121915.5, 121990.5, 122065.5, 122140.5, 122215.5, 122290.5, 122365.5, 122440.5, 122515.5, 122590.5, 122665.5, 122740.5, 122815.5, 122890.5, 122965.5, 123040.5, 123115.5, 123190.5, 123265.5, 123340.5, 123415.5, 123490.5, 123565.5, 123640.5, 123715.5, 123790.5, 123865.5, 123940.5, 124015.5, 124090.5, 124165.5, 124240.5, 124315.5, 124390.5, 124465.5, 124540.5, 124615.5, 124690.5, 124765.5, 124840.5, 124915.5, 124990.5, 125065.5, 125140.5, 125215.5, 125290.5, 125365.5, 125440.5, 125515.5, 125590.5, 125665.5, 125740.5, 125815.5, 125890.5, 125965.5, 126040.5, 126115.5, 126190.5, 126265.5, 126340.5, 126415.5, 126490.5, 126565.5, 126640.5, 126715.5, 126790.5, 126865.5, 126940.5, 127015.5, 127090.5, 127165.5, 127240.5, 127315.5, 127390.5, 127465.5, 127540.5, 127615.5, 127690.5, 127765.5, 127840.5, 127915.5, 127990.5, 128065.5, 128140.5, 128215.5, 128290.5, 128365.5, 128440.5, 128515.5, 128590.5, 128665.5, 128740.5, 128815.5, 128890.5, 128965.5, 129040.5, 129115.5, 129190.5, 129265.5, 129340.5, 129415.5, 129490.5, 129565.5, 129640.5, 129715.5, 129790.5, 129865.5, 129940.5, 130015.5, 130090.5, 130165.5, 130240.5, 130315.5, 130390.5, 130465.5, 130540.5, 130615.5, 130690.5, 130765.5, 130840.5, 130915.5, 130990.5, 131065.5, 131140.5, 131215.5, 131290.5, 131365.5, 131440.5, 131515.5, 131590.5, 131665.5, 131740.5, 131815.5, 131890.5, 131965.5, 132040.5, 132115.5, 132190.5, 132265.5, 132340.5, 132415.5, 132490.5, 132565.5, 132640.5, 132715.5, 132790.5, 132865.5, 132940.5, 133015.5, 133090.5, 133165.5, 133240.5, 133315.5, 133390.5, 133465.5, 133540.5, 133615.5, 133690.5, 133765.5, 133840.5, 133915.5, 133990.5, 134065.5, 134140.5, 134215.5, 134290.5, 134365.5, 134440.5, 134515.5, 134590.5, 134665.5, 134740.5, 134815.5, 134890.5, 134965.5, 135040.5, 135115.5, 135190.5, 135265.5, 135340.5, 135415.5, 135490.5, 135565.5, 135640.5, 135715.5, 135790.5, 135865.5, 135940.5, 136015.5, 136090.5, 136165.5, 136240.5, 136315.5, 136390.5, 136465.5, 136540.5, 136615.5, 136690.5, 136765.5, 136840.5, 136915.5, 136990.5, 137065.5, 137140.5, 137215.5, 137290.5, 137365.5, 137440.5, 137515.5, 137590.5, 137665.5, 137740.5, 137815.5, 137890.5, 137965.5, 138040.5, 138115.5, 138190.5, 138265.5, 138340.5, 138415.5, 138490.5, 138565.5, 138640.5, 138715.5, 138790.5, 138865.5, 138940.5, 139015.5, 139090.5, 139165.5, 139240.5, 139315.5, 139390.5, 139465.5, 139540.5, 139615.5, 139690.5, 139765.5, 139840.5, 139915.5, 139990.5, 140065.5, 140140.5, 140215.5, 140290.5, 140365.5, 140440.5, 140515.5, 140590.5, 140665.5, 140740.5, 140815.5, 140890.5, 140965.5, 141040.5, 141115.5, 141190.5, 141265.5, 141340.5, 141415.5, 141490.5, 141565.5, 141640.5, 141715.5, 141790.5, 141865.5, 141940.5, 142015.5, 142090.5, 142165.5, 142240.5, 142315.5, 142390.5, 142465.5, 142540.5, 142615.5, 142690.5, 142765.5, 142840.5, 142915.5, 142990.5, 143065.5, 143140.5, 143215.5, 143290.5, 143365.5, 143440.5, 143515.5, 143590.5, 143665.5, 143740.5, 143815.5, 143890.5, 143965.5, 144040.5, 144115.5, 144190.5, 144265.5, 144340.5, 144415.5, 144490.5, 144565.5, 144640.5, 144715.5, 144790.5, 144865.5, 144940.5, 145015.5, 145090.5, 145165.5, 145240.5, 145315.5, 145390.5, 145465.5, 145540.5, 145615.5, 145690.5, 145765.5, 145840.5, 145915.5, 145990.5, 146065.5, 146140.5, 146215.5, 146290.5, 146365.5, 146440.5, 146515.5, 146590.5, 146665.5, 146740.5, 146815.5, 146890.5, 146965.5, 147040.5, 147115.5, 147190.5, 147265.5, 147340.5, 147415.5, 147490.5, 147565.5, 147640.5, 147715.5, 147790.5, 147865.5, 147940.5, 148015.5, 148090.5, 148165.5, 148240.5, 148315.5, 148390.5, 148465.5, 148540.5, 148615.5, 148690.5, 148765.5, 148840.5, 148915.5, 148990.5, 149065.5, 149140.5, 149215.5, 149290.5, 149365.5, 149440.5, 149515.5, 149590.5, 149665.5, 149740.5, 149815.5, 149890.5, 149965.5, 150040.5, 150115.5, 150190.5
    ]
    
    }
