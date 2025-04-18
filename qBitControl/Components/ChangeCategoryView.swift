import SwiftUI

struct ChangeCategoryView: View {
    @State var torrentHash: String?
    @State private var categories: [Category] = []
    @State var category: String
    
    let defaultCategory: Category = Category(name: NSLocalizedString("Uncategorized", comment: ""), savePath: "")
    func isDefaultCategorySelected(currentCategory: String) -> Bool {
        return currentCategory == defaultCategory.name && category == ""
    }
    
    @State private var showAddCategoryAlert = false
    @State private var newCategoryName = ""
    
    public var onCategoryChange: ((Category) -> Void)?
    
    private func getCategories() {
        qBittorrent.getCategories(completionHandler: { _categories in
            var categories = _categories.map { $0.value }
            categories.sort { $0.name < $1.name }
            categories.insert(defaultCategory, at: 0)
            self.categories = categories
            clearSelectedCategories()
        })
    }
    
    private func clearSelectedCategories() {
        if let onCategoryChange = self.onCategoryChange {
            if !categories.map({ $0.name }).contains(category) {
                onCategoryChange(defaultCategory)
            }
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Add Category")) {
                    Button {
                        showAddCategoryAlert = true
                    } label: {
                        Label("Add Category", systemImage: "plus.circle")
                    }.alert("Add New Category", isPresented: $showAddCategoryAlert, actions: {
                        TextField("Category Name", text: $newCategoryName)
                        Button("Add", action: {
                            qBittorrent.addCategory(category: newCategoryName, savePath: nil, then: { status in
                                if(status == 200) {
                                    self.getCategories()
                                }
                            })
                            newCategoryName = ""
                        })
                        Button("Cancel", role: .cancel, action: {
                            newCategoryName = ""
                        })
                    })
                }
                
                if categories.count > 1 {
                    Section(header: Text("Categories")) {
                        List {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    if(self.category != category.name) { self.category = category.name }
                                } label: {
                                    HStack {
                                        Text(category.name)
                                            .foregroundStyle(.foreground)
                                        Spacer()
                                        if(self.category == category.name || isDefaultCategorySelected(currentCategory: category.name)) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: { offsets in
                                for index in offsets {
                                    let category = categories[index].name
                                    qBittorrent.removeCategory(category: category, then: {status in print(status)})
                                }
                                
                                categories.remove(atOffsets: offsets)
                                self.clearSelectedCategories()
                            })
                        }
                    }
                }
            }
            .navigationTitle("Categories")
        }.onAppear() {
            print(category)
            self.getCategories()
        }.onChange(of: category) { category in
            if let onCategoryChange = self.onCategoryChange, let category = categories.first(where: { $0.name == category }) { onCategoryChange(category) }
            if let hash = self.torrentHash { qBittorrent.setCategory(hash: hash, category: category == defaultCategory.name ? "" : category) }
        }
    }
}
