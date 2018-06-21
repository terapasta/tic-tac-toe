class ZendeskClient
  def self.make_client_with(credential)
    ZendeskAPI::Client.new do |config|
      # Mandatory:

      config.url = credential.url # e.g. https://mydesk.zendesk.com/api/v2

      # Basic / Token Authentication
      config.username = credential.username

      # Choose one of the following depending on your authentication choice
      config.token = credential.access_token
      # config.password = "your zendesk password"

      # OAuth Authentication
      # config.access_token = "your OAuth access token"

      # Optional:

      # Retry uses middleware to notify the user
      # when hitting the rate limit, sleep automatically,
      # then retry the request.
      config.retry = true

      # Logger prints to STDERR by default, to e.g. print to stdout:
      require 'logger'
      config.logger = Logger.new(STDOUT)

      # Changes Faraday adapter
      # config.adapter = :patron

      # Merged with the default client options hash
      # config.client_options = { :ssl => false }

      # When getting the error 'hostname does not match the server certificate'
      # use the API at https://yoursubdomain.zendesk.com/api/v2
    end
  end

  def self.shared_client
    @client ||= make_client_with(ZendeskCredential.new(
      url: ENV['ZENDESK_URL'],
      username: ENV['ZENDESK_USERNAME'],
      access_token: ENV['ZENDESK_TOKEN']
    ))
  end

  def shared_client
    self.class.shared_client
  end

  def get_help_center_data(client = nil)
    @data = (client || shared_client).hc_categories.to_a.inject({
      sections: [],
      articles: []
    }) { |acc, cat|
      acc[:sections] += cat.sections.to_a
      acc[:articles] += cat.articles.to_a
      acc
    }
  end

  def sections
    @data[:sections] || []
  end

  def articles
    @data[:articles] || []
  end

  def section_by(id)
    sections.detect{ |it| it.id == id }
  end

  def import_articles_for!(bot)
    h = ActionController::Base.helpers
    articles.each do |article|
      qa = bot.question_answers.find_or_initialize_by(zendesk_article_id: article.id)
      qa.question = article.name
      answer_text = h.raw(h.truncate(h.strip_tags(article.body), length: 150)&.sub(/^\n+/, ''))
      qa.answer = "#{answer_text}\n#{article.html_url}"
      qa.save!

      section = section_by(article.section_id)
      next unless section.present?

      tag = bot.topic_tags.find_or_create_by!(name: section.name, bot_id: bot.id)
      next unless qa.topic_taggings.find_by(topic_tag_id: tag.id).blank?
      qa.topic_taggings.create!(topic_tag_id: tag.id)
    end
  end
end