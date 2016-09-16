require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { FactoryGirl.create(:notification) }

  describe "#mark_as_seen!" do
    it "marks notification as seen" do
      expect{ notification.mark_as_seen! }
        .to change{ notification.reload.seen_at }
    end
  end
end
