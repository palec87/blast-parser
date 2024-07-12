//
//  Parser.swift
//  blast_parser
//
//  Created by João Varela on 12/07/2024.
//

import Foundation

struct Parser {
    var path = String()
    
    init(path:String) {
        self.path = path
    }
    
    func parse(contents:String, column:Int) -> [String]{
        let lines = parseLines(contents)
        var columnItems = [String]()
        
        for line in lines {
            let columns = line.components(separatedBy: .whitespaces)
            let count = columns.count
            if column > 0 && column <= count {
                columnItems.append(columns[column - 1])
            }
        }
        return columnItems
    }
    
    func read() ->String? {
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        }
        
        catch {
            return nil
        }
    }
    
    private func parseLines(_ contents:String) -> [String] {
        return contents.components(separatedBy: .newlines)
    }
}
