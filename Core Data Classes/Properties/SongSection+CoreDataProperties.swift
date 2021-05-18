//
//  SongSection+CoreDataProperties.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//
//

import Foundation
import CoreData


extension SongSection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongSection> {
        return NSFetchRequest<SongSection>(entityName: "SongSection")
    }

    @NSManaged public var header: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lines: NSOrderedSet?
    @NSManaged public var song: Song?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedHeader: String {
        header ?? ""
    }
    
    var wrappedLines: [SongLine] {
        lines?.array as? [SongLine] ?? []
    }
    
    var wrappedSong: Song {
        guard let song = song else {
            fatalError("SongSection must be associated with a Song")
        }
        return song
    }

}

// MARK: Generated accessors for lines
extension SongSection {

    @objc(insertObject:inLinesAtIndex:)
    @NSManaged public func insertIntoLines(_ value: SongLine, at idx: Int)

    @objc(removeObjectFromLinesAtIndex:)
    @NSManaged public func removeFromLines(at idx: Int)

    @objc(insertLines:atIndexes:)
    @NSManaged public func insertIntoLines(_ values: [SongLine], at indexes: NSIndexSet)

    @objc(removeLinesAtIndexes:)
    @NSManaged public func removeFromLines(at indexes: NSIndexSet)

    @objc(replaceObjectInLinesAtIndex:withObject:)
    @NSManaged public func replaceLines(at idx: Int, with value: SongLine)

    @objc(replaceLinesAtIndexes:withLines:)
    @NSManaged public func replaceLines(at indexes: NSIndexSet, with values: [SongLine])

    @objc(addLinesObject:)
    @NSManaged public func addToLines(_ value: SongLine)

    @objc(removeLinesObject:)
    @NSManaged public func removeFromLines(_ value: SongLine)

    @objc(addLines:)
    @NSManaged public func addToLines(_ values: NSOrderedSet)

    @objc(removeLines:)
    @NSManaged public func removeFromLines(_ values: NSOrderedSet)

}

extension SongSection : Identifiable {

}
