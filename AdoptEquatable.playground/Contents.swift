// Source https://github.com/ijoshsmith/equatable-code-generator
import Foundation

// Generates code for a class or struct instance to conform to the Equatable protocol.
public func adoptEquatable(_ subject: Any) {
    let mirror = Mirror(reflecting: subject)
    
    let typeName: String = {
        let fullTypeName = String(reflecting: mirror.subjectType)
        let typeNameParts = fullTypeName.components(separatedBy: ".")
        let hasModulePrefix = typeNameParts.count > 1
        return hasModulePrefix
            ? typeNameParts.dropFirst().joined(separator: ".")
            : fullTypeName
    }()
    
    let propertyNames = mirror.children.map { $0.label ?? "" }
    
    // Associate an indentation level with each snippet of code.
    typealias TemplateGroup = [(Int, String)]
    let templateGroups: [TemplateGroup] = [
        [(0, "extension \(typeName): Equatable {")],
        [(1, "public static func ==(lhs: \(typeName), rhs: \(typeName)) -> Bool {")],
        propertyNames.map { (2, "guard lhs.\($0) == rhs.\($0) else { return false }") },
        [(2, "return true")],
        [(1, "}")],
        [(0, "}")]
    ]
    
    // Apply indentation to each line of code while flattening the list.
    let indent = "    "
    let linesOfCode = templateGroups.flatMap { templateGroup -> [String] in
        return templateGroup.map { (indentLevel: Int, code: String) -> String in
            let indentation = String(repeating: indent, count: indentLevel)
            return "\(indentation)\(code)"
        }
    }
    
    let sourceCode = linesOfCode.joined(separator: "\n")
    print(sourceCode)
}


// MARK: - Demo
struct Person {
    let firstName: String
    let lastName: String
    let birthday: Date
    let inchesTall: Int
}

let person = Person(firstName: "Clown",
                    lastName: "Baby",
                    birthday: Date(),
                    inchesTall: 18)

adoptEquatable(person)
