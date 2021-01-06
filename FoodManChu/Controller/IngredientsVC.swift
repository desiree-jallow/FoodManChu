//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit
import CoreData

class IngredientsVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
//    var ingredients = [Ingredient]()
    var controller: NSFetchedResultsController<Ingredient>!
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        generateIngredients()
        fetchIngredients(for: recipe)
//        deleteIngredients()
        navigationController?.delegate = self
        Constants.context.mergePolicy  = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
//MARK: - Add ingredient
    @IBAction func addIngredient(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "", message: "Add Ingredient", preferredStyle: .alert)
        
        alertController.addTextField { (ingredientTextField) in
            textField = ingredientTextField
            textField.placeholder = "ingredient name"
            
        }
        
        let action = UIAlertAction(title: "add", style: .default) { [self] (add) in
            let newIngredient = Ingredient(context: Constants.context)
            newIngredient.ingredientName = textField.text
            newIngredient.isUserCreated = true
            Constants.appDelegate.saveContext()
            fetchIngredients(for: recipe)
            tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
    
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source and delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoIngredientsCell = tableView.dequeueReusableCell(withIdentifier: Constants.ingredientsReuseCell, for: indexPath)
        
        let userIngredientsCell = tableView.dequeueReusableCell(withIdentifier: Constants.userIngredientsCell, for: indexPath) as! UserIngredientsCell
        
        let ingredient = controller.object(at: indexPath)
        
        if ingredient.isUserCreated == true {
            userIngredientsCell.accessoryType = ingredient.isSelected ? .checkmark : .none
            userIngredientsCell.configureCell(ingredient: ingredient)
            userIngredientsCell.cellDelegate = self
            
            return userIngredientsCell
        
        } else {
            autoIngredientsCell.accessoryType = ingredient.isSelected ? .checkmark : .none
            autoIngredientsCell.textLabel?.text = ingredient.ingredientName
            return autoIngredientsCell
       }
    }
    //MARK: - Add checkmark to selected ingredient
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = controller.object(at: indexPath)
        ingredient.isSelected.toggle()
//        Constants.appDelegate.saveContext()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - NSFetchControllerDelegate
extension IngredientsVC {
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
            let ingredient = controller.object(at: indexPath)
            if (ingredient as! Ingredient).isUserCreated {
                let userCell = tableView.cellForRow(at: indexPath) as? UserIngredientsCell
                userCell?.configureCell(ingredient: anObject as! Ingredient)
            }
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
//MARK: - Save Ingredients to Recipe
extension IngredientsVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        for ingredient in controller.fetchedObjects! {
            if ingredient.isSelected {
                (viewController as? RecipeVC)?.ingredientsArray.append(ingredient)
            }
        }
    }
}
//MARK: - Delete ingredient
extension IngredientsVC: CustomCellDelegate {
    func customCell(cell: UserIngredientsCell, didTappedThe button: UIButton?) {
        let indexPath = tableView.indexPath(for: cell)
        let ingredient = controller.object(at: indexPath!)
        
        Constants.context.delete(ingredient)
        Constants.appDelegate.saveContext()
        tableView.reloadData()
    }
    
}
    
//MARK: - Generate and Fetch Ingredients List
    extension IngredientsVC {
//        func generateIngredients() {
//            let ingredientsList = ["ground beef", "turkey", "chicken thighs", "shrimp", "tuna fish", "crab", "lamb", "steak", "ground turkey", "chicken breast", "parmesan cheese", "milk", "cream cheese", "cheddar cheese", "yogurt", "buttermilk", "condensed milk", "tilapia", "salmon", "broccoli", "green beans", "tomatoes", "sweet potatoes", "onions", "mushrooms", "lettuce", "shallots", "pumpkin", "jalapeño", "heavy cream","fish stock", "cod", "cat fish","bread crumbs", "salt", "pepper", "soy sauce", "flour","olive oil", "garlic", "butter", "corn","carrot","bell pepper", "spinach","coconut oil","tomato puree","vegetable oil","pasta" ]
//        
//        for ingredient in ingredientsList {
//            let myIngredient = Ingredient(context: Constants.context)
//            myIngredient.ingredientName = ingredient
//            Constants.appDelegate.saveContext()
//        }
//    }
    
        func fetchIngredients(for recipe: Recipe?) {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let sort = NSSortDescriptor(key: "ingredientName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Constants.context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        controller.delegate = self
        
        do {
            try controller.performFetch()
                for ingredient in controller.fetchedObjects! {
                    if recipe == nil {
                        ingredient.isSelected = false
                    } else if recipe?.ingredient?.contains(ingredient) == true {
                        ingredient.isSelected = true
                    } else if recipe?.ingredient?.contains(ingredient) == false {
                        ingredient.isSelected = false
                    }
            }
        } catch  {
            print(error.localizedDescription)
            }
        }
        
        
        func deleteIngredients() {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredient")
               let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

               do {
                try Constants.context.execute(deleteRequest)
                try Constants.context.save()
               } catch {
                   print ("There was an error")
               }
        }
    }

