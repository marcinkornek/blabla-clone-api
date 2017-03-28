# frozen_string_literal: true

require "rails_helper"

RSpec.describe CarUpdater do
  shared_examples_for "updates valid car" do
    it "does NOT create a car" do
      expect { subject }.not_to change { Car.count }
    end

    it "updates the valid car", :aggregate_failures do
      subject
      expect(car.brand).to eq(params[:brand])
      expect(car.model).to eq(params[:model])
      expect(car.places).to eq(params[:places])
      expect(car.color).to eq(params[:color])
      expect(car.comfort).to eq(params[:comfort])
      expect(car.category).to eq(params[:category])
      expect(car.production_year).to eq(params[:production_year])
    end
  end
  shared_examples_for "does NOT update a car" do
    it "does NOT update a car", :aggregate_failures do
      expect { subject }.not_to change { car }
    end
  end
  shared_examples_for "returns car" do
    it { is_expected.to be_instance_of(Car) }
  end
  let(:user) { create(:user) }
  let(:car) { create(:car) }

  describe "#call" do
    subject { described_class.new(user, car, params).call }

    context "when car and user are present" do
      context "when params are valid" do
        context "when car has a photo" do
          let!(:car) { create(:car_with_photo, user: user) }

          context "when car_photo is present" do
            let(:params) { attributes_for(:other_car_with_photo) }

            it_behaves_like "updates valid car"
            it_behaves_like "returns car"

            it "updates car photo" do
              old_photo_url = car.car_photo.url
              subject
              expect(car.car_photo.url).not_to eq(old_photo_url)
            end
          end

          context "when car_photo is NOT present" do
            let(:params) { attributes_for(:other_car) }

            it_behaves_like "updates valid car"
            it_behaves_like "returns car"

            it "does NOT update car photo" do
              old_photo_url = car.car_photo.url
              subject
              expect(car.car_photo.url).to eq(old_photo_url)
            end
          end
        end

        context "when car does NOT have a photo" do
          let!(:car) { create(:car, user: user) }

          context "when car_photo is present" do
            let(:params) { attributes_for(:other_car_with_photo) }

            it_behaves_like "updates valid car"
            it_behaves_like "returns car"

            it "adds car photo" do
              subject
              expect(car.car_photo.url).not_to be_nil
            end
          end

          context "when car_photo is NOT present" do
            let(:params) { attributes_for(:other_car) }

            it_behaves_like "updates valid car"
            it_behaves_like "returns car"

            it "does NOT add car photo" do
              subject
              expect(car.car_photo.url).to be_nil
            end
          end
        end

        context "when params are NOT valid" do
          let!(:car) { create(:car, user: user) }
          let(:params) { attributes_for(:other_car).except(:brand) }

          it_behaves_like "returns car"
          it_behaves_like "does NOT update a car"
        end
      end
    end

    context "when car is NOT present" do
      let(:params) { attributes_for(:other_car) }
      let(:car) { nil }

      it { is_expected.to be(nil) }
    end

    context "when user is NOT present" do
      let(:params) { attributes_for(:other_car) }
      let(:user) { nil }

      it { is_expected.to be(nil) }
    end
  end
end
