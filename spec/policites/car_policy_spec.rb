# frozen_string_literal: true

require "rails_helper"

RSpec.describe CarPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }


  shared_examples_for "grants access when user is present" do
    it { is_expected.to be(true) }
  end
  shared_examples_for "denies access when user is NOT present" do
    let(:user) { nil }

    it { is_expected.to be(false) }
  end
  shared_examples_for "denies access when car is NOT present" do
    let(:car) { nil }

    it { is_expected.to be(false) }
  end
  shared_examples_for "denies access when user is NOT car creator" do
    let(:creator) { other_user }

    it { is_expected.to be(false) }
  end
  shared_examples_for "grants access when user is car creator" do
    let(:creator) { user }

    it { is_expected.to be(true) }
  end

  describe "#create?" do
    subject { described_class.new(user, :car).create? }

    it_behaves_like "denies access when user is NOT present"
    it_behaves_like "grants access when user is present"
  end

  describe "#update?" do
    let(:creator) { user }
    let!(:car) { create(:car, user: creator) }
    subject { described_class.new(user, car).update? }

    it_behaves_like "denies access when user is NOT present"
    it_behaves_like "denies access when car is NOT present"
    it_behaves_like "denies access when user is NOT car creator"
    it_behaves_like "grants access when user is car creator"
  end
end
