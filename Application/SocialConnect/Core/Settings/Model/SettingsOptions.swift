import Foundation

enum SettingsOptions: Int, CaseIterable, Identifiable {
    case notifications
    case privacy
    case account
    case help
    case about
    
    var title: String {
        switch self {
        case .notifications: return "Notificaciones"
        case .privacy: return "Privacidad"
        case .account: return "Cuenta"
        case .help: return "Ayuda"
        case .about: return "Acerca de"
        }
    }
    
    var imageName: String {
        switch self {
        case .notifications: return "bell"
        case .privacy: return "lock"
        case .account: return "person.circle"
        case .help: return "questionmark.circle"
        case .about: return "info.circle"
        }
    }
    
    var id: Int { return self.rawValue }
}
