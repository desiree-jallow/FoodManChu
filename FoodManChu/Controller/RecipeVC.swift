//
//  RecipeVC.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit
import CoreData

class RecipeVC: UIViewController  {

    @IBOutlet weak var instructionsTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prepTextField: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var prepSlider: UISlider!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let picker = UIPickerView()
    var imagePicker: UIImagePickerController!
    
    var categories = [Category]()
    var ingredientsArray = [Ingredient]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        prepTextField.delegate = self
        categoryTextField.inputView = picker
        picker.delegate = self
//        generateCategories()
        fetchCategories()
        
       
        // Do any additional setup after loading the view.
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newRecipe = Recipe(context: Constants.context)
        newRecipe.categoryType?.categoryName = categoryTextField.text
        newRecipe.instructions = instructionsTextField.text
        newRecipe.recipeDescription = descTextField.text
        newRecipe.recipeName = nameTextField.text
        
        let photo = Image(context: Constants.context)
        photo.image = recipeImage.image
        newRecipe.image = photo
        
        if let prepText = prepTextField.text, let doubleText = Double(prepText) {
            newRecipe.prepTime = doubleText
        }
        for ingredient in ingredientsArray {
            ingredient.addToRecipe(newRecipe)
        }
        Constants.appDelegate.saveContext()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let newValue = Int(sender.value/5) * 5
        sender.setValue(Float(newValue), animated: false)
        prepTextField.text = String(newValue)
    
    }
    
    //MARK: - UIImagePicker Delegate
     
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
       
    }

    
    func generateCategories() {
        
        let categories = ["Meat", "Vegetarian", "Vegan", "Paleo", "Keto"]
        for category in categories {
            let myCategory = Category(context: Constants.context)
            myCategory.categoryName = category
            Constants.appDelegate.saveContext()
        }
    }
    
    func fetchCategories() {
        
            let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
            
            do {
                categories = try Constants.context.fetch(fetchRequest)
            } catch  {
                print(error.localizedDescription)
            }
            
        }
    }
//MARK: - UIImage Picker
extension RecipeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            recipeImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIPickerView
extension RecipeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].categoryName
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row].categoryName
        self.view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension RecipeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = prepTextField.text {
            let value = Float(text) ?? 240.0
            prepSlider.setValue(value, animated: true)
            prepTextField.resignFirstResponder()
        }
        return true
    }
}
