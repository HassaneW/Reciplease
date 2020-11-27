//
//  DatabaseServiceTests.swift
//  Reciplease_ProjectTests
//
//  Created by Wandianga hassane on 20/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

@testable import Reciplease_Project
import XCTest
import CoreData

//TODO: creeer fake let recipes = FakeData.recipes

class DatabaseServiceTests: XCTestCase {

    
    //static let managedObjectModel = NSManagedObjectModel
    
    
    let databaseService: DatabaseService = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        persistentStoreDescription.shouldAddStoreAsynchronously = false
        let container = NSPersistentContainer(name: "Reciplease_Project")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { description, error in
            precondition(description.type == NSInMemoryStoreType, "Precondition failed, store description is not of type in memory")
            if let error = error { fatalError("Error creating persistent coordinator \(error))")
            }
        }
        return DatabaseService(persistentContainer: container)
    }()
    
    
    func testRecipeSaveAndLoad() { // On prend les recettes, on sauvegarde puis on load pour vérifier
//        let recipes = FAke.recipes
//
//        recipes.forEach {
//
//        }
//        let recipe = recipes.first
//
//         do catch
//        databaseService.save(recipe: recipe)
        
        // do catch
//        loadedReciipes = databaseService.loadRecipes()
//
//        XCTAssertEqual(loadedrecipes, [recipe])
//        XCTAssertEqual(loadedrecipes, recipes)
        
    }
    
    //Test Delete
//    save recipes
//    recipes.count == 10
//    select one recipe random ou first last
//    call recipe delete
//    call load : loadedREcipes Aray
//    dans cet arrray ont doit pas trouver la recepte surppimer
//    count 9
}
