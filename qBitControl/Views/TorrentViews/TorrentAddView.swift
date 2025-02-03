//
//  TorrentAddView.swift
//  qBitControl
//

import SwiftUI


struct TorrentAddView: View {
    @Environment(\.dismiss) var dismissAction
    @StateObject var viewModel: TorrentAddViewModel
    
    @Binding var torrentUrls: [URL]
    
    func dismiss() {
        torrentUrls = []
        dismissAction()
    }
    
    init(torrentUrls: Binding<[URL]> = .constant([])) {
        _viewModel = StateObject(wrappedValue: TorrentAddViewModel(torrentUrls: torrentUrls.wrappedValue))
        _torrentUrls = torrentUrls
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("Task Type", selection: $viewModel.torrentType) {
                        Text("File").tag(TorrentType.file)
                        Text("URL").tag(TorrentType.magnet)
                    }
                    .padding(.horizontal, 40.0)
                    .padding(.vertical, 0)
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                }
                
                
                if(viewModel.torrentType == .magnet) { torrentMagnetView() }
                else if(viewModel.torrentType == .file) { torrentFilesView() }
                
                torrentOptionsView()
            }
            .onAppear() {
                viewModel.getSavePath()
                viewModel.getCategories()
                viewModel.getTags()
                
                if(!viewModel.isAppeared) {
                    viewModel.isAppeared.toggle()
                    viewModel.checkTorrentType()
                }
            }
            .toolbar() {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: { Text("Cancel") }
                }
            }
        }
    }
    
    
    // Helper Views
    
    func listElement(value: String) -> some View {
        Button(action: {UIPasteboard.general.string = "\(value)"}) {
            HStack {
                Text("\(value)")
                    .foregroundColor(Color.gray)
                    .lineLimit(1)
            }
        }
    }
    
    func limitField(title: String, placeholder: String, content: Binding<String>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField(placeholder, text: content).multilineTextAlignment(.trailing)
        }
    }
    
    func torrentMagnetView() -> some View {
        Group {
            Section(header: Text("URL")) {
                TextEditor(text: $viewModel.magnetURL)
                    .frame(minHeight: CGFloat(200), maxHeight: CGFloat(200))
            }
            
        }
        .navigationTitle("URL")
    }
    
    func torrentFilesView() -> some View {
        Group {
            Section(header: Text("Files")) {
                Button { viewModel.isFileImporter.toggle() } label: { Text("Open Files..") }
                
                ForEach(viewModel.fileNames, id: \.self) { fileName in listElement(value: fileName) }
            }
            .navigationTitle("File")
        }
        .fileImporter(isPresented: $viewModel.isFileImporter, allowedContentTypes: [.data], allowsMultipleSelection: true, onCompletion: viewModel.handleTorrentFiles)
    }
    
    func changeTagsView() -> some View {
        VStack {
            Form {
                if viewModel.tagsArr.count > 1 {
                    List(viewModel.tagsArr, id: \.self) { tag in
                        Button {
                            if !viewModel.selectedTags.contains(tag) {
                                viewModel.selectedTags.insert(tag)
                            } else {
                                viewModel.selectedTags.remove(tag)
                            }
                        } label: {
                            HStack {
                                Text(tag)
                                    .foregroundStyle(.foreground)
                                Spacer()
                                if viewModel.selectedTags.contains(tag) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tags")
        }
    }

    func torrentOptionsView() -> some View {
        Group {
            Section(header: Text("Save Path")) { TextField("Path", text: $viewModel.savePath) }
            
            Group {
                Section(header: Text("Info")) {
                    Picker("Category", selection: $viewModel.category) {
                        if !viewModel.categories.isEmpty {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Text(category.name).tag(category.name)
                            }
                        }
                    }.onChange(of: viewModel.category) { category in
                        if !viewModel.autoTmmEnabled { viewModel.savePath = category.savePath }
                    }
                    
                    NavigationLink {
                        changeTagsView()
                    } label: {
                        CustomLabelView(label: "Tags", value: viewModel.getTag())
                    }
                    
//                    Picker("Tags", selection: $viewModel.tags) {
//                        if(!viewModel.tagsArr.isEmpty) {
//                            ForEach(viewModel.tagsArr, id: \.self) { tag in Text(tag).tag(tag) }
//                        }
//                    }
                }
            }
            
            Section(header: Text("Management")) {
                if viewModel.showAdvancedOptions { Toggle(isOn: $viewModel.skipChecking) { Text("Skip Checking") } }
                Toggle(isOn: $viewModel.paused) { Text("Pause") }
                Toggle(isOn: $viewModel.sequentialDownload) { Text("Sequential Download") }
            }
            
            Section(header: Text("Advanced")) {
                Toggle(isOn: $viewModel.showAdvancedOptions) { Text("Show Advanced Options") }
            }
        
            Section(header: Text("Limits")) {
                Toggle(isOn: $viewModel.showLimits) { Text("Limits") }
                if viewModel.showLimits {
                    limitField(title: "Download Limit", placeholder: "0 bytes/s", content: $viewModel.downloadLimit)
                    limitField(title: "Upload Limit", placeholder: "0 bytes/s", content: $viewModel.uploadLimit)
                    limitField(title: "Ratio Limit", placeholder: "Ratio Limit", content: $viewModel.ratioLimit)
                    limitField(title: "Seeding Time Limit", placeholder: "Time Limit", content: $viewModel.seedingTimeLimit)
                }
            }
            
            Section {
                Button { viewModel.addTorrent(then: dismiss) } label: { Text("ADD").frame(maxWidth: .infinity).fontWeight(.bold) }.buttonStyle(.borderedProminent)
            }.listRowBackground(Color.blue)
        }
    }
}
