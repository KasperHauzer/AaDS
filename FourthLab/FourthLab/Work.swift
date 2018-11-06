//
//  Work.swift
//  FourthLab
//
//  Created by Arsanukaev on 11/10/2018.
//  Copyright © 2018 Arsanukaev. All rights reserved.
//

import Cocoa

/**
 Инкапсулирует выполняемые работы.
 - Author: KasperHauzer.
 */
public class Work: CustomStringConvertible, CustomDebugStringConvertible {
    
    /**
     Наименование работы.
     */
    public let title: String
    
    /**
     Длина первой половины работы.
     */
    public let firstPartLength: Int
    
    /**
     Длина второй половины работы.
     */
    public let secondPartLength: Int
    
    /**
     Указывает, была ли выполнена первая часть работы.
     */
    public var isCompleted = false
    
    public var startUp = 0
    
    public var description: String {
        return "\(title) \(firstPartLength) \(secondPartLength)"
    }
    
    public var debugDescription: String {
        return description
    }
    
    /**
     Создает новый экземпляр класса.
     - Parameter title: Наименование работы.
     - Parameter firstPartLength: Длина первой части работы.
     - Parameter secondPartLength: Длина второй части работы.
     */
    public init(title: String, firstPartLength: Int, secondPartLength: Int)
    {
        self.title = title
        self.firstPartLength = firstPartLength
        self.secondPartLength = secondPartLength
    }
    
    /**
     Создает новый экземпляр класса.
     - Parameter parsedString: Строка, которая заведомо может быть преобразована в работу.
     - Important:   Чтобы корректно преобразовать строку, она должна иметь следующий вид:
                    <наименование работы> <длина первой паловины> <длина второй половины>
     */
    public convenience init(parsedString: String)
    {
        let strings = parsedString.split(separator: " ")
        
        if strings.count == 3 {
            let title = String(strings[0])
            let firstPathLength = Int(strings[1]) ?? -1
            let secondPartLength = Int(strings[2]) ?? -1
            
            self.init(title: title, firstPartLength: firstPathLength, secondPartLength: secondPartLength)
        } else {
            self.init(title: "", firstPartLength: -1, secondPartLength: -1)
        }
    }
    
    /**
     Считывает данные из файла в строку.
     - Parameter file: Путь к файлу, из которого необходимо считать строку.
     - Returns: Cтроку из файла или же, в случае, если не удалось прочитать
                файл - возвращает пустую строку.
     */
    private class func readAllText(file: String) -> String
    {
        do {
            return try String.init(contentsOfFile: file)
        } catch {
            return "";
        }
    }
    
    /**
     Считывает строки из файла и возвращает их.
     - Parameter file: Путь к файлу, из которого необходимо считать строки.
     - Returns: Cтроки из файла или же, в случае, если не удалось прочитать
                файл - возврощает пустой массив.
     */
    private class func readLines(file: String) -> Array<String>
    {
        var strings = Array<String>.init()
        let text = readAllText(file: file)
        
        for i in text.split(separator: "\n") {
            strings.append(String(i))
        }
        
        return strings
    }
    
    /**
     Считывает строки файла как перечисления работ.
     - Parameter fromFile: Путь к файлу, из которого необходимо считать перечисление работ.
     - Returns: Список работ из файла, или же, в случае, если не удалось прочитать
                файл - возвращает пустой массив.
     - Important:   Чтобы корректно считались все работы файл должен предсталять из себя
                    строго структурированное перечисление строк, каждая из которых выглядит
                    следующим образом:
                    <наименование работы> <длина первой паловины> <длина второй половины>
     */
    public class func readAsWorks(fromFile: String) -> Array<Work>
    {
        var works = Array<Work>.init()
        
        for i in readLines(file: fromFile) {
            works.append(Work.init(parsedString: i))
        }
        
        return works
    }
    
    /**
     Сравниавает две работы по правилу сравнения двух работ для типов задач из ТЗ.
     Данный метод написан для передачи как закрытие для сортировки массива работ.
     */
    private class func sortingMethod(left: Work, right: Work) -> Bool
    {
        let a = Swift.min(left.firstPartLength, right.secondPartLength)
        let b = Swift.min(left.secondPartLength, right.firstPartLength)
        
        if a <= b {
            return true;
        } else {
            return false;
        }
    }
    
    /**
     Распределяет работы наиболее оптимальным образом между указанным числом рабочих.
     - Parameter array: Массив работ, которые необходимо распределить.
     - Parameter for countOfEmployee:   Число работников, между которыми необходимо
                                        распределить работы.
     - Returns: Возвращает список, которые представляет индексы работников "как есть" в
                самом списве, где под каждым индексом находится сложенный список работ,
                которые определяет последовательность выполнения работ. Вложенные списки
                огранизовываются таким образом, чтобы инжексы всех вложенных списков
                определяли индекс итерации выполнения работ, на которой они выполняются.
     */
    public class func distribute(array: Array<Work>) -> Array<Array<String>>
    {
        let array = array.sorted(by: sortingMethod)
        var works = Array.init(repeating: Array<String>.init(), count: 2)
        
        for i in array {
            for _ in 0..<i.firstPartLength {
                works[0].append(i.title + "\t")
            }
        }
        
        var currentPosition = 0
        var needPosition = 0
        
        for i in array {
            needPosition += i.firstPartLength
            
            while currentPosition < needPosition {
                works[1].append("-\t")
                currentPosition += 1
            }
            
            for _ in 0..<i.secondPartLength {
                works[1].append(i.title + "\t")
            }
            
            currentPosition += i.secondPartLength;
        }
        
        return works;
    }
}
