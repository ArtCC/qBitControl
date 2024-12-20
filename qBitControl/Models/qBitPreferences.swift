//


import Foundation

struct qBitPreferences: Decodable {
    let locale: String?
    let create_subfolder_enabled: Bool?
    let start_paused_enabled: Bool?
    let auto_delete_mode: Int?
    let preallocate_all: Bool?
    let incomplete_files_ext: Bool?
    let auto_tmm_enabled: Bool?
    let torrent_changed_tmm_enabled: Bool?
    let save_path_changed_tmm_enabled: Bool?
    let category_changed_tmm_enabled: Bool?
    let save_path: String?
    let temp_path_enabled: Bool?
    let temp_path: String?
    //let scan_dirs: [Any]
    let export_dir: String?
    let export_dir_fin: String?
    let mail_notification_enabled: Bool?
    let mail_notification_sender: String?
    let mail_notification_email: String?
    let mail_notification_smtp: String?
    let mail_notification_ssl_enabled: Bool?
    let mail_notification_auth_enabled: Bool?
    let mail_notification_username: String?
    let mail_notification_password: String?
    let autorun_enabled: Bool?
    let autorun_program: String?
    let queueing_enabled: Bool?
    let max_active_downloads: Int?
    let max_active_torrents: Int?
    let max_active_uploads: Int?
    let dont_count_slow_torrents: Bool?
    let slow_torrent_dl_rate_threshold: Int?
    let slow_torrent_ul_rate_threshold: Int?
    let slow_torrent_inactive_timer: Int?
    let max_ratio_enabled: Bool?
    let max_ratio: Float?
    let max_ratio_act: Int?
    let listen_port: Int?
    let upnp: Bool?
    let random_port: Bool?
    let dl_limit: Int?
    let up_limit: Int?
    let max_connec: Int?
    let max_connec_per_torrent: Int?
    let max_uploads: Int?
    let max_uploads_per_torrent: Int?
    let stop_tracker_timeout: Int?
    let enable_piece_extent_affinity: Bool?
    let bittorrent_protocol: Int?
    let limit_utp_rate: Bool?
    let limit_tcp_overhead: Bool?
    let limit_lan_peers: Bool?
    let alt_dl_limit: Int?
    let alt_up_limit: Int?
    let scheduler_enabled: Bool?
    let schedule_from_hour: Int?
    let schedule_from_min: Int?
    let schedule_to_hour: Int?
    let schedule_to_min: Int?
    let scheduler_days: Int?
    let dht: Bool?
    let pex: Bool?
    let lsd: Bool?
    let encryption: Int?
    let anonymous_mode: Bool?
    //let proxy_type: String?
    let proxy_ip: String?
    let proxy_port: Int?
    let proxy_peer_connections: Bool?
    let proxy_auth_enabled: Bool?
    let proxy_username: String?
    let proxy_password: String?
    let proxy_torrents_only: Bool?
    let ip_filter_enabled: Bool?
    let ip_filter_path: String?
    let ip_filter_trackers: Bool?
    let web_ui_domain_list: String?
    let web_ui_address: String?
    let web_ui_port: Int?
    let web_ui_upnp: Bool?
    let web_ui_username: String?
    let web_ui_password: String?
    let web_ui_csrf_protection_enabled: Bool?
    let web_ui_clickjacking_protection_enabled: Bool?
    let web_ui_secure_cookie_enabled: Bool?
    let web_ui_max_auth_fail_count: Int?
    let web_ui_ban_duration: Int?
    let web_ui_session_timeout: Int?
    let web_ui_host_header_validation_enabled: Bool?
    let bypass_local_auth: Bool?
    let bypass_auth_subnet_whitelist_enabled: Bool?
    let bypass_auth_subnet_whitelist: String?
    let alternative_webui_enabled: Bool?
    let alternative_webui_path: String?
    let use_https: Bool?
    let ssl_key: String?
    let ssl_cert: String?
    let web_ui_https_key_path: String?
    let web_ui_https_cert_path: String?
    let dyndns_enabled: Bool?
    let dyndns_service: Int?
    let dyndns_username: String?
    let dyndns_password: String?
    let dyndns_domain: String?
    let rss_refresh_interval: Int?
    let rss_max_articles_per_feed: Int?
    let rss_processing_enabled: Bool?
    let rss_auto_downloading_enabled: Bool?
    let rss_download_repack_proper_episodes: Bool?
    let rss_smart_episode_filters: String?
    let add_trackers_enabled: Bool?
    let add_trackers: String?
    let web_ui_use_custom_http_headers_enabled: Bool?
    let web_ui_custom_http_headers: String?
    let max_seeding_time_enabled: Bool?
    let max_seeding_time: Int?
    let announce_ip: String?
    let announce_to_all_tiers: Bool?
    let announce_to_all_trackers: Bool?
    let async_io_threads: Int?
    let banned_IPs: String?
    let checking_memory_use: Int?
    let current_interface_address: String?
    let current_network_interface: String?
    let disk_cache: Int?
    let disk_cache_ttl: Int?
    let embedded_tracker_port: Int?
    let enable_coalesce_read_write: Bool?
    let enable_embedded_tracker: Bool?
    let enable_multi_connections_from_same_ip: Bool?
    let enable_os_cache: Bool?
    let enable_upload_suggestions: Bool?
    let file_pool_size: Int?
    let outgoing_ports_max: Int?
    let outgoing_ports_min: Int?
    let recheck_completed_torrents: Bool?
    let resolve_peer_countries: Bool?
    let save_resume_data_interval: Int?
    let send_buffer_low_watermark: Int?
    let send_buffer_watermark: Int?
    let send_buffer_watermark_factor: Int?
    let socket_backlog_size: Int?
    let upload_choking_algorithm: Int?
    let upload_slots_behavior: Int?
    let upnp_lease_duration: Int?
    let utp_tcp_mixed_mode: Int?
}