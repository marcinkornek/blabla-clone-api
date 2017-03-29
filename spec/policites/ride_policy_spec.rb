# frozen_string_literal: true

require "rails_helper"

RSpec.describe RidePolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  shared_examples_for "grants access when user is present" do
    it { is_expected.to be(true) }
  end
  shared_examples_for "denies access when user is NOT present" do
    let(:driver) { other_user }
    let(:user) { nil }

    it { is_expected.to be(false) }
  end
  shared_examples_for "denies access when ride is NOT present" do
    let(:ride) { nil }

    it { is_expected.to be(false) }
  end
  shared_examples_for "denies access when user is NOT ride driver" do
    let(:driver) { other_user }

    it { is_expected.to be(false) }
  end
  shared_examples_for "grants access when user is ride driver" do
    let(:driver) { user }

    it { is_expected.to be(true) }
  end
  shared_examples_for "denies access when user is ride driver" do
    let(:driver) { user }

    it { is_expected.to be(false) }
  end
  shared_examples_for "denies access when user is ride passenger" do
    let(:driver) { other_user }
    let!(:ride_request) { create(:ride_request, ride: ride, passenger: user) }

    it { is_expected.to be(false) }
  end

  describe "#create?" do
    subject { described_class.new(user, :ride).create? }

    it_behaves_like "denies access when user is NOT present"
    it_behaves_like "grants access when user is present"
  end

  describe "#update?" do
    let(:driver) { user }
    let!(:ride) { create(:ride, driver: driver) }
    subject { described_class.new(user, ride).update? }

    it_behaves_like "denies access when user is NOT present"
    it_behaves_like "denies access when ride is NOT present"
    it_behaves_like "denies access when user is NOT ride driver"
    it_behaves_like "grants access when user is ride driver"
  end

  describe "#show_rides_as_passenger?" do
    subject { described_class.new(user, :ride).show_rides_as_passenger? }

    it_behaves_like "grants access when user is present"
    it_behaves_like "denies access when user is NOT present"
  end

  describe "#show_rides_as_driver?" do
    subject { described_class.new(user, :ride).show_rides_as_driver? }

    it_behaves_like "grants access when user is present"
    it_behaves_like "denies access when user is NOT present"
  end

  describe "#create_ride_request?" do
    let(:driver) { user }
    let!(:ride) { create(:ride, driver: driver) }
    subject { described_class.new(user, ride).create_ride_request? }

    it_behaves_like "denies access when user is NOT present"
    it_behaves_like "denies access when ride is NOT present"
    it_behaves_like "denies access when user is ride driver"
    it_behaves_like "denies access when user is ride passenger"
  end
end
