class Settings::PagesController < ApplicationController
  include BotUsable
  before_action :set_bot
  helper_method :embed_js

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def embed_js(position)
      %Q{<script type="text/javascript">
        (function() {
          var head = document.querySelector("head");
          var src = "#{embed_js_url}";
          var isAlreadyLoaded = document.querySelector("[src='" + src + "']");
          if (isAlreadyLoaded) { return console.warn("[My-ope office] Duplicated loading scripts"); }
          var js = document.createElement("script");
          js.src = src;
          js.async = true;
          js.id = "MyOpeEmbedScript";
          head.appendChild(js);
        }).call(this);
      </script>
      <div id="MyOpeChatWidget" data-token="#{@bot.token}" data-position="#{position}"></div>}
    end

    def embed_js_url
      if Rails.env.development?
        "http://#{request.env['HTTP_HOST']}/assets/embed.js"
      else
        "#{ActionController::Base.asset_host}/assets/embed.js"
      end
    end
end
