//
//  Query.swift
//  blast_parser
//
//  Created by João Varela on 30/08/2024.
//
//
//import Foundation
//
//struct Query {
//    let url:URL
//    var taxIDs = [String]()
//    
//    init(path:String) async {
//        url = URL(fileURLWithPath: path)
//
//        do {
//            for try await taxID in url.lines {
//                taxIDs.append(taxID)
//            }
//        }
//
//        catch {
//            Console.writeToStdErr("Unable to read file at \(url.path)")
//            exit(1)
//        }
//    }
//}
