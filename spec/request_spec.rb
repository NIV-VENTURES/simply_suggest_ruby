require 'spec_helper'

class TestController < ActionController::Base
  def test1
    @bot_detector = BotDetection::Detector.new(user_agent: BotDetection::BotUserAgents.first, remote_ip: "127.0.0.1")
  end

  def test2
    @bot_detector = BotDetection::Detector.new(user_agent: "Googlebot/2.1 (+http://www.googlebot.com/bot.html)", remote_ip: "66.249.66.1")
  end
end

describe "Api::Calls" do
  before {
    SimplySuggest.configure do |c|
      c.secret_key  = "secret-2"
      c.public_key  = "public-2"
      c.api_domain  = "http://v1.simply-suggest.dev"
    end
  }

  context 'api calls' do
    it 'check several api methods' do
      expect(SimplySuggest::Request.object_types.get.length).to be > 0
      expect(SimplySuggest::Request.object_types.limit(1).get.length).to be == 1
      expect(SimplySuggest::Request.object_types.album.objects.get.length).to be > 0
      expect(SimplySuggest::Request.object_types.album.object.recommendations.get(1026).length).to be > 0
    end
  end

  context 'module' do
    it 'should be mixed into ActionController::Base' do
      expect(ActionController::Base.included_modules).to include(SimplySuggest::ControllerHelper)
    end

    it 'should test controller helpers with object recommendations' do
      expect(TestController.new.recommendations_for(class: "album", object_id: 1026).length).to be > 0
      expect { TestController.new.recommendations_for(class: "album", object_id: 54684) }.to raise_exception(SimplySuggest::Error)
    end

    it 'should test controller helpers with user recommendations' do
      expect(TestController.new.user_recommendations("ffc0635b-e32b-4a3d-a5b6-2703e08bdc14").length).to be > 0
      expect(TestController.new.user_recommendations("ffc0635b-e32b-4a3d-a5b6-2703e08bdc14", object_type: "series").length).to be > 0
      expect(TestController.new.user_recommendations("ffc0635b-e32b-4a3d-a5b6-2703e08bdc14", object_type: "album").length).to be == 0
    end
  end
end