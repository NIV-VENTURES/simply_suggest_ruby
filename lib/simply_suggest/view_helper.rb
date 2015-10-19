module SimplySuggest
  module ViewHelper
    %w[view like dislike favorite buy basket].each do |action|
      define_method "track_#{action}" do |item, user_id, options = {}|
        options = options.merge(event: action, object_type: item.class.to_s.downcase, object_id: item.id, user_id: user_id)
        get_tracking_code options
      end
    end

    def simply_suggest_script
      content_tag :script do
        "(function() {
          var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
          po.src = '//static.#{SimplySuggest.config.domain}/script/v2.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
        })();".html_safe
      end
    end

    def get_tracking_code options = {}
      user_id     = options.delete(:user_id)
      object_id   = options.delete(:object_id)
      object_type = options.delete(:object_type)
      event       = options.delete(:event)
      use_script  = options[:script] == nil ? true : options[:script]

      script = "
        window.track_recommendation = window.track_recommendation || [];
        window.track_recommendation.push({ event: \"setAccount\", value: \"#{SimplySuggest.config.public_key}\" });
        window.track_recommendation.push({ event: \"#{event}\", object: \"#{object_id}\", type: \"#{object_type}\", user: \"#{user_id}\" });
      ".html_safe

      return script unless use_script
      content_tag :script, script
    end

    def track_recommendation_click source_id, destination_id, user_id, klass, options = {}
      use_script  = options[:script] == nil ? true : options[:script]

      script = "
        window.track_recommendation = window.track_recommendation || [];
        window.track_recommendation.push({ event: \"trackClick\", type: \"#{klass}\", source: \"#{source_id}\", destination: \"#{destination_id}\", user: \"#{user_id}\" });
      ".html_safe

      return script unless use_script
      content_tag :script, script
    end
  end
end