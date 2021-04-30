//
//  ViewController.swift
//  CalculadoraIOS
//
//  Created by user on 30/3/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLbl: UILabel!
    
    
    @IBOutlet weak var operadorAC: UIButton!
    @IBOutlet weak var operadorPlus: UIButton!
    @IBOutlet weak var operadorPercent: UIButton!
    @IBOutlet weak var operadorResul: UIButton!
    @IBOutlet weak var operadorSum: UIButton!
    @IBOutlet weak var operadorRest: UIButton!
    @IBOutlet weak var operadorMult: UIButton!
    @IBOutlet weak var operadorDiv: UIButton!
    
    @IBOutlet weak var numeroDecimal: UIButton!
    
    
   private var total :Double = 0 //Total
   private var temp: Double = 0 //Valor por pantalla
   private var operating = false //Indicar si se ha seleccionado un operador
   private var decimal = false //Indicar si el valor es decimal
   private var operation: OperetacionType = .none //operacion actual
   
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kMaxValue: Double = 999999999
    private let kMinValue: Double = 0.00000001
    
    
    private enum OperetacionType{
        
        case none, addiction, substraction, multiplication, division, percent
    }
    
    private let auxFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numeroDecimal.setTitle(kDecimalSeparator, for: .normal)
    }

    @IBAction func operadorACAction(_ sender: UIButton) {
        clear()
    }
    @IBAction func operadorPlusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLbl.text = printFormatter.string(from: NSNumber(value: temp))
    }
    @IBAction func operadorPercentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        operating = true
        operation = .percent
        
        result()
    }
    @IBAction func operadorResulAction(_ sender: UIButton) {
        result()
        
        
    }
    @IBAction func operadorSumAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .addiction
        
    }
    @IBAction func operadorRestAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .substraction
    }
    @IBAction func operadorMultAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .multiplication
        
    }
    @IBAction func operadorDivAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .division
    }
    
    @IBAction func numeroDecimalAction(_ sender: UIButton) {
        let currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
            
        }
        resultLbl.text = resultLbl.text! + kDecimalSeparator
        decimal = true
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        operadorAC.setTitle("C", for: .normal)
        var currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
            
        }
        //Hemos seleccionado una operacion
        if operating{
            total = total == 0 ? temp : total
            resultLbl.text = ""
            currentTemp = ""
            operating = false
        }
        //Hemos seleccionado decimales
        if decimal{
            currentTemp = currentTemp + kDecimalSeparator
            decimal = false
        }
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLbl.text = printFormatter.string(from: NSNumber(value: temp))
        print(sender.tag)
    }
    
    //Limpia los valores
    private func clear(){
        operation = .none
        operadorAC.setTitle("AC", for: .normal)
        if temp != 0{
            temp = 0
            resultLbl.text = "0"
            
        }else{
            total = 0
        }
        
    }
    // Obtiene el resultado final
    private func result(){
        switch operation {
        
        case .none:
            //No hacemos nada
            break
        case .addiction:
            total = total + temp
            break
        case .substraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total /  temp
            break
        case .percent:
            total = total / 100
            break
        }
        //formateo Pantalla
        if total <= kMaxValue || total >= kMinValue {
            resultLbl.text = printFormatter.string(from: NSNumber(value: total))
        }
        print ("TOTAL: ", total )
    }
}

