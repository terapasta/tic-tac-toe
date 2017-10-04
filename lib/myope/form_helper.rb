# FIXME namespaceに従って配置するディレクトリを整理する
module ActionView
  module Helpers
    module FormHelper
      def autocomplete_text_area(object_name, method, source, options ={})
        options["data-autocomplete"] = source
        text_area(object_name, method, rewrite_autocomplete_option(options))
      end
    end
  end
end

class ActionView::Helpers::FormBuilder
  def autocomplete_text_area(method, source, options = {})
    @template.autocomplete_text_area(@object_name, method, source, objectify_options(options))
  end
end
