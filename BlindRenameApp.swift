import SwiftUI
import CryptoKit

struct BlindRenameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var folderURL: URL?
    @State private var status: String = "Drop a folder below."
    @State private var isProcessing = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Blind Rename Files")
                .font(.largeTitle)
            Text(status)
                .foregroundColor(.secondary)
            FolderDropView(folderURL: $folderURL)
                .frame(width: 400, height: 100)
                .border(Color.blue, width: 2)
            HStack {
                Button("Blind Rename") {
                    if let url = folderURL {
                        isProcessing = true
                        status = "Renaming..."
                        DispatchQueue.global().async {
                            let result = blindRename(in: url)
                            DispatchQueue.main.async {
                                status = result
                                isProcessing = false
                            }
                        }
                    }
                }
                .disabled(folderURL == nil || isProcessing)
                Button("Revert Rename") {
                    if let url = folderURL {
                        isProcessing = true
                        status = "Reverting..."
                        DispatchQueue.global().async {
                            let result = revertRename(in: url)
                            DispatchQueue.main.async {
                                status = result
                                isProcessing = false
                            }
                        }
                    }
                }
                .disabled(folderURL == nil || isProcessing)
            }
        }
        .padding()
        .frame(width: 500, height: 300)
    }
}

struct FolderDropView: View {
    @Binding var folderURL: URL?
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .overlay(
                Text(folderURL?.path ?? "Drop folder here")
                    .foregroundColor(.primary)
            )
            .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                if let provider = providers.first {
                    _ = provider.loadObject(ofClass: URL.self) { url, _ in
                        if let url = url, url.hasDirectoryPath {
                            DispatchQueue.main.async {
                                folderURL = url
                            }
                        }
                    }
                    return true
                }
                return false
            }
    }
}

// MARK: - Core Logic

func blindRename(in dir: URL) -> String {
    let fm = FileManager.default
    let dictURL = dir.appendingPathComponent("name_dictionary.csv")
    let analysisURL = dir.appendingPathComponent("Analysis_file.csv")
    let deprecatedURL = dir.appendingPathComponent("name_dictionary_DEPRECATED.csv")
    if fm.fileExists(atPath: dictURL.path) || fm.fileExists(atPath: analysisURL.path) {
        return "Files on folder already renamed"
    }
    if fm.fileExists(atPath: deprecatedURL.path) {
        return "Please delete name_dictionary_DEPRECATED.csv before running"
    }
    guard let files = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) else {
        return "Cannot read folder"
    }
    var dictLines = ["Oldname,Newname"]
    var analysisLines = ["Newname"]
    for file in files {
        let name = file.lastPathComponent
        if name == "name_dictionary.csv" || name == "Analysis_file.csv" || name == ".DS_Store" || name.lowercased() == "thumbs.db" {
            continue
        }
        let ext = file.pathExtension
        let base = file.deletingPathExtension().lastPathComponent
        let hash = SHA256.hash(data: Data(name.utf8)).compactMap { String(format: "%02X", $0) }.joined()
        let newBase = String(hash.prefix(20))
        let newName = ext.isEmpty ? newBase : "\(newBase).\(ext)"
        let newURL = dir.appendingPathComponent(newName)
        do {
            try fm.moveItem(at: file, to: newURL)
            dictLines.append("\(name),\(newName)")
            analysisLines.append(newName)
        } catch {
            return "Failed to rename \(name)"
        }
    }
    try? dictLines.joined(separator: "\n").write(to: dictURL, atomically: true, encoding: .utf8)
    try? analysisLines.joined(separator: "\n").write(to: analysisURL, atomically: true, encoding: .utf8)
    return "DONE"
}

func revertRename(in dir: URL) -> String {
    let fm = FileManager.default
    let dictURL = dir.appendingPathComponent("name_dictionary.csv")
    let deprecatedURL = dir.appendingPathComponent("name_dictionary_DEPRECATED.csv")
    guard let dictData = try? String(contentsOf: dictURL, encoding: .utf8) else {
        return "Dictionary not found"
    }
    let lines = dictData.components(separatedBy: .newlines)
    for line in lines.dropFirst() {
        let parts = line.components(separatedBy: ",")
        if parts.count == 2 {
            let orig = parts[0]
            let new = parts[1]
            let origURL = dir.appendingPathComponent(orig)
            let newURL = dir.appendingPathComponent(new)
            if fm.fileExists(atPath: newURL.path) {
                try? fm.moveItem(at: newURL, to: origURL)
            }
        }
    }
    try? fm.moveItem(at: dictURL, to: deprecatedURL)
    return "File names reverted to original. Dictionary deprecated. DONE"
}

