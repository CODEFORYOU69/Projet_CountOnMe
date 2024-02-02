//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var calculator = Calculator()

    @IBAction func TappedAllClear(_ sender: UIButton) {
        textView.text = ""
        calculator.clear() // Réinitialise l'instance de Calculator
    }
    
    @IBAction func tappedCButton(_ sender: UIButton) {
        guard !calculator.elements.isEmpty else { return }

            calculator.removeLastElement()
            textView.text = calculator.currentExpression
    }
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    
        
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        if let lastResult = calculator.lastResult {
            textView.text = lastResult
            calculator.clear()
            calculator.addElement(lastResult)
        }
        
        calculator.addElement(numberText)
        textView.text.append(numberText)
    }

    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if let lastResult = calculator.lastResult {
            textView.text = "\(lastResult) +"
            calculator.clear()
            calculator.addElement(lastResult)
            calculator.addElement("+")
        } else if calculator.canAddOperator {
            calculator.addElement("+")
            textView.text.append("+")
        } else {
            presentAlert(message: "Opérateur invalide")
        }
    }

    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if let lastResult = calculator.lastResult {
            textView.text = "\(lastResult) -"
            calculator.clear()
            calculator.addElement(lastResult)
            calculator.addElement("-")
        } else if calculator.canAddOperator {
            textView.text.append("-")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    
    @IBAction func tappedDivideButton(_ sender: UIButton) {
        if let lastResult = calculator.lastResult {
            textView.text = "\(lastResult) /"
            calculator.clear()
            calculator.addElement(lastResult)
            calculator.addElement("/")
        } else if calculator.canAddOperator {
               // Si le dernier élément est zéro, empêcher la division
               if let lastElement = calculator.elements.last, lastElement == "0" {
                   presentAlert(message: "Division par zéro non autorisée")
               } else {
                   calculator.addElement("/")
                   textView.text.append("/")
               }
           } else {
               presentAlert(message: "Opérateur invalide")
           }
    }
    
    @IBAction func tappedMultiButton(_ sender: UIButton) {
        // Vérifier si un opérateur peut être ajouté à l'expression
        if let lastResult = calculator.lastResult {
            textView.text = "\(lastResult) *"
            calculator.clear()
            calculator.addElement(lastResult)
            calculator.addElement("*")
        } else if calculator.canAddOperator {
               calculator.addElement("*") // Ajouter l'opérateur de multiplication
               textView.text.append("*")
           } else {
               // Afficher une alerte si un opérateur ne peut pas être ajouté
               presentAlert(message: "Opérateur invalide")
           }
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calculator.expressionIsCorrect else {
            presentAlert(message: "Entrez une expression correcte !")
            return
        }

        guard calculator.expressionHaveEnoughElement else {
            presentAlert(message: "Démarrez un nouveau calcul !")
            return
        }

        if let result = calculator.calculate() {
            textView.text.append("=\(result)")
        }
    }
    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

}

