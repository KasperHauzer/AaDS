//
//  ViewController.swift
//  SecondLab
//
//  Created by Arsanukaev on 24/09/2018.
//  Copyright © 2018 Arsanukaev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    /**
     Текстовое поле с длинами работ.
    */
    @IBOutlet weak var Works: NSTextField!
    
    /**
     Текстовое поле с числом работников.
    */
    @IBOutlet weak var CountOfEmployees: NSTextField!
    
    /**
     Текстовое поле для вывода схемы распределения.
    */
    @IBOutlet weak var Console: NSTextField!
    
    /**
     4 5 2 3 6 1 7
    */
    @IBAction func bCalculate(_ sender: NSButton) {
            
        //Основная входная информация: длины работ и число работников и константа T.
        let count = GetCountOfEmployees() ?? 0
        var works = GetWorks() ?? [0]
        let T = GetT() ?? 0
        var i = 0
        
        //Индекс выполняемой работы для представления как типа литерала.
        var lableIndex = 97
        var lable = Character.init(Unicode.Scalar.init(lableIndex)!)
        
        //Индекс выполняемой работы и номер работника.
        var workIndex = 0
        var currentEmployee = 1
        let summ = GetSumm(from: works)
        
        //Выводим заголовки столбцов
        Console.stringValue = ""
        for x in 0..<T {
            Console.stringValue += "\t\(x + 1)"
        }
        
        //Вывод в консоль результатов.
        Console.stringValue += "\n\(GetEmoji(currentEmployee))\t"
        for x in 0..<summ {
    
            if i == T && currentEmployee + 1 <= count {
                currentEmployee += 1
                Console.stringValue += "\n\(GetEmoji(currentEmployee))\t"
                i = 0
            }
        
            if works[workIndex] == 0 && workIndex + 1 < works.count {
                workIndex += 1
                lableIndex += 1
                lable = Character.init(Unicode.Scalar.init(lableIndex)!)
            }
            
            Console.stringValue += String(lable) + "\t"
            works[workIndex] -= 1
            i += 1
            
            if x + 1 == summ { Console.stringValue += "\n" }
            while x + 1 == summ && currentEmployee < count{
                currentEmployee += 1
                Console.stringValue += "\n\(GetEmoji(currentEmployee)) - бездельник"
            }
        }
        
        Console.stringValue += "\n\nT = \(T)"
    }
    
    func Alert(_ title: String, text: String) {
        
        let alert = NSAlert.init()
        alert.messageText = title
        alert.informativeText = text
        alert.addButton(withTitle: "Понятно")
        
        alert.runModal()
    }
    
    func IsNorm(_ string: String) -> Bool {
        
        if string.isEmpty { return false }
        
        let allowedSign : Array<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " "]
        for i in string {
            if (!allowedSign.contains(i)) { return false }
        }
        
        return true
    }
    
    func GetWorks() -> Array<Int>? {
        if !IsNorm(Works.stringValue) {
            Alert("Ошибка", text: "Введите длины работ.")
            return nil
        }
        
        var array = Array<Int>.init()
        let text = Works.stringValue.split(separator: " ")
        
        for i in text {
            array.append(Int(i) ?? 0)
        }
        
        return array
    }
    
    func GetCountOfEmployees() -> Int? {
        if !IsNorm(CountOfEmployees.stringValue) {
            Alert("Ошибка", text: "Введите число работников.")
            return nil
        }
        
        return Int(CountOfEmployees.stringValue) ?? 0
    }
    
    func GetSumm(from array: Array<Int>) -> Int {
        
        var summ = 0
        for i in array {
            summ += i
        }
        
        return summ
    }
    
    func GetT() -> Int? {
        
        if let countOfEmployees = GetCountOfEmployees(), let works = GetWorks() {
            
            if works.max()! >= GetSumm(from: works) / countOfEmployees {
                return works.max()!
            }
            else {
                let a = GetSumm(from: works)
                let b = countOfEmployees
                
                if (a % b) != 0 {
                    return Int(a / b) + 1
                }
                else {
                    return Int(a / b)
                }
            }
        }
        
        return nil
    }
    
    func GetEmoji(_ value: Int) -> String {
        let scalar = UnicodeScalar.init(value + 0x1F600)
        return UnicodeScalarType.init(scalar!)
    }
}

