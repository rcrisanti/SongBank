//
//  SongLineSection+CoreDataProperties.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//
//

import Foundation
import CoreData


extension SongLineSection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongLineSection> {
        return NSFetchRequest<SongLineSection>(entityName: "SongLineSection")
    }

    @NSManaged public var chord: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lyrics: String?
    @NSManaged public var line: SongLine?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedLyrics: String {
        lyrics ?? ""
    }
    
    var wrappedChord: String {
        chord ?? ""
    }
    
    var wrappedLine: SongLine {
        guard let line = line else {
            fatalError("SongLineSection must be associated with a SongLine")
        }
        return line
    }

}

extension SongLineSection : Identifiable {

}
