import Foundation
class YouTubeViewModel {
    var channels: [[DataForYoutube]] = []

    init() {
        let dataForYoutube = DataForYoutube(thumbnail: "", title: "", description: "", link: "")

        let catChannels = dataForYoutube.youtubeDataForCat.map {
            DataForYoutube(thumbnail: $0.thumbnail, title: $0.title, description: $0.description, link: $0.link)
        }

        let dogChannels = dataForYoutube.youtubeDataForDog.map {
            DataForYoutube(thumbnail: $0.thumbnail, title: $0.title, description: $0.description, link: $0.link)
        }

        channels = [catChannels, dogChannels]
    }

    func numberOfSections() -> Int {
        return channels.count
    }

    func numberOfChannels(in section: Int) -> Int {
        return channels[section].count
    }

    func channel(at indexPath: IndexPath) -> DataForYoutube {
        return channels[indexPath.section][indexPath.row]
    }
}
