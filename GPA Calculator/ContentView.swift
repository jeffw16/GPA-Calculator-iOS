//
//  ContentView.swift
//  GPA Calculator
//
//  Created by Jeffrey Wang on 7/17/20.
//  Copyright © 2020 MyWikis LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var weightedGpa: String = "--"
    @State private var unweightedGpa: String = "--"
    @State private var roundedUnweightedGpa: String = "--"
    @State private var maxGpaRegStr: String = "4.0"
    @State private var maxGpaHonStr: String = "5.0"
    @State private var maxGpaApStr: String = "6.0"
    @State private var gradeVals: [String] = [
        "100",
        "100",
        "100",
        "100",
        "100",
        "100",
        "100",
        "100"
    ]
    @State private var levelVals: [Level] = [
        .reg,
        .reg,
        .reg,
        .reg,
        .reg,
        .reg,
        .reg
    ]
    @State private var grades: [Grade] = [
        Grade(id: 0, level: .reg, grade: 100),
        Grade(id: 1, level: .reg, grade: 100),
        Grade(id: 2, level: .reg, grade: 100),
        Grade(id: 3, level: .reg, grade: 100),
        Grade(id: 4, level: .reg, grade: 100),
        Grade(id: 5, level: .reg, grade: 100),
        Grade(id: 6, level: .reg, grade: 100)
    ]
    @State private var idCount: Int = 7
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all).onTapGesture {
                    self.endEditing(true)
                }
                VStack {
                    Spacer()
                    HStack {
                        Text("GPA max for Regular/Academic classes:").frame(minWidth: 250, idealWidth: 250, maxWidth: 250, alignment: .leading)
                        TextField("maxGpaRegField", text: $maxGpaRegStr).textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 50, idealWidth: 100, maxWidth: 100, alignment: .trailing)
                    }
                    HStack {
                        Text("GPA max for Honors/Pre-AP classes:").frame(minWidth: 250, idealWidth: 250, maxWidth: 250, alignment: .leading)
                        TextField("maxGpaHonField", text: $maxGpaHonStr).textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 50, idealWidth: 100, maxWidth: 100, alignment: .trailing)
                    }
                    HStack {
                        Text("GPA max for AP classes:").frame(minWidth: 250, idealWidth: 250, maxWidth: 250, alignment: .leading)
                        TextField("maxGpaApField", text: $maxGpaApStr).textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 50, idealWidth: 100, maxWidth: 100, alignment: .trailing)
                    }
                    HStack {
                        Text("Weighted GPA:").frame(minWidth: 250, idealWidth: 250, maxWidth: 250, alignment: .trailing)
                        TextField("weightedGpaField", text: $weightedGpa).frame(minWidth: 100, idealWidth: 100, maxWidth: 250, alignment: .leading)
                    }
                    /*
                    HStack {
                        Text("Unweighted GPA:").frame(minWidth: 250, idealWidth: 250, maxWidth: 250, alignment: .trailing)
                        TextField("unweightedGpaField", text: $unweightedGpa).frame(minWidth: 100, idealWidth: 100, maxWidth: 250, alignment: .leading)
                    }
                    HStack {
                        Text("Rounded unweighted GPA:").frame(minWidth: 250, idealWidth: 250, maxWidth: 250, alignment: .trailing)
                        TextField("roundedUnweightedGpaField", text: $roundedUnweightedGpa).frame(minWidth: 100, idealWidth: 100, maxWidth: 250, alignment: .leading)
                    }
                     */
                    Button(action: {
                        var dividend: Double = 0.0
                        let divisor: Double = Double(self.idCount)
                        // Calculate the GPA
                        for i in 0..<self.idCount {
                            var addMoreToGpa: Double = 0.0
                            switch self.levelVals[i] {
                            case .reg:
                                addMoreToGpa = (Double(self.maxGpaRegStr) ?? 4.0) - 4.0
                            case .hon:
                                addMoreToGpa = (Double(self.maxGpaHonStr) ?? 5.0) - 4.0
                            case .ap:
                                addMoreToGpa = (Double(self.maxGpaApStr) ?? 6.0) - 4.0
                            }
                            
                            var dividendPreGpa: Double = Double(self.gradeVals[i])!
                            if dividendPreGpa > 100 {
                                dividendPreGpa = 100
                            } else if dividendPreGpa < 0 {
                                dividendPreGpa = 0
                            }
                            dividendPreGpa -= 60
                            
                            var gpaForClass: Double = dividendPreGpa / 10
                            gpaForClass += addMoreToGpa
                            
                            if gpaForClass < 0 {
                                gpaForClass = 0
                            }
                            
                            dividend += gpaForClass
                        }
                        let quotient: Double = dividend / divisor
                        
                        self.weightedGpa = String(format: "%.4f", quotient)
                    }) {
                        Text("Calculate GPA")
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            // add a class
                            self.grades.append(Grade(id: self.idCount, level: .reg, grade: 100))
                            self.gradeVals.append("100")
                            self.levelVals.append(.reg)
                            self.idCount += 1
                        }) {
                            Image(systemName: "plus")
                            Text("Add class")
                        }
                        Spacer()
                        Button(action: {
                            // remove a class
                            if self.idCount > 1 {
                                self.grades.removeLast()
                                self.gradeVals.removeLast()
                                self.levelVals.removeLast()
                                self.idCount -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                            Text("Remove class")
                        }
                        Spacer()
                    }
                    ScrollView {
                        ForEach(grades, id: \.id) { grade in
                            HStack {
                                Text("Class \(grade.id! + 1)")
                                    .frame(minWidth: 75, idealWidth: 75, maxWidth: 75, alignment: .trailing)
                                TextField("\(grade.id!)", text: self.$gradeVals[grade.id!]).textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(minWidth: 50, idealWidth: 100, maxWidth: 100, alignment: .trailing)
                                Picker("level\(grade.id!)", selection: self.$levelVals[grade.id!]) {
                                    Text("Regular").tag(Level.reg)
                                    Text("Honors").tag(Level.hon)
                                    Text("AP").tag(Level.ap)
                                }.pickerStyle(SegmentedPickerStyle())
                            }
                        }
                    }
                }
            }.navigationBarTitle("GPA Calculator")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
