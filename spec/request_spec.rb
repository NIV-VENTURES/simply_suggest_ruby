require 'spec_helper'

class TestController < ActionController::Base
end

describe "Api::Calls" do
  before {
    SimplySuggest.configure do |c|
      c.secret_key  = "58f38a8b-ca16-4d44-acc9-0a6f0bf0919f"
      c.public_key  = "cbb8f914-d89f-49ef-b732-8b0e133f6cb5"
    end
  }

  context 'api calls' do
    it "creates an object_types and raises an error" do
      expect { SimplySuggest::Request.object_type.create.add_params(name: "article").post }.to raise_exception(SimplySuggest::Error)
    end

    it "updates an object_type" do
      result = SimplySuggest::Request.object_type.update.send("article").add_params(name: "article").patch
      expect(result["error"]).to eq(false)
    end

    it "creates an object in the article object type" do
      expect { SimplySuggest::Request.object_type.send("article").object.create.add_params(object_id: "1").post }.to raise_exception(SimplySuggest::Error)
    end

    it "updates an object with some data" do
      result = SimplySuggest::Request.object_type.send("article").object.update.add_params(data: { title: "lorem", description: "test" }).patch(1)
      expect(result["error"]).to eq(false)
    end

    it 'checks object type api methods' do
      expect(SimplySuggest::Request.object_types.get.length).to be > 0
      expect(SimplySuggest::Request.object_types.limit(1).get.length).to be == 1
    end

    it "checks object api methods" do
      expect(SimplySuggest::Request.object_type.article.get.length).to be > 0
      expect { SimplySuggest::Request.object_types.article.object.recommendations.get(1026) }.to raise_exception(SimplySuggest::Error)
    end
  end

  context 'module' do
    it 'should be mixed into ActionController::Base' do
      expect(ActionController::Base.included_modules).to include(SimplySuggest::ControllerHelper)
    end

    it "tests search methods" do
      result = TestController.new.search_objects("test", "article")
      expect(result["objects"].length).to eq(1)
    end

    # it 'should test controller helpers with object recommendations' do
    #   expect(TestController.new.recommendations_for(class: "article", object_id: 1).length).to be > 0
    #   expect { TestController.new.recommendations_for(class: "article", object_id: 123) }.to raise_exception(SimplySuggest::Error)
    # end

    # it 'should test controller helpers with user recommendations' do
    #   expect(TestController.new.user_recommendations("ffc0635b-e32b-4a3d-a5b6-2703e08bdc14").length).to be > 0
    #   expect(TestController.new.user_recommendations("ffc0635b-e32b-4a3d-a5b6-2703e08bdc14", object_type: "series").length).to be > 0
    #   expect(TestController.new.user_recommendations("ffc0635b-e32b-4a3d-a5b6-2703e08bdc14", object_type: "album").length).to be == 0
    # end
  end
end