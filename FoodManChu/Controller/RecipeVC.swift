//
//  RecipeVC.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit
import CoreData

class RecipeVC: UIViewController {

    @IBOutlet weak var instructionsTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prepTextField: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var prepSlider: UISlider!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let picker = UIPickerView()
    
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepTextField.delegate = self
        categoryTextField.inputView = picker
        picker.delegate = self
//        generateCategories()
        fetchCategories()
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let newValue = Int(sender.value/5) * 5
        sender.setValue(Float(newValue), animated: false)
        prepTextField.text = String(newValue)
    
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
