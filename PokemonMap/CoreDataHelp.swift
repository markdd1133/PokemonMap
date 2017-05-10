//
//  CoreDataHelp.swift
//  PokemonMap
//
//  Created by Sheng Chi Chen on 2017/5/11.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    let appDel = UIApplication.shared.delegate as! AppDelegate
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Dratini", imageName: "dratini")
    createPokemon(name: "Mankey", imageName: "mankey")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Bellsprout", imageName: "bellsprout")
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
    createPokemon(name: "Eevee", imageName: "eevee")
    appDel.saveContext()
}

func createPokemon(name:String, imageName:String){
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = appDel.persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}

func getAllPokemon() -> [Pokemon]{
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = appDel.persistentContainer.viewContext
    do{
    let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0{
            addAllPokemon()
            return getAllPokemon()
        }
    return pokemons
    }catch{}
    return []
}

func getAllCaughtPokemons()->[Pokemon]{
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = appDel.persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }catch{}
    return []
}

func getAllUncaughtPokemons()->[Pokemon]{
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = appDel.persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }catch{}
    return []
}
