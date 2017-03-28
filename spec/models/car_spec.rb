# frozen_string_literal: true

require "rails_helper"

RSpec.describe Car, type: :model do
  let(:car) { create(:car, brand: "Ford", model: "Focus", comfort: 1) }

  describe "#full_name" do
    subject { car.full_name }

    it "returns car brand and model" do
      is_expected.to eq("Ford Focus")
    end
  end

  describe "#comfort_stars" do
    subject { car.comfort_stars }

    context "car comfort present" do
      it "returns comfort stars" do
        is_expected.to eq(1)
      end
    end

    context "car comfort is nil" do
      before { car.update(comfort: nil) }

      it { is_expected.to be_nil }
    end
  end
end
