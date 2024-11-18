//
//  NCBILineage.swift
//  blast_parser
//
//  Created by João Varela on 18/11/2024.
//


struct NCBILineage {
    let taxId:Int
    let taxName:String
    let species:String?
    let genus:String?
    let family:String?
    let order:String?
    let `class`:String?
    let phylum:String?
    let kingdom:String?
    let superkingdom:String?
    
    init?(string:String) {
        let fields = string.components(separatedBy: kPSDQueryResultSeparator)
        guard fields.count == kPSDQueryFieldNumber else { return nil }
        self.taxId = Int(fields[0])!
        self.taxName = fields[1]
        self.species = fields[2]
        self.genus = fields[3]
        self.family = fields[4]
        self.order = fields[5]
        self.class = fields[6]
        self.phylum = fields[7]
        self.kingdom = fields[8]
        self.superkingdom = fields[9]
    }
    
    init?(database:SQLDatabase, taxID:Int) {
        let result = database.queryDatabase(sql: "tax_id = \(taxID)")
        self.init(string: result)
    }
}
