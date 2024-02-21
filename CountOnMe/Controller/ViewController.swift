//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

struct CalculationHistoryEntry {
    let expression: String
    let result: String
}
class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    var acButtonPressCount = 0
    
    
    @IBOutlet weak var resultView: UITextView!
    
    @IBOutlet weak var historyLabel: UILabel!
    var calculationHistory: [CalculationHistoryEntry] = []
    
    var lastResult: String?
    
    var calculator = Calculator()
    var isResultDisplayed = false
    
    @IBAction func TappedAllClear(_ sender: UIButton) {
        acButtonPressCount += 1
        
        if acButtonPressCount == 2 {
            calculationHistory.removeAll()
            historyLabel.text = ""
            acButtonPressCount = 0
        }
        
        textView.text = ""
        resultView.text = ""
        calculator.clear()
        isResultDisplayed = false
    }
    
    @IBAction func tappedCButton(_ sender: UIButton) {
        guard !textView.text.isEmpty else { return }

        textView.text.removeLast()

        updateCalculatorElementsFromTextView()
    }

    func updateCalculatorElementsFromTextView() {
       
        calculator.elements = textView.text.split(separator: " ").map(String.init)
    }

    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    
    
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        acButtonPressCount = 0
        
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        
        if isResultDisplayed {
            textView.text = ""
            resultView.text = ""
            calculator.clear()
            isResultDisplayed = false
        }
        
        calculator.addElement(numberText)
        textView.text.append(numberText)
    }
    
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        acButtonPressCount = 0
        
        if isResultDisplayed {
            if let lastResult = self.lastResult {
                textView.text = lastResult + " + "
                calculator.clear()
                calculator.addElement(lastResult)
                isResultDisplayed = false
            }
        } else if calculator.canAddOperator {
            textView.text.append(" + ")
        } else {
            presentAlert(message: "can't add a new operator!")
        }
        calculator.addElement("+")
    }
    
    
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        acButtonPressCount = 0
        
        if isResultDisplayed {
            if let lastResult = self.lastResult {
                textView.text = "\(lastResult)"
                calculator.clear()
                calculator.addElement(lastResult)
                isResultDisplayed = false
            }
            textView.text.append("-")
            calculator.addElement("-")
        } else {
            if elements.isEmpty || Double(elements.last!) != nil {
                textView.text.append("-")
                calculator.addElement("-")
            }

            else if ["+", "*", "/"].contains(elements.last!) || (elements.count >= 2 && elements[elements.count - 2] != "-" && elements.last! == "-") {
                textView.text.append(" -")
                calculator.addElement("-")
            }
 
            else {
                presentAlert(message: "can't add a new operator!")
            }
        }
    }
    @IBAction func tappedDivideButton(_ sender: UIButton) {
        acButtonPressCount = 0
        
        if isResultDisplayed {
            if let lastResult = self.lastResult {
                textView.text = lastResult + " / "
                calculator.clear()
                calculator.addElement(lastResult)
                isResultDisplayed = false
            }
            calculator.addElement("/")
        } else if calculator.canAddOperator {
            textView.text.append(" / ")
            calculator.addElement("/")
        } else {
            presentAlert(message: "can't add a new operator!")
        }
    }
    @IBAction func tappedMultiButton(_ sender: UIButton) {
        acButtonPressCount = 0
        
        if isResultDisplayed {
            if let lastResult = self.lastResult {
                textView.text = lastResult + " * "
                calculator.clear()
                calculator.addElement(lastResult)
                isResultDisplayed = false
            }
            calculator.addElement("*") // Assurez-vous d'ajouter cette ligne ici
        } else if calculator.canAddOperator {
            textView.text.append(" * ")
            calculator.addElement("*")
        } else {
            presentAlert(message: "can't add a new operator!")
        }
    }

    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        acButtonPressCount = 0
        
        let calculationResult = calculator.calculate()
        
        switch calculationResult {
        case .success(let result):
            
            addCalculationToHistory(expression: calculator.currentExpression, result: result)
            
            
            resultView.text = result
            lastResult = result
            isResultDisplayed = true
        case .failure(let error):
            let message: String
            switch error {
            case .incorrectExpression:
                message = "Incorrect expression !"
            case .notEnoughElements:
                message = "not enough elements !"
            case .divisionByZero:
                message = "Can't divide by zero"
            case .other(let errorMessage):
                message = errorMessage
        
            }
            presentAlert(message: message)
            isResultDisplayed = false
        }
    }
    
    
    
    
    
    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    func addCalculationToHistory(expression: String, result: String) {
        let newEntry = CalculationHistoryEntry(expression: expression, result: result)
        calculationHistory.append(newEntry)
        
        if calculationHistory.count > 5 {
            calculationHistory.removeFirst()
        }
        
        let historyText = calculationHistory.reversed().map { "\($0.expression) = \($0.result)" }.joined(separator: "\n")
        historyLabel.text = historyText
    }
    
    
}

