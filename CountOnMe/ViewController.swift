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
        calculator.clear()
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
            presentAlert(message: "invalid Operator")
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
            let alertVC = UIAlertController(title: "Zéro!", message: "an operator is still used", preferredStyle: .alert)
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
               if let lastElement = calculator.elements.last, lastElement == "0" {
                   presentAlert(message: "Can't divide by zero")
               } else {
                   calculator.addElement("/")
                   textView.text.append("/")
               }
           } else {
               presentAlert(message: " invalid Operator")
           }
    }
    
    @IBAction func tappedMultiButton(_ sender: UIButton) {
        if let lastResult = calculator.lastResult {
            textView.text = "\(lastResult) *"
            calculator.clear()
            calculator.addElement(lastResult)
            calculator.addElement("*")
        } else if calculator.canAddOperator {
               calculator.addElement("*")
               textView.text.append("*")
           } else {
               presentAlert(message: " invalid Operator")
           }
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calculator.expressionIsCorrect else {
            presentAlert(message: "Incorrect expression !")
            return
        }

        guard calculator.expressionHaveEnoughElement else {
            presentAlert(message: "Start a new calc !")
            return
        }

        if let result = calculator.calculate() {
            textView.text.append("=\(result)")
        } else {
            presentAlert(message: "Calcul error.")
        }
    }

    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

}

