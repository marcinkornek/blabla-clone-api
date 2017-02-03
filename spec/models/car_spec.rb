# frozen_string_literal: true
require "rails_helper"

RSpec.describe Car, type: :model do
  let(:car) { FactoryGirl.create(:car, brand: "Ford", model: "Focus", comfort: 1) }

  describe "#full_name" do
    it "returns car brand and model" do
      expect(car.full_name).to eq("Ford Focus")
    end
  end

  describe "#comfort_stars" do
    context "car comfort present" do
      it "returns comfort stars" do
        expect(car.comfort_stars).to eq(1)
      end
    end

    context "car comfort is nil" do
      before { car.update(comfort: nil) }

      it "returns nil" do
        expect(car.comfort_stars).to be_nil
      end
    end
  end
end
