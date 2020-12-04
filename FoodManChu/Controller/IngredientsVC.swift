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
    var userIngredients = [Ingredient]()
    var ingredientName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        generateIngredients()
        fetchIngredients()
//        delete()
    }

    @IBAction func addIngredient(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: "Add Ingredient", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "ingredient name"
            if let text = textField.text {
                self.ingredientName = text
            }
        }
        
        let action = UIAlertAction(title: "add", style: .default) { [self] (add) in
            let newIngredient = Ingredient(context: Constants.context)
            newIngredient.ingredientName = ingredientName
            newIngredient.isUserCreated = true
            if !ingredients.contains(newIngredient) {
                ingredients.append(newIngredient)
                Constants.appDelegate.saveContext()
                tableView.reloadData()
            }
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
        
        if ingredients[indexPath.row].isUserCreated == true {
            userIngredientsCell.ingredientLabel.text = ingredients[indexPath.row].ingredientName
            return userIngredientsCell
        } else {
            autoIngredientsCell.textLabel?.text = ingredients[indexPath.row].ingredientName
            return autoIngredientsCell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
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

