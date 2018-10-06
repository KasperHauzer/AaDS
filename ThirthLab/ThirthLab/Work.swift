//
//  File.swift
//  ThirthLab
//
//  Created by Arsanukaev on 30/09/2018.
//  Copyright © 2018 Arsanukaev. All rights reserved.
//

import Foundation

class Work : CustomStringConvertible, CustomDebugStringConvertible, Hashable, Comparable
{
    /**
     Название работы.
     */
    let title: String
    
    /**
     Приоритет работы.
     */
    var priority: Int
    
    /**
     Список обязательных предшествующих работ.
     */
    var listOfSuperWorks = Array<String>()
    
    /**
     Указывает, выполнена ли работа.
     */
    var isComplited = false
    
    /**
     Указывает, что текущая работ не имеет зависимых работ.
     */
    var hasChild = false
    
    /**
     Описание.
     */
    var description: String {
        return "\(title) - \(priority)"
    }
    
    /**
     Описание для отладчика.
     */
    var debugDescription: String {
        return description
    }
    
    /**
     Создает экземпляр класса.
     - Parameter title: название работы.
     */
    init(title: String)
    {
        self.title = title
        priority = 1
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func ==(left: Work, right: Work) -> Bool
    {
        return left.hashValue == right.hashValue
    }
    
    static func >(left: Work, right: Work) -> Bool
    {
        return left.hashValue > right.hashValue
    }
    
    static func <(left: Work, right: Work) -> Bool
    {
        return left.hashValue < right.hashValue;
    }
}
