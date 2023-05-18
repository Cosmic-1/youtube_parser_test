require 'google/apis/youtube_v3/service'
require 'google/apis/youtube_v3'

module YoutubeParserService
  class << self
    def search(query, page_token: nil)
      @service = Google::Apis::YoutubeV3::YouTubeService.new
      @service.key = ENV['GOOGLE_API_KEY']

      search_data = @service.list_searches('snippet',
                                           q: query,
                                           max_results: 50,
                                           type: 'channel',
                                           page_token:)

      hash = {
        total_results: search_data.page_info.total_results,
        list: take_data(search_data)
      }
      hash[:prev_page_token] = search_data.prev_page_token if search_data.instance_variable_defined?('@prev_page_token')
      hash[:next_page_token] = search_data.next_page_token if search_data.instance_variable_defined?('@next_page_token')

      hash
    end

    private

    def take_data(list)
      ids_channel = list.items.map { |item| item.id.channel_id }.join(',')
      channels = @service.list_channels('statistics, snippet', id: ids_channel)
      channels.items.map do |channel_item|
        s = channel_item.statistics
        c = channel_item.snippet

        {
          view_count: s.view_count,
          subscriber_count: s.subscriber_count,
          video_count: s.video_count,
          title: c.title,
          description: c.description,
          emails: c.description.scan(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+/)
        }
      end
    end
  end
end
