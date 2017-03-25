# frozen_string_literal: true
require "rails_helper"

RSpec.describe RideCreator do
  shared_examples_for "creates valid ride" do
    it "calls #create_ride" do
      expect_any_instance_of(described_class).to receive(:create_ride)
      subject
    end

    it "creates a ride" do
      expect { subject }.to change { Ride.count }.by(1)
    end

    it "creates the valid ride", :aggregate_failures do
      subject
      ride = Ride.last
      expect(ride.car).to eq(car)
      expect(ride.driver).to eq(user)
      expect(ride.start_date).to be_within(2.seconds).of(params[:start_date].to_datetime)
      expect(ride.price).to eq(params[:price])
      expect(ride.currency).to eq(params[:currency])
      expect(ride.places).to eq(params[:places])
    end
  end
  shared_examples_for "returns ride" do
    it { is_expected.to be_instance_of(Ride) }
  end
  let(:valid_params) do
    {
      start_location_country: "Poland",
      start_location_address: "Wrocław, Poland",
      start_location_latitude: 51.1078852,
      start_location_longitude: 17.0385376,
      destination_location_country: "Poland",
      destination_location_address: "Opole, Poland",
      destination_location_latitude: 50.6751067,
      destination_location_longitude: 17.9212976,
      places: 5,
      start_date: 10.days.from_now.to_s,
      price: 12,
      currency: "pln",
      car_id: car.id,
    }
  end
  let(:user) { create(:user) }
  let(:car) { create(:car, user: user) }

  describe "#call" do
    subject { described_class.new(user, params).call }

    context "when params are valid" do
      let(:params) { valid_params }

      context "when start location and destination location exist" do
        let!(:location1) do
          create(:location, latitude: valid_params[:start_location_latitude],
                            longitude: valid_params[:start_location_longitude])
        end
        let!(:location2) do
          create(:location, latitude: valid_params[:destination_location_latitude],
                            longitude: valid_params[:destination_location_longitude])
        end

        it_behaves_like "creates valid ride"
        it_behaves_like "returns ride"

        it "does NOT create locations" do
          expect { subject }.not_to change { Location.count }
        end

        it "creates ride with valid locations", :aggregate_failures do
          subject
          ride = Ride.last
          expect(ride.start_location).to eq(location1)
          expect(ride.destination_location).to eq(location2)
        end
      end

      context "when start location and destination location do NOT exist" do
        it_behaves_like "creates valid ride"
        it_behaves_like "returns ride"

        it "creates 2 new locations" do
          expect { subject }.to change { Location.count }.by(2)
        end

        it "creates ride with valid locations", :aggregate_failures do
          subject
          ride = Ride.last
          expect(ride.start_location.longitude).to eq(params[:start_location_longitude])
          expect(ride.destination_location.longitude).to eq(params[:destination_location_longitude])
        end
      end
    end

    context "when params are NOT valid" do
      let(:params) { valid_params.except(:start_date) }

      it_behaves_like "returns ride"

      it "does NOT create a ride" do
        expect { subject }.not_to change { Ride.count }
      end
    end

    context "when user is not present" do
      let(:params) { valid_params }
      let(:user) { nil }

      it "does NOT call #create_ride" do
        expect_any_instance_of(described_class).not_to receive(:create_ride)
        subject
      end

      it { is_expected.to be(nil) }
    end
  end
end
