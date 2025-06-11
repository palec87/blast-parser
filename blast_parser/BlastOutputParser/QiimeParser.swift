//
//  QiimeParser.swift
//  blast_parser
//
//  Created by Catarina Alexandre on 29/05/2025.
//
import Foundation

//parses Qiime2 merged.tsv file

struct QiimeASV: CustomStringConvertible {
	let featureID: String
	let samples: [String]
	let taxonomy: String
	let confidence: String
	
	var description: String{
		return """
				\(featureID)\t\
				\(samples)\t\
				\(taxonomy)\t\
				\(confidence)
			"""
	}
	init(featureID: String, samples: [String], taxonomy: String, confidence: String) {
		self.featureID = featureID
		self.samples = samples
		self.taxonomy = taxonomy
		self.confidence = confidence
	}
}

final class QiimeParser: FileParser {
	var lines = [QiimeASV]()
	func parse() throws -> [QiimeASV] {
	for line in readStream {
		let items = line.components(separatedBy: "\t")
		let count: Int = items.count
		guard let header = line.components(separatedBy: .newlines).first , header.contains("id") , header.contains("Taxon") , header.contains("Confidence") else {
			throw RuntimeError("Invalid Qiime 2 merged file")
			}
		//change any "-" to "CN" for Negative Control (Controlo Negativo)
		var sampleName = Array(items[1..<(count - 2)])
			sampleName = sampleName.map { $0.replacingOccurrences(of: "-", with: "CN") }
		

		let lineID = items[0].trimmingCharacters(in: .whitespaces)
		let samples = Array(items[1..<(count-2)]).map { $0.trimmingCharacters(in: .whitespaces)}
		let taxon = items[count - 2].trimmingCharacters(in: .whitespaces)
		let confidence = items[count-1].trimmingCharacters(in: .whitespaces)
		let qLine = QiimeASV(featureID: lineID, samples: samples, taxonomy: taxon, confidence: confidence)
		
		lines.append(qLine)
		
		//removes 2nd line "#q2:types"
		lines.remove(at:1)
		}
		return lines
	}
	func getTaxonomy(for asv:QiimeASV) -> String? {
		for line in lines {
			if asv.taxonomy == line.taxonomy {
				return line.taxonomy
			}
		}
		return nil
	}
	
}


