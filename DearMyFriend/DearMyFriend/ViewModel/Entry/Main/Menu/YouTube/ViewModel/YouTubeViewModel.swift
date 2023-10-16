
import Foundation

class YouTubeViewModel {
    var youtubeChannels: [DataForYoutube] = []

    init() {
        let dataForYoutube = DataForYoutube(thumbnail: "", title: "", description: "", link: "")
        youtubeChannels = dataForYoutube.youtubeDataForCat.map {
            DataForYoutube(thumbnail: $0.thumbnail, title: $0.title, description: $0.description, link: $0.link)
        }
    }

    func numberOfChannels() -> Int {
        return youtubeChannels.count
    }

    func channel(at index: Int) -> DataForYoutube {
        return youtubeChannels[index]
    }
}
