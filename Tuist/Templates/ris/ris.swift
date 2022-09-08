import ProjectDescription

fileprivate let nameAttribute: Template.Attribute = .required("name")

fileprivate func templatePath(_ path: String) -> Path {
    .relativeToCurrentFile(path)
}

let ttModulePath = "Targets/TonTransactions/Sources/Modules"

let risTemplate = Template(
    description: "Router Interactor State",
    attributes: [
        nameAttribute
    ],
    items: [
        .file(
            path: "\(ttModulePath)/\(nameAttribute)/\(nameAttribute)Interactor.swift",
            templatePath: templatePath("Interactor.stencil")
        ),
        .file(
            path: "\(ttModulePath)/\(nameAttribute)/\(nameAttribute)ModuleContainer.swift",
            templatePath: templatePath("ModuleContainer.stencil")
        ),
        .file(
            path: "\(ttModulePath)/\(nameAttribute)/\(nameAttribute)Protocols.swift",
            templatePath: templatePath("Protocols.stencil")
        ),
        .file(
            path: "\(ttModulePath)/\(nameAttribute)/\(nameAttribute)Router.swift",
            templatePath: templatePath("Router.stencil")
        ),
        .file(
            path: "\(ttModulePath)/\(nameAttribute)/\(nameAttribute)View.swift",
            templatePath: templatePath("View.stencil")
        ),
        .file(
            path: "\(ttModulePath)/\(nameAttribute)/\(nameAttribute)ViewState.swift",
            templatePath: templatePath("ViewState.stencil")
        ),
    ]
)
