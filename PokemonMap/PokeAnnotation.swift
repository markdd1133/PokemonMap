//
//  PokeAnnotation.swift
//  PokemonMap
//
//  Created by Sheng Chi Chen on 2017/5/11.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation:NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var pokemon:Pokemon
    init(coord:CLLocationCoordinate2D, pokemon:Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
