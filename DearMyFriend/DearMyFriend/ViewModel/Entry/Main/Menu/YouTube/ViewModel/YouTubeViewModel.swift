
import Foundation

class YouTubeViewModel {
    var youtubeChannels: [YouTubeChannel] = []

    init() {
        let dataForYoutube = DataForYoutube(thumbnail: "", title: "", description: "", link: "")
        youtubeChannels = dataForYoutube.youtubeDataForCat.map {
            YouTubeChannel(thumbnail: $0.thumbnail, title: $0.title, description: $0.description, link: $0.link)
        }
    }

    func numberOfChannels() -> Int {
        return youtubeChannels.count
    }

    func channel(at index: Int) -> YouTubeChannel {
        return youtubeChannels[index]
    }
}
