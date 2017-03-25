# frozen_string_literal: true
require "rails_helper"

RSpec.describe CarCreator do
  shared_examples_for "creates valid car" do
    it "calls #create_car" do
      expect_any_instance_of(described_class).to receive(:create_car)
      subject
    end

    it "creates a car" do
      expect { subject }.to change { Car.count }.by(1)
    end

    it "creates the valid car", :aggregate_failures do
      subject
      car = Car.last
      expect(car.brand).to eq(params[:brand])
      expect(car.model).to eq(params[:model])
      expect(car.places).to eq(params[:places])
      expect(car.color).to eq(params[:color])
      expect(car.comfort).to eq(params[:comfort])
      expect(car.category).to eq(params[:category])
      expect(car.production_year).to eq(params[:production_year])
    end
  end
  shared_examples_for "returns car" do
    it { is_expected.to be_instance_of(Car) }
  end
  let(:user) { create(:user) }

  describe "#call" do
    subject { described_class.new(user, params).call }

    context "when params are valid" do
      context "when car_photo is present" do
        let(:params) { attributes_for(:car_with_photo) }

        it_behaves_like "creates valid car"
        it_behaves_like "returns car"

        it "adds car photo" do
          subject
          car = Car.last
          expect(car.car_photo.url).not_to be_nil
        end
      end

      context "when car_photo is NOT present" do
        let(:params) { attributes_for(:car) }

        it_behaves_like "creates valid car"
        it_behaves_like "returns car"

        it "does NOT add car photo" do
          subject
          car = Car.last
          expect(car.car_photo.url).to be_nil
        end
      end
    end

    context "when params are NOT valid" do
      let(:params) { attributes_for(:car).except(:brand) }

      it_behaves_like "returns car"

      it "does NOT create a car" do
        expect { subject }.not_to change { Car.count }
      end
    end

    context "when user is not present" do
      let(:params) { attributes_for(:car) }
      let(:user) { nil }

      it "does NOT call #create_car" do
        expect_any_instance_of(described_class).not_to receive(:create_car)
        subject
      end

      it { is_expected.to be(nil) }
    end
  end
end
