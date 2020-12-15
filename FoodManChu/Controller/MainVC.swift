//
//  ViewController.swift
//  FoodManChu
//
//  Created by Desiree on 12/1/20.
//

import UIKit
import CoreData

class MainVC: UIViewController, NSFetchedResultsControllerDelegate {
  
    var controller: NSFetchedResultsController<Recipe>!
    var ingredients = [Ingredient]()
    var selectedRecipe: Recipe?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        generateDummyRecipe()
//        delete()
//        generateIngredients()
        fetchRecipes()
    }
    
    func generateDummyRecipe() {
        
        let dummyRecipe = Recipe(context: Constants.context)
        
        let photo = Image(context: Constants.context)
        photo.setImage = UIImage(named: "shrimpScampi")
        dummyRecipe.image = photo
        
        dummyRecipe.recipeName = "Shrimp Scampi"
      
        dummyRecipe.recipeDescription = "A garlic buttery scampi sauce with a hint of white wine & lemon in less than 10 minutes!"
        dummyRecipe.instructions = "1. Heat olive oil and 2 tablespoons of butter in a large pan or skillet. Add garlic and sauté until fragrant (about 30 seconds - 1 minute). Then add the shrimp, season with salt and pepper to taste and sauté for 1-2 minutes on one side (until just beginning to turn pink), then flip.\n 2. Pour in wine (or broth), add red pepper flakes (if using). Bring to a simmer for 1-2 minutes or until wine reduces by about half and the shrimp is cooked through (don't over cook your shrimp). \n 3. Stir in the remaining butter, lemon juice and parsley and take off heat immediately.\n 4. Serve over rice, pasta, garlic bread or steamed vegetables (cauliflower, broccoli, zucchini noodles)."
    
        dummyRecipe.prepTime = 10.0
        
        fetchCategory(for: dummyRecipe)
        fetchIngredients(for: dummyRecipe)
        
        do {
            try Constants.context.save()
        } catch  {
            print(error)
        }
        
    }
    

    func fetchRecipes() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let sort = NSSortDescriptor(key: "recipeName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Constants.context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch  {
            print(error.localizedDescription)
            }
        }
    
    func fetchCategory(for recipe: Recipe) {
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let categories = try Constants.context.fetch(categoryFetchRequest)
            for category in categories {
                if category.categoryName == "Meat" {
                    category.addToRecipe(recipe)
                }
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchIngredients(for recipe: Recipe) {
        let ingredientFetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let shrimp = "shrimp"
        let oliveOil = "olive oil"
        let butter = "butter"
        let salt = "salt"
        let pepper = "pepper"
        let garlic = "garlic"
        
        
        do {
            ingredients = try Constants.context.fetch(ingredientFetchRequest)

            for ingredient in ingredients {
                if ingredient.ingredientName == shrimp || ingredient.ingredientName == oliveOil || ingredient.ingredientName == butter || ingredient.ingredientName == salt || ingredient.ingredientName == pepper || ingredient.ingredientName == garlic {
//                    ingredient.isSelected = true
                    ingredient.addToRecipe(recipe)
                }
                    
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func generateIngredients() {
        let ingredientsList = ["ground beef", "turkey", "chicken thighs", "shrimp", "tuna fish", "crab", "lamb", "steak", "ground turkey", "chicken breast", "parmesan cheese", "milk", "cream cheese", "cheddar cheese", "yogurt", "buttermilk", "condensed milk", "tilapia", "salmon", "broccoli", "green beans", "tomatoes", "sweet potatoes", "onions", "mushrooms", "lettuce", "shallots", "pumpkin", "jalapeño", "heavy cream","fish stock", "cod", "cat fish","bread crumbs", "salt", "pepper", "soy sauce", "flour","olive oil", "garlic", "butter", "corn","carrot","bell pepper", "spinach","coconut oil","tomato puree","vegetable oil","pasta" ]
    
    for ingredient in ingredientsList {
        let myIngredient = Ingredient(context: Constants.context)
        myIngredient.ingredientName = ingredient
        Constants.appDelegate.saveContext()
    }
}
    
    func delete() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
           let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

           do {
            try Constants.context.execute(deleteRequest)
            try Constants.context.save()
           } catch {
               print ("There was an error")
           }
    }
    
 

//MARK: - Edit Recipe Segue
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.editRecipe {
        if let destination = segue.destination as? RecipeVC {
            let indexPath = tableView.indexPathForSelectedRow
            if let objects = controller.fetchedObjects, objects.count > 0 {
                selectedRecipe = objects[indexPath!.row]
                destination.recipeToEdit = selectedRecipe
                }
            }
        }
    }
}

//MARK: - NSFetchControllerDelegate
extension MainVC {
func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
        if let indexPath = newIndexPath {
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    case .delete:
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    case .update:
        if let indexPath = indexPath {
            let cell = tableView.cellForRow(at: indexPath) as! RecipeCell
            cell.configureCell(recipe: anObject as! Recipe)
        }
    case .move:
        if let indexPath = indexPath {
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    @unknown default:
        break
    }
}

func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
}
func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeReuseCell, for: indexPath) as! RecipeCell
        
        let recipe = controller.object(at: indexPath)
      
        cell.configureCell(recipe: recipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = controller.object(at: indexPath)
            Constants.context.delete(recipeToDelete)
//            Constants.appDelegate.saveContext()
            do {
                try Constants.context.save()
            } catch  {
                print(error)
            }
            
        }
    }
}

