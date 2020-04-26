//
//  DropdownData.swift
//  bumerang
//
//  Created by RMS on 2019/9/9.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation

// house product
public class HeatingOption {
    let values = ["Klima", "Güneş Enerjisi", "Zeminden Isıtma", "Doğal Gaz", "Merkezi Isıtma"]
    let values_en = ["Klima", "Güneş Enerjisi", "Zeminden Isıtma", "Doğal Gaz", "Merkezi Isıtma"]
    let ids = [1, 2, 3, 4, 5]
}

public class BoolTypeOption {
    
    let values = ["Evet", "Hayır"]
    let ids = [1, 2]
}

//car product
public class FuelTypeOption {
    let values = ["Dizel", "Benzin", "LPG", "Diğer"]
    let values_en = ["Dizel", "Benzin", "LPG", "Diğer"]
    let ids = [1, 2, 3, 4]
}

public class GearOption {
    
    let values = ["Otomatik", "Yarı Otomatik", "Manuel"]
    let ids = [1, 2, 3]
}

public class CarTypeOption {
    
    let values = ["Sedan", "SUV", "Cabrio", "Station", "Wagon", "MPV", "Minibüs"]
    let ids = [1, 2, 3, 4, 5, 6, 7]
}

public class WeightLimitOption {
    
    let values = ["750-", "750+"]
    let ids = [1, 2]
}

public class GenderOption {
    
    let values = ["Erkek", "Kadın"]
    let ids = [1, 2]
}

public class SizeOption {
    
    let values = ["S", "M", "L", "XL", "+XL", "Diğer"]
    let ids = [1, 2, 3, 4, 5, 6]
}

public class ColorOption {
    
    let values = ["Kırmızı", "Pembe", "Turuncu", "Mavi", "Yeşil", "Turkuaz", "Siyah", "Beyaz", "Mor", "Diğer"]
    let values_en = ["Red", "Pink", "Orange", "Blue", "Green", "Turquoise", "Black", "White", "Purple", "Diğer"]
    let ids = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
}

let priceOption = ["", "Gün", "Hafta", "Ay", "Hour"]


//follow options had to apply in filter of mainpage
public class PriceFlatOption {
    
    let values = ["0-500", "501-1000", "1001-2500", "2501-5000", "+5000"]
    let ids = [1, 2, 3, 4, 5]
}

public class PriceCarOption {
    
    let values = ["0-100", "101-250", "251-500", "+500"]
    let ids = [1, 2, 3, 4]
}

// this is equal in caravan and sea vehicle
public class PriceCaravanSeaOption {
    
    let values = ["0-250", "251-500", "+500"]
    let ids = [1, 2, 3]
}

public class PriceDressSeaOption {
    
    let values = ["0-100", " 101-200", "+200"]
    let ids = [1, 2, 3]
}

public class RoomNumberOption {
    let values = ["1", "2", "3", "4", "+5"]
    let ids = [1, 2, 3, 4, 5]
}

