//
//  SongLine+CoreDataProperties.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//
//

import Foundation
import CoreData


extension SongLine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongLine> {
        return NSFetchRequest<SongLine>(entityName: "SongLine")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var lineSections: NSOrderedSet?
    @NSManaged public var section: SongSection?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedSection: SongSection {
        guard let section = section else {
            fatalError("SongLine must be associated with a SongSection")
        }
        return section
    }
    
    var wrappedLineSections: [SongLineSection] {
        lineSections?.array as? [SongLineSection] ?? []
    }

}

// MARK: Generated accessors for lineSections
extension SongLine {

    @objc(insertObject:inLineSectionsAtIndex:)
    @NSManaged public func insertIntoLineSections(_ value: SongLineSection, at idx: Int)

    @objc(removeObjectFromLineSectionsAtIndex:)
    @NSManaged public func removeFromLineSections(at idx: Int)

    @objc(insertLineSections:atIndexes:)
    @NSManaged public func insertIntoLineSections(_ values: [SongLineSection], at indexes: NSIndexSet)

    @objc(removeLineSectionsAtIndexes:)
    @NSManaged public func removeFromLineSections(at indexes: NSIndexSet)

    @objc(replaceObjectInLineSectionsAtIndex:withObject:)
    @NSManaged public func replaceLineSections(at idx: Int, with value: SongLineSection)

    @objc(replaceLineSectionsAtIndexes:withLineSections:)
    @NSManaged public func replaceLineSections(at indexes: NSIndexSet, with values: [SongLineSection])

    @objc(addLineSectionsObject:)
    @NSManaged public func addToLineSections(_ value: SongLineSection)

    @objc(removeLineSectionsObject:)
    @NSManaged public func removeFromLineSections(_ value: SongLineSection)

    @objc(addLineSections:)
    @NSManaged public func addToLineSections(_ values: NSOrderedSet)

    @objc(removeLineSections:)
    @NSManaged public func removeFromLineSections(_ values: NSOrderedSet)

}

extension SongLine : Identifiable {

}
