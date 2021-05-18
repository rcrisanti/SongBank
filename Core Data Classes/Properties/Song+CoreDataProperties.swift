//
//  Song+CoreDataProperties.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var author: String?
    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var modified: Date?
    @NSManaged public var title: String?
    @NSManaged public var sections: NSOrderedSet?

    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedTitle: String {
        title ?? ""
    }
    
    var wrappedAuthor: String {
        author ?? ""
    }
    
    var wrappedCreated: Date {
        created ?? Date()
    }
    
    var wrappedModified: Date {
        modified ?? Date()
    }
    
    var wrappedSections: [SongSection] {
        sections?.array as? [SongSection] ?? []
    }
}

// MARK: Generated accessors for sections
extension Song {

    @objc(insertObject:inSectionsAtIndex:)
    @NSManaged public func insertIntoSections(_ value: SongSection, at idx: Int)

    @objc(removeObjectFromSectionsAtIndex:)
    @NSManaged public func removeFromSections(at idx: Int)

    @objc(insertSections:atIndexes:)
    @NSManaged public func insertIntoSections(_ values: [SongSection], at indexes: NSIndexSet)

    @objc(removeSectionsAtIndexes:)
    @NSManaged public func removeFromSections(at indexes: NSIndexSet)

    @objc(replaceObjectInSectionsAtIndex:withObject:)
    @NSManaged public func replaceSections(at idx: Int, with value: SongSection)

    @objc(replaceSectionsAtIndexes:withSections:)
    @NSManaged public func replaceSections(at indexes: NSIndexSet, with values: [SongSection])

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: SongSection)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: SongSection)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSOrderedSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSOrderedSet)

}

extension Song : Identifiable {

}
