import CoreData

enum ManagedObjectModelFactory {
    static func make() -> NSManagedObjectModel {
        let course = entity(CourseRecord.entityName, className: NSStringFromClass(CourseRecord.self))
        let lesson = entity(LessonRecord.entityName, className: NSStringFromClass(LessonRecord.self))

        let lessons = NSRelationshipDescription()
        lessons.name = "lessons"
        lessons.destinationEntity = lesson
        lessons.minCount = 0
        lessons.maxCount = 0
        lessons.deleteRule = .cascadeDeleteRule

        let owner = NSRelationshipDescription()
        owner.name = "course"
        owner.destinationEntity = course
        owner.minCount = 0
        owner.maxCount = 1
        owner.isOptional = true
        owner.deleteRule = .nullifyDeleteRule

        lessons.inverseRelationship = owner
        owner.inverseRelationship = lessons

        course.properties = [
            attribute("id", .integer64AttributeType, default: 0),
            attribute("title", .stringAttributeType, default: ""),
            attribute("instructor", .stringAttributeType, default: ""),
            attribute("progress", .integer16AttributeType, default: 0),
            attribute("lessonCount", .integer16AttributeType, default: 0),
            attribute("position", .integer32AttributeType, default: 0),
            lessons,
        ]
        course.uniquenessConstraints = [["id"]]

        lesson.properties = [
            attribute("id", .integer64AttributeType, default: 0),
            attribute("title", .stringAttributeType, default: ""),
            attribute("position", .integer32AttributeType, default: 0),
            attribute("isCompleted", .booleanAttributeType, default: false),
            attribute("needsSync", .booleanAttributeType, default: false),
            owner,
        ]
        lesson.uniquenessConstraints = [["id"]]

        let model = NSManagedObjectModel()
        model.entities = [course, lesson]
        return model
    }

    private static func entity(_ name: String, className: String) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = className
        return entity
    }

    private static func attribute(
        _ name: String,
        _ type: NSAttributeType,
        default defaultValue: Any
    ) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = false
        attribute.defaultValue = defaultValue
        return attribute
    }
}
