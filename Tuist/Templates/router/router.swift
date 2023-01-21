import ProjectDescription

fileprivate let nameAttribute: Template.Attribute = .required("name")

fileprivate func templatePath(_ path: String) -> Path {
    .relativeToCurrentFile(path)
}

let template = Template(
    description: "Custom template router",
    attributes: [
        nameAttribute
    ],
    items: [
        .file(
            path: "Targets/\(nameAttribute)/TemplateTest.swift",
            templatePath: templatePath("templ.stencil")
        ),
    ]
)
