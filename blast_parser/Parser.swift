//
//  Parser.swift
//  blast_parser
//
//  Created by João Varela on 12/07/2024.
//

//import Foundation
//
//class Parser {
//    let taxData:[String.UTF8View.SubSequence]
//    var taxIDs:[String]
//    var matchedIDs = [MatchedTaxID]()
//    var matchedTaxID:String?
//    
//    init(taxData: [String.UTF8View.SubSequence], taxIDs: [String]) {
//        self.taxData = taxData
//        self.taxIDs = taxIDs
//    }
//    
//    func parseDatabase() {
//        for dbtaxID in taxData {
//            for queryTaxID in taxIDs {
//                if dbtaxID.contains(queryTaxID.utf8) {
//                    if let records = String(dbtaxID)?.split(separator: "|") {
//                        if let record = records.first?.trimmingCharacters(in: .whitespacesAndNewlines) {
//                            if record == queryTaxID && records.count > 2 {
//                                let taxonomy = records[2]
//                                let matchedID = MatchedTaxID(taxID: queryTaxID,
//                                                             taxonomy: String(taxonomy))
//                                matchedIDs.append(matchedID)
//                                matchedTaxID = queryTaxID
//                            }
//                        }
//                    }
//                }
//            }
//            
//            if let taxID = matchedTaxID {
//                taxIDs.removeAll(where: { $0 == taxID } )
//                matchedTaxID = nil
//            }
//        }
//    }
//    
//    func writeToFile(at path:String) {
//        var contents = "TaxID \t Taxonomy \n"
//        
//        if FileManager.default.fileExists(atPath: outputFilePath) {
//            do {
//                try FileManager.default.removeItem(atPath: outputFilePath)
//            }
//            
//            catch {
//                Console.writeToStdErr("Unable to delete file at \(outputFilePath)")
//                exit(3)
//            }
//            
//            for matchedID in matchedIDs {
//                contents += "\(matchedID.taxID) \t \(matchedID.taxonomy) \n"
//            }
//            
//            let data = contents.data(using: .utf8)
//            
//            FileManager.default.createFile(atPath: outputFilePath,
//                                           contents: data)
//            Console.writeToStdOut("Parsing ended successfully.")
//        }
//    }
//}
