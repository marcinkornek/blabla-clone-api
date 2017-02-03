# frozen_string_literal: true
require "rails_helper"

RSpec.describe Ride, type: :model do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user) }

  describe ".other_users_rides(user)" do
    context "when only user rides" do
      let!(:ride) { FactoryGirl.create(:ride, driver: user) }

      it "returns empty array" do
        expect(described_class.other_users_rides(user)).to eq([])
      end
    end

    context "when only other user rides" do
      let!(:ride) { FactoryGirl.create(:ride, driver: other_user) }

      it "returns array with other user rides" do
        expect(described_class.other_users_rides(user)).to eq([ride])
      end
    end
  end

  describe "#free_places_count" do
    context "when there are free places" do
      let!(:ride) { FactoryGirl.create(:ride, driver: user, places: 5, taken_places: 0) }

      it "returns number of ride free places" do
        expect(ride.free_places_count).to eq(5)
      end
    end

    context "when there are no free places" do
      let!(:ride) { FactoryGirl.create(:ride, driver: user, places: 5, taken_places: 5) }

      it "returns number of ride free places" do
        expect(ride.free_places_count).to eq(0)
      end
    end
  end

  describe "#places_full" do
    context "when there are free places" do
      let!(:ride) { FactoryGirl.create(:ride, driver: user, places: 1, taken_places: 0) }

      it "returns ride free places in sentence" do
        expect(ride.places_full).to eq("1 place")
      end
    end

    context "when there are no free places" do
      let!(:ride) { FactoryGirl.create(:ride, driver: user, places: 5, taken_places: 5) }

      it "returns ride free places in sentence" do
        expect(ride.places_full).to eq("0 places")
      end
    end
  end

  describe "#user_requested?(user)" do
    let!(:ride) { FactoryGirl.create(:ride, driver: other_user) }

    context "when user requested ride" do
      let!(:ride_request) { FactoryGirl.create(:ride_request, ride: ride, passenger: user) }

      it "returns true" do
        expect(ride.user_requested?(user)).to be_truthy
      end
    end

    context "when user haven't requested ride" do
      it "returns false" do
        expect(ride.user_requested?(user)).to be_falsey
      end
    end
  end

  describe "#user_ride_request(user)" do
    let!(:ride) { FactoryGirl.create(:ride, driver: other_user) }

    context "when user requested ride" do
      let!(:ride_request) { FactoryGirl.create(:ride_request, ride: ride, passenger: user) }

      it "returns ride request" do
        expect(ride.user_ride_request(user)).to be_truthy
      end
    end

    context "when user haven't requested ride" do
      it "returns nil" do
        expect(ride.user_ride_request(user)).to be_falsey
      end
    end
  end

  describe "scopes" do
    describe ".in_currency(currency)" do
      let!(:ride) { FactoryGirl.create(:ride, currency: "pln") }
      subject { described_class.in_currency(currency) }

      context "when some rides in currency exist" do
        let(:currency) { "pln" }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO rides in currency exist" do
        let(:currency) { "eur" }

        it { is_expected.to be_blank }
      end
    end
  end
end
