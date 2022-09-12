//
//  Project-CoreDataHelper.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 11/8/2022.
//

import Foundation
import SwiftUI

extension Project {
    static let colors = [
        "Pink",
        "Purple",
        "Red",
        "Orange",
        "Gold",
        "Green",
        "Teal",
        "Light Blue",
        "Dark Blue",
        "Midnight",
        "Dark Gray",
        "Gray"
    ]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }
// Sort incomplete, priority and creation date. Incomplete, high priority and last made comes first.
    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }

            return first.itemCreationDate < second.itemCreationDate
        }
    }

    func projectItems(using sortOrder: Item.SortOrders) -> [Item] {
        switch sortOrder {
        case .optimised:
            return projectItemsDefaultSorted
        case .creationDate:
            return projectItems.sorted(by: \Item.itemCreationDate)
        case .title:
            return projectItems.sorted(by: \Item.itemTitle)
        }
    }

    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }

        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    var label: LocalizedStringKey {
        LocalizedStringKey("\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete")// swiftlint:disable:this line_length
    }

    static var example: Project {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.creationDate = Date()
        project.closed = true

        return project
    }
}