# frozen_string_literal: true
require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:notification) { FactoryGirl.create(:notification) }

  describe "#mark_as_seen!" do
    it "marks notification as seen" do
      expect { notification.mark_as_seen! }
        .to change { notification.reload.seen_at }
    end
  end

  describe "scopes" do
    describe "unread" do
      let(:seen_notification) { FactoryGirl.create(:notification, seen_at: 2.days.ago) }

      it "returns only not seen notifications" do
        expect(described_class.unread).to include(notification)
        expect(described_class.unread).not_to include(seen_notification)
      end
    end
  end
end
