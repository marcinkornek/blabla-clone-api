# frozen_string_literal: true
require "rails_helper"

RSpec.describe RideUpdater do
  shared_examples_for "updates valid ride" do
    it "calls #update_ride" do
      expect_any_instance_of(described_class).to receive(:update_ride)
      subject
    end

    it "does NOT create a ride" do
      expect { subject }.not_to change { Ride.count }
    end

    it "update the valid ride", :aggregate_failures do
      subject
      expect(ride.car).to eq(new_car)
      expect(ride.driver).to eq(user)
      expect(ride.start_date).to be_within(2.seconds).of(params[:start_date])
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
      start_location_address: "Zakopane, Poland",
      start_location_latitude: 49.299181,
      start_location_longitude: 19.949562,
      destination_location_country: "Poland",
      destination_location_address: "Opole, Poland",
      destination_location_latitude: 50.6751067,
      destination_location_longitude: 17.9212976,
      places: 5,
      start_date: 10.days.from_now,
      price: 12,
      currency: "pln",
      car_id: new_car.id,
    }
  end
  let(:user) { create(:user) }
  let(:driver) { user }
  let!(:ride) { create(:ride, driver: driver) }
  let(:car) { create(:car, user: user) }
  let(:new_car) { create(:car, user: user) }

  describe "#call" do
    subject { described_class.new(user, ride, params).call }

    context "when ride and user are present" do
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

          it_behaves_like "updates valid ride"
          it_behaves_like "returns ride"

          it "does NOT create locations" do
            expect { subject }.not_to change { Location.count }
          end

          it "updates ride with valid locations", :aggregate_failures do
            subject
            expect(ride.start_location).to eq(location1)
            expect(ride.destination_location).to eq(location2)
          end
        end

        context "when start location and destination location do NOT exist" do
          before { Location.delete_all }
          it_behaves_like "updates valid ride"
          it_behaves_like "returns ride"

          it "creates 2 new locations" do
            expect { subject }.to change { Location.count }.by(2)
          end

          it "updates ride with valid locations", :aggregate_failures do
            subject
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
    end

    context "when user is not present" do
      let(:params) { valid_params }
      let(:driver) { create(:user) }
      let(:user) { nil }

      it "does NOT call #update_ride" do
        expect_any_instance_of(described_class).not_to receive(:update_ride)
        subject
      end

      it { is_expected.to be(nil) }
    end

    context "when ride is not present" do
      let(:params) { valid_params }
      let(:ride) { nil }

      it "does NOT call #update_ride" do
        expect_any_instance_of(described_class).not_to receive(:update_ride)
        subject
      end

      it { is_expected.to be(nil) }
    end
  end
end
