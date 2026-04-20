import Foundation
import AppKit
import os.log

/// Manages the output folder and file writing for Waybetter recordings.
internal class WaybetterFileManager {
    static let shared = WaybetterFileManager()

    private let defaultsFolderKey = "waybetterOutputFolder"
    private let recentRecordingsKey = "waybetterRecentRecordings"
    private let maxRecentRecordings = 5

    private init() {}

    // MARK: - Output Folder

    var outputFolder: URL {
        if let stored = UserDefaults.standard.string(forKey: defaultsFolderKey),
           !stored.isEmpty {
            return URL(fileURLWithPath: stored)
        }
        return defaultFolder
    }

    var defaultFolder: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("Waybetter", isDirectory: true)
    }

    func setOutputFolder(_ url: URL) {
        UserDefaults.standard.set(url.path, forKey: defaultsFolderKey)
    }

    func ensureOutputFolderExists() {
        let folder = outputFolder
        guard !FileManager.default.fileExists(atPath: folder.path) else { return }
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        } catch {
            Logger.app.error("WaybetterFileManager: failed to create output folder: \(error.localizedDescription)")
        }
    }

    func openOutputFolderInFinder() {
        ensureOutputFolderExists()
        NSWorkspace.shared.open(outputFolder)
    }

    // MARK: - File Writing

    /// Copies the audio file and writes the transcript to the output folder.
    /// Returns the saved audio URL and transcript URL.
    @discardableResult
    func saveRecording(audioURL: URL, transcript: String) -> (audio: URL, transcript: URL)? {
        ensureOutputFolderExists()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())

        let audioDestination = outputFolder.appendingPathComponent("\(timestamp).m4a")
        let transcriptDestination = outputFolder.appendingPathComponent("\(timestamp)_transcript.txt")

        do {
            try FileManager.default.copyItem(at: audioURL, to: audioDestination)
            try transcript.write(to: transcriptDestination, atomically: true, encoding: .utf8)
            addRecentRecording(audioURL: audioDestination, transcriptURL: transcriptDestination, timestamp: timestamp)
            return (audioDestination, transcriptDestination)
        } catch {
            Logger.app.error("WaybetterFileManager: failed to save recording: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Recent Recordings

    struct RecentRecording: Codable {
        let audioPath: String
        let transcriptPath: String
        let timestamp: String
    }

    var recentRecordings: [RecentRecording] {
        guard let data = UserDefaults.standard.data(forKey: recentRecordingsKey),
              let recordings = try? JSONDecoder().decode([RecentRecording].self, from: data) else {
            return []
        }
        return recordings
    }

    private func addRecentRecording(audioURL: URL, transcriptURL: URL, timestamp: String) {
        var recordings = recentRecordings
        let entry = RecentRecording(audioPath: audioURL.path, transcriptPath: transcriptURL.path, timestamp: timestamp)
        recordings.insert(entry, at: 0)
        if recordings.count > maxRecentRecordings {
            recordings = Array(recordings.prefix(maxRecentRecordings))
        }
        if let data = try? JSONEncoder().encode(recordings) {
            UserDefaults.standard.set(data, forKey: recentRecordingsKey)
        }
    }

    func openRecordingInFinder(_ recording: RecentRecording) {
        let url = URL(fileURLWithPath: recording.audioPath)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    func openTranscriptInEditor(_ recording: RecentRecording) {
        let url = URL(fileURLWithPath: recording.transcriptPath)
        NSWorkspace.shared.open(url)
    }
}
