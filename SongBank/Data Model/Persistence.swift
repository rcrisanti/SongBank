//
//  Persistence.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/3/21.
//

import CoreData
import os.log

struct PersistenceController {
    static let shared = PersistenceController()
    
    static let logger = Logger(subsystem: "com.rcrisanti.SongBank", category: "PersistenceController")

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Make some example data
        // Section 1
        let lineSection1 = SongLineSection(context: viewContext)
        lineSection1.lyrics = "lyrics"
        lineSection1.chord = "chord"
        lineSection1.id = UUID()

        let lineSection2 = SongLineSection(context: viewContext)
        lineSection2.lyrics = "lyrics2"
        lineSection2.chord = "chord2"
        lineSection2.id = UUID()

        let songLine1 = SongLine(context: viewContext)
        songLine1.lineSections = [lineSection1, lineSection2]
        songLine1.id = UUID()

        let section1 = SongSection(context: viewContext)
        section1.header = "Verse 1"
        section1.id = UUID()
        section1.lines = [songLine1]

        // Section 2
        let lineSection3 = SongLineSection(context: viewContext)
        lineSection3.lyrics = "lyrics3"
        lineSection3.chord = "chord3"
        lineSection3.id = UUID()

        let lineSection4 = SongLineSection(context: viewContext)
        lineSection4.lyrics = "lyrics4"
        lineSection4.chord = "chord4"
        lineSection4.id = UUID()

        let songLine2 = SongLine(context: viewContext)
        songLine2.lineSections = [lineSection3, lineSection4]
        songLine2.id = UUID()

        let lineSection5 = SongLineSection(context: viewContext)
        lineSection5.lyrics = "lyrics5"
        lineSection5.chord = "chord5"
        lineSection5.id = UUID()

        let songLine3 = SongLine(context: viewContext)
        songLine3.lineSections = [lineSection5]
        songLine3.id = UUID()

        let section2 = SongSection(context: viewContext)
        section2.header = "Verse 2"
        section2.id = UUID()
        section2.lines = [songLine2, songLine3]
        
        // Make the song
        let song = Song(context: viewContext)
        song.title = "Song title"
        song.author = "some author"
        song.created = Date()
        song.modified = Date()
        song.sections = [section1, section2]
        
        result.save()
        return result
    }()

    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SongBank")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                Self.logger.error("Unresolved error \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                Self.logger.info("Saved Core Data successfully")
            } catch let error {
                viewContext.rollback()
                Self.logger.error("Error saving Core Data: \(error.localizedDescription)")
            }
        } else {
            Self.logger.debug("No changes, Core Data view context not saved")
        }
    }
    
    // MARK: - Fetches
    func fetch() -> [Song] {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        
        do {
            let songs = try viewContext.fetch(request)
            Self.logger.info("Fetched all \(songs.count) Songs")
            return songs
        } catch {
            Self.logger.warning("Unable to fetch Songs")
            return []
        }
    }
    
    func fetchSections(in song: Song) -> [SongSection] {
        let predicate = NSPredicate(format: "song == %@", song)
        let request: NSFetchRequest<SongSection> = SongSection.fetchRequest()
        request.predicate = predicate
        
        do {
            let sections = try viewContext.fetch(request)
            Self.logger.info("Fetched all \(sections.count) SongSections of Song '\(song.wrappedTitle)'")
            return sections
        } catch {
            Self.logger.warning("Unable to fetch SongSections of Song '\(song.wrappedTitle)'")
            return []
        }
    }
    
    func fetchLines(in section: SongSection) -> [SongLine] {
        let predicate = NSPredicate(format: "section == %@", section)
        let request: NSFetchRequest<SongLine> = SongLine.fetchRequest()
        request.predicate = predicate
        
        do {
            let lines = try viewContext.fetch(request)
            Self.logger.info("Fetched all \(lines.count) lines of SongSection '\(section.wrappedHeader)' in Song '\(section.wrappedSong.wrappedTitle)'")
            return lines
        } catch {
            Self.logger.warning("Unable to fetch lines of SongSection '\(section.wrappedHeader)' in Song '\(section.wrappedSong.wrappedTitle)'")
            return []
        }
    }
    
    func fetchLineSections(in line: SongLine) -> [SongLineSection] {
        let predicate = NSPredicate(format: "line == %@", line)
        let request: NSFetchRequest<SongLineSection> = SongLineSection.fetchRequest()
        request.predicate = predicate
        
        do {
            let lineSections = try viewContext.fetch(request)
            Self.logger.info("Fetched all \(lineSections.count) SongLineSections of SongLine '\(line.wrappedId.uuidString)' in SongSection '\(line.wrappedSection.wrappedHeader)' of Song '\(line.wrappedSection.wrappedSong.wrappedTitle)'")
            return lineSections
        } catch {
            Self.logger.warning("Unble to fetch SongLineSections of SongLine '\(line.wrappedId.uuidString)' in SongSection '\(line.wrappedSection.wrappedHeader)' of Song '\(line.wrappedSection.wrappedSong.wrappedTitle)'")
            return []
        }
    }
}
