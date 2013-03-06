require 'test_helper'

describe Slide do
  describe "create slide" do
    before do
      @slide = Slide.create(:user_id => 1, :name => "new slide")
    end

    it "generate slug" do
      @slide.send(:update_slug)
      assert_equal "new-slide", @slide.slug
    end

    it "generate new slug if duplicate" do
      @slide.send(:update_slug)

      new_slide = Slide.create(:user_id => 1, :name => "New slide")
      new_slide.send(:update_slug)
      assert new_slide.slug.include? "new-slide-"
    end

    it "generate slug for slide with name is nil" do
      slide = Slide.create(:user_id => 1)
      slide.send(:update_slug)
      assert slide.slug.size > 0
    end
  end
end
