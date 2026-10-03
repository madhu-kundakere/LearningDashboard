import CoreData

@objc(LessonRecord)
public final class LessonRecord: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var position: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var needsSync: Bool
    @NSManaged public var course: CourseRecord?

    public static let entityName = "LessonRecord"

    public static func request() -> NSFetchRequest<LessonRecord> {
        NSFetchRequest<LessonRecord>(entityName: entityName)
    }
}
