//
//  DatabaseService.swift
//  Reciplease_Project
//
//  Created by Wandianga on 10/17/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import CoreData

class DatabaseService {
    static let shared = DatabaseService()
    
    private let persistentContainer: NSPersistentContainer
    private let viewContext: NSManagedObjectContext

    init(persistentContainer: NSPersistentContainer = AppDelegate.persistentContainer) {
        self.persistentContainer = persistentContainer
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        self.viewContext = persistentContainer.viewContext
    }
    
    func save(recipe: Recipe) throws {
        let recipeEntity = RecipeEntity(context: viewContext)
        recipeEntity.title = recipe.title
        recipeEntity.imageUrl = recipe.imageUrl
        recipeEntity.url = recipe.url
        recipeEntity.portions = recipe.portions
        recipeEntity.totalTime = recipe.totalTime
        recipeEntity.ingredients = try? JSONEncoder().encode(recipe.ingredients)
        do {
            try viewContext.save()
            print("Recipe \(recipe.title) added to CoreData")
        } catch let error {
            throw error
        }
    }
    
    func loadRecipes() -> [Recipe] {
        //TODO
        return []
    }
    
    func delete(recipe: Recipe) throws {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        let titlePredicate = NSPredicate(format: "title == %@", recipe.title)
        let urlPredicate = NSPredicate(format: "url == %@", recipe.url)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [titlePredicate, urlPredicate])
        
        let managedObject = try viewContext.fetch(fetchRequest)
       // for entity in managedObject {
       //     viewContext.delete(entity)
       // }
        managedObject.forEach { (entity) in
            viewContext.delete(entity)
        }
        //managedObject.forEach { viewContext.delete($0)}
        
        do {
            try viewContext.save()
            print("Recipe \(recipe.title) deleted")
        } catch let error {
            throw error
        }
    }
}
