//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit
import CoreData

class IngredientsVC: UITableViewController {
    
    
    var ingredients = [Ingredient]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        generateIngredients()
        fetchIngredients()
//        delete()
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
            fetchIngredients()
            tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
    
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source and delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoIngredientsCell = tableView.dequeueReusableCell(withIdentifier: Constants.ingredientsReuseCell, for: indexPath)
        
        let userIngredientsCell = tableView.dequeueReusableCell(withIdentifier: Constants.userIngredientsCell, for: indexPath) as! UserIngredientsCell
        
        let ingredient = ingredients[indexPath.row]
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        ingredient.isSelected.toggle()
        Constants.appDelegate.saveContext()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//MARK: - Delete ingredient
extension IngredientsVC: CustomCellDelegate {
    func customCell(cell: UserIngredientsCell, didTappedThe button: UIButton?) {
        let indexPath = tableView.indexPath(for: cell)
        let ingredient = ingredients[indexPath!.row]
        Constants.context.delete(ingredient)
        ingredients.remove(at: indexPath!.row)
        Constants.appDelegate.saveContext()
        tableView.reloadData()
    }
    
}
    
//MARK: - Generate and Fetch Ingredients List
    extension IngredientsVC {
        func generateIngredients() {
            let ingredientsList = ["ground beef", "turkey", "chicken thighs", "shrimp", "tuna fish", "crab", "lamb", "steak", "ground turkey", "chicken breast", "parmesan cheese", "milk", "cream cheese", "cheddar cheese", "yogurt", "buttermilk", "condensed milk", "tilapia", "salmon", "broccoli", "green beans", "tomatoes", "sweet potatoes", "onions", "mushrooms", "lettuce", "shallots", "pumpkin", "jalapeño", "heavy cream","fish stock", "cod", "cat fish","bread crumbs", "salt", "pepper", "soy sauce", "flour","olive oil", "garlic", "butter", "corn","carrot","bell pepper", "spinach","coconut oil","tomato puree","vegetable oil","pasta" ]
        
        for ingredient in ingredientsList {
            let myIngredient = Ingredient(context: Constants.context)
            myIngredient.ingredientName = ingredient
            Constants.appDelegate.saveContext()
        }
    }
    
    func fetchIngredients() {
        let fetchRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "ingredientName", ascending: true)]
        
        do {
            ingredients = try Constants.context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
            }
        }
        
        func delete() {
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

