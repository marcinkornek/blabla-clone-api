# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ride, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe "#free_places_count" do
    context "when there are free places" do
      let!(:ride) { create(:ride, driver: user, places: 5, taken_places: 0) }

      it "returns number of ride free places" do
        expect(ride.free_places_count).to eq(5)
      end
    end

    context "when there are no free places" do
      let!(:ride) { create(:ride, driver: user, places: 5, taken_places: 5) }

      it "returns number of ride free places" do
        expect(ride.free_places_count).to eq(0)
      end
    end
  end

  describe "#places_full" do
    context "when there are free places" do
      let!(:ride) { create(:ride, driver: user, places: 1, taken_places: 0) }

      it "returns ride free places in sentence" do
        expect(ride.places_full).to eq("1 place")
      end
    end

    context "when there are no free places" do
      let!(:ride) { create(:ride, driver: user, places: 5, taken_places: 5) }

      it "returns ride free places in sentence" do
        expect(ride.places_full).to eq("0 places")
      end
    end
  end

  describe "#user_requested?(user)" do
    let!(:ride) { create(:ride, driver: other_user) }

    context "when user requested ride" do
      let!(:ride_request) { create(:ride_request, ride: ride, passenger: user) }

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
    let!(:ride) { create(:ride, driver: other_user) }

    context "when user requested ride" do
      let!(:ride_request) { create(:ride_request, ride: ride, passenger: user) }

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
    describe ".from_city(latitude, longitude)" do
      let(:location) { create(:location) }
      let!(:ride) { create(:ride, start_location_id: location.id) }
      subject { described_class.from_city(latitude, longitude) }

      context "when some rides from location exist" do
        let(:latitude) { location.latitude }
        let(:longitude) { location.longitude }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO rides from location exist" do
        let(:latitude) { "11" }
        let(:longitude) { "20" }

        it { is_expected.to be_blank }
      end
    end

    describe ".to_city(latitude, longitude)" do
      let(:location) { create(:location) }
      let!(:ride) { create(:ride, destination_location_id: location.id) }
      subject { described_class.to_city(latitude, longitude) }

      context "when some rides to location exist" do
        let(:latitude) { location.latitude }
        let(:longitude) { location.longitude }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO rides to location exist" do
        let(:latitude) { "11" }
        let(:longitude) { "20" }

        it { is_expected.to be_blank }
      end
    end

    describe ".on_day(date)" do
      let!(:ride) { create(:ride, start_date: Time.zone.parse("2016-05-19 10:30:14")) }
      subject { described_class.on_day(date) }

      context "when some rides on day exist" do
        let(:date) { Time.zone.parse("2016-05-19") }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO rides on day exist" do
        let(:date) { Time.zone.parse("2016-05-22") }

        it { is_expected.to be_blank }
      end
    end

    describe ".in_currency(currency)" do
      let!(:ride) { create(:ride, currency: "pln") }
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

    describe ".without_full" do
      let!(:ride) { create(:ride, places: 2) }
      subject { described_class.without_full }

      context "when some rides without full exist" do
        it { is_expected.to match_array([ride]) }
      end

      context "when NO rides without full exist" do
        let!(:ride_request) { other_user.ride_requests.create(ride: ride, places: 2) }
        before { ride_request.update(status: "accepted") }

        it { is_expected.to be_blank }
      end
    end

    describe ".full" do
      let!(:ride) { create(:ride, places: 2) }
      subject { described_class.full }

      context "when some full rides exist" do
        let!(:ride_request) { other_user.ride_requests.create(ride: ride, places: 2) }
        before { ride_request.update(status: "accepted") }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO full rides exist" do
        it { is_expected.to be_blank }
      end
    end

    describe ".future" do
      let!(:ride) { create(:ride, start_date: start_date) }
      subject { described_class.future }

      context "when some future rides exist" do
        let(:start_date) { 1.day.from_now }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO future rides exist" do
        let(:start_date) { 1.day.ago }

        it { is_expected.to be_blank }
      end
    end

    describe ".past" do
      let!(:ride) { create(:ride, start_date: start_date) }
      subject { described_class.past }

      context "when some past rides exist" do
        let(:start_date) { 1.day.ago }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO past rides exist" do
        let(:start_date) { 1.day.from_now }

        it { is_expected.to be_blank }
      end
    end

    describe ".other_users_rides(user)" do
      let!(:ride) { create(:ride, driver: driver) }
      subject { described_class.other_users_rides(user) }

      context "when some other user rides" do
        let(:driver) { other_user }

        it { is_expected.to match_array([ride]) }
      end

      context "when NO other user rides" do
        let(:driver) { user }

        it { is_expected.to be_blank }
      end
    end

    describe ".not_requested_rides(user)" do
      let!(:ride) { create(:ride, driver: other_user) }
      subject { described_class.not_requested_rides(user) }

      context "when some rides user not requested" do
        it { is_expected.to match_array([ride]) }
      end

      context "when NO rides user not requested" do
        let!(:ride_request) { user.ride_requests.create(ride: ride, places: 2) }

        it { is_expected.to be_blank }
      end
    end
  end
end
