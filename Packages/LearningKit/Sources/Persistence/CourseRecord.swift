import CoreData

@objc(CourseRecord)
public final class CourseRecord: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var instructor: String
    @NSManaged public var progress: Int16
    @NSManaged public var lessonCount: Int16
    @NSManaged public var position: Int32
    @NSManaged public var lessons: Set<LessonRecord>

    public static let entityName = "CourseRecord"

    public static func request() -> NSFetchRequest<CourseRecord> {
        NSFetchRequest<CourseRecord>(entityName: entityName)
    }
}
