//
//  ViewController.swift
//  PokemonMap
//
//  Created by Sheng Chi Chen on 2017/5/10.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var updateCount = 0
    var pokemons:[Pokemon] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        pokemons = getAllPokemon()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setUp()
        }else{
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            setUp()
        }
    }
    
    func setUp(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //Spawn a Pokemon
            if let coord = self.manager.location?.coordinate{
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                anno.coordinate = coord
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                self.mapView.addAnnotation(anno)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            return annoView
        }
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemon = (annotation as! PokeAnnotation).pokemon
        annoView.image = UIImage(named: pokemon.imageName!)
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        return annoView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        }else{
            manager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation{
            return
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 200, 200)
                mapView.setRegion(region, animated: true)
                if let coord = self.manager.location?.coordinate{
                    if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)){
                        pokemon.caught = true
                        let appDel = UIApplication.shared.delegate as! AppDelegate
                        appDel.saveContext()
                        mapView.removeAnnotation(view.annotation!)
                        let alert = UIAlertController(title: "Congrats", message: "You caught a \(pokemon.name!). You are a Pokemon Master!", preferredStyle: .alert)
                        let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                            self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                        })
                        let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(pokedexAction)
                        alert.addAction(OKaction)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Uh-Oh", message: "You are too far away to catch the \(pokemon.name!). Move closer to it!", preferredStyle: .alert)
                        let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(OKaction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        }
        
    }
    
    @IBAction func center(_ sender: Any) {
        if let coord = manager.location?.coordinate{
        let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        mapView.setRegion(region, animated: true)
        }
    }
    
}

