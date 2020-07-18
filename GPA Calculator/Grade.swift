//
//  Grade.swift
//  GPA Calculator
//
//  Created by Jeffrey Wang on 7/17/20.
//  Copyright © 2020 MyWikis LLC. All rights reserved.
//

import Foundation

enum Level {
    case reg
    case hon
    case ap
}

class Grade {
    var id: Int?
    var level: Level?
    var grade: Double?
    
    init(id: Int, level: Level, grade: Double) {
        self.id = id
        self.level = level
        self.grade = grade
    }
    
    func setGrade(_ grade: Double) {
        self.grade = grade
    }
}
