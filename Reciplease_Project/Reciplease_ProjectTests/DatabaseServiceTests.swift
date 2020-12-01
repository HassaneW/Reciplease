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

class DatabaseServiceTests: XCTestCase {

    var loadedRecipes: [Recipe] = []
    
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
    
    override func tearDownWithError() throws {
        loadedRecipes = []
    }
    
    func testRecipeSaveAndLoad() {
        XCTAssertEqual(loadedRecipes.count, 0)
        
        let recipes = FakeData.recipes
        
        recipes.forEach { recipe in
            do {
                try databaseService.save(recipe: recipe)
            } catch {
                XCTFail("error saving recipe \(error.localizedDescription)")
            }
        }
        
        do {
            loadedRecipes = try databaseService.loadRecipes()
        } catch {
            XCTFail("error loading recipes \(error.localizedDescription)")
        }
        
        XCTAssertEqual(loadedRecipes.count, 10)
        //XCTAssertEqual(loadedRecipes, recipes) // pk c'est pas ordonner
    }
    
    func testRecipeDeleted() {
        
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
