# frozen_string_literal: true

require "rails_helper"

RSpec.describe RideRequestPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  shared_examples_for "denies access when user is NOT present" do
    let(:driver) { other_user }
    let(:user) { nil }

    it { is_expected.to be(false) }
  end
  shared_examples_for "denies access when ride_request is NOT present" do
    let(:ride_request) { nil }

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

  describe "#update?" do
    let(:driver) { user }
    let(:ride) { create(:ride, driver: driver) }
    let!(:ride_request) { create(:ride_request, ride: ride) }
    subject { described_class.new(user, ride_request).update? }

    it_behaves_like "denies access when user is NOT present"
    it_behaves_like "denies access when ride_request is NOT present"
    it_behaves_like "denies access when user is NOT ride driver"
    it_behaves_like "grants access when user is ride driver"
  end
end
