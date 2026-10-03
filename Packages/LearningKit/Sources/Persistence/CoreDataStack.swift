import CoreData
import os

public final class CoreDataStack: @unchecked Sendable {
    public enum StoreKind: Sendable {
        case persistent
        case inMemory
    }

    nonisolated(unsafe) private static let model = ManagedObjectModelFactory.make()
    private static let logger = Logger(subsystem: "LearningKit", category: "CoreDataStack")

    private let container: NSPersistentContainer

    public init(kind: StoreKind = .persistent, name: String = "LearningDashboard") throws {
        container = NSPersistentContainer(name: name, managedObjectModel: Self.model)
        guard let description = container.persistentStoreDescriptions.first else {
            throw CocoaError(.persistentStoreOpen)
        }
        switch kind {
        case .persistent:
            description.setOption(
                FileProtectionType.completeUntilFirstUserAuthentication as NSObject,
                forKey: NSPersistentStoreFileProtectionKey
            )
        case .inMemory:
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        do {
            try loadStores()
        } catch {
            Self.logger.error("Cache store failed to load, rebuilding: \(error.localizedDescription)")
            try destroyStore(description)
            try loadStores()
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    public func perform<Result: Sendable>(
        _ work: @escaping @Sendable (NSManagedObjectContext) throws -> Result
    ) async throws -> Result {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return try await context.perform {
            let result = try work(context)
            if context.hasChanges {
                try context.save()
            }
            return result
        }
    }

    private func loadStores() throws {
        var loadError: (any Error)?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        if let loadError { throw loadError }
    }

    private func destroyStore(_ description: NSPersistentStoreDescription) throws {
        guard let url = description.url else { return }
        try container.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
    }
}
