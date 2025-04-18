import SwiftUI

class TorrentDetailsViewModel: ObservableObject {
    @Published public var torrent: Torrent
    
    @Published public var isDeleteAlert: Bool = false
    
    @Published public var isSequentialDownload: Bool = false
    @Published public var isFLPiecesFirst: Bool = false
    
    @Published public var state: State = .resumed
    
    private var tags: [String] { torrent.tags.split(separator: ", ").map { String($0) } }
    
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    private var timer: Timer?
    
    init(torrent: Torrent) {
        self.torrent = torrent
        self.isSequentialDownload = torrent.seq_dl
        self.isFLPiecesFirst = torrent.f_l_piece_prio
        self.fetchState(state: torrent.state)
    }
    
    func setRefreshTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.getTorrent()
        }
    }
    
    func removeRefreshTimer() {
        timer?.invalidate()
    }
    
    func getTorrent() {
        let request = qBitRequest.prepareURLRequest(path: "/api/v2/torrents/info", queryItems: [URLQueryItem(name:"hashes", value: torrent.hash)])
        
        qBitRequest.requestTorrentListJSON(request: request) {
            torrent in
            if let torrent = torrent.first {
                DispatchQueue.main.async {
                    self.torrent = torrent
                    self.isSequentialDownload = torrent.seq_dl
                    self.isFLPiecesFirst = torrent.f_l_piece_prio
                    self.fetchState(state: torrent.state)
                }
            }
        }
    }
    
    private func fetchState(state: String) {
        let state = qBittorrent.getState(state: state)
        if(state == "Paused") { self.state = .paused }
        else if(torrent.state.contains("forced")) { self.state = .forceStart }
        else { self.state = .resumed }
    }
    
    func getCategory() -> String { torrent.category != "" ? torrent.category : "Uncategorized" }
    func getTags() -> [String] { tags }
    func getTag() -> String { tags.count > 1 ? "\(tags.count)" + " Tags" : (tags.first ?? "Untagged") }
    func getAddedOn() -> String { qBittorrent.getFormatedDate(date: torrent.added_on) }
    func getSize() -> String { "\(qBittorrent.getFormatedSize(size: torrent.size))" }
    func getTotalSize() -> String { "\(qBittorrent.getFormatedSize(size: torrent.total_size))" }
    func getAvailability() -> String { torrent.availability < 0 ? "-" : "\(String(format: "%.1f", torrent.availability*100))%" }
    func getState() -> String { "\(qBittorrent.getState(state: torrent.state))" }
    func getProgress() -> String { "\(String(format: "%.2f", (torrent.progress*100)))%" }
    func getDownloadSpeed() -> String { "\(qBittorrent.getFormatedSize(size: torrent.dlspeed))/s" }
    func getUploadSpeed() -> String { "\(qBittorrent.getFormatedSize(size: torrent.upspeed))/s" }
    func getDownloaded() -> String { "\(qBittorrent.getFormatedSize(size: torrent.downloaded))" }
    func getUploaded() -> String { "\(qBittorrent.getFormatedSize(size: torrent.uploaded))" }
    func getRatio() -> String { "\(String(format:"%.2f", torrent.ratio))" }
    func getDownloadedSession() -> String { "\(qBittorrent.getFormatedSize(size: torrent.downloaded_session))" }
    func getUploadedSession() -> String { "\(qBittorrent.getFormatedSize(size: torrent.uploaded_session))" }
    func getMaxRatio() -> String { "\(torrent.max_ratio > -1 ? String(format:"%.2f", torrent.max_ratio) : NSLocalizedString("None", comment: "None"))" }
    func getDownloadLimit() -> String { "\(torrent.dl_limit > 0 ? qBittorrent.getFormatedSize(size: torrent.dl_limit)+"/s" : NSLocalizedString("None", comment: "None"))" }
    func getUploadLimit() -> String { "\(torrent.up_limit > 0 ? qBittorrent.getFormatedSize(size: torrent.up_limit)+"/s" : NSLocalizedString("None", comment: "None"))" }
    func getETA() -> String { torrent.progress < 1 ? qBittorrent.getFormattedTime(time: torrent.eta) : "-" }
    
    
    func isPaused() -> Bool { state == .paused }
    func isForceStart() -> Bool { state == .forceStart }
    
    func toggleTorrentPause() {
        haptics.impactOccurred()
        if self.isPaused() {
            qBittorrent.resumeTorrent(hash: torrent.hash)
        } else {
            qBittorrent.pauseTorrent(hash: torrent.hash)
        }
        getTorrent()
    }
    
    func toggleSequentialDownload() {
        qBittorrent.toggleSequentialDownload(hashes: [torrent.hash])
    }
    
    func toggleFLPiecesFirst() {
        qBittorrent.toggleFLPiecesFirst(hashes: [torrent.hash])
    }
    
    func setForceStart(value: Bool) {
        qBittorrent.setForceStart(hashes: [torrent.hash], value: value)
    }
    
    func recheckTorrent() {
        haptics.impactOccurred()
        qBittorrent.recheckTorrent(hash: torrent.hash)
    }
    
    func reannounceTorrent() {
        haptics.impactOccurred()
        qBittorrent.reannounceTorrent(hash: torrent.hash)
    }
    
    func deleteTorrent() {
        haptics.impactOccurred()
        isDeleteAlert = true
    }
    
    func moveToTopPriority() {
        haptics.impactOccurred()
        qBittorrent.topPriorityTorrents(hashes: [torrent.hash])
    }
    
    func moveToBottomPriority() {
        haptics.impactOccurred()
        qBittorrent.bottomPriorityTorrents(hashes: [torrent.hash])
    }
    
    func increasePriority() {
        haptics.impactOccurred()
        qBittorrent.increasePriorityTorrents(hashes: [torrent.hash])
    }
    
    func decreasePriority() {
        haptics.impactOccurred()
        qBittorrent.decreasePriorityTorrents(hashes: [torrent.hash])
    }
    
    func deleteTorrent(then dismiss: DismissAction) {
        qBittorrent.deleteTorrent(hash: torrent.hash)
        dismiss()
    }
    
    func deleteTorrentWithFiles(then dismiss: DismissAction) {
        qBittorrent.deleteTorrent(hash: torrent.hash, deleteFiles: true)
        dismiss()
    }
    
    enum State {
        case resumed, paused, forceStart
    }
}
