# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmailUniquenessChecker do
  let!(:other_user) { create(:user, email: "test1@a.com") }

  describe "#call" do
    let(:params) { { email: email } }
    let(:false_response) { { errors: ["Email already exists"] } }
    let(:true_response) { { errors: [] } }
    subject { described_class.new(user, params).call }

    context "when user is nil (when creating account)" do
      let(:user) { nil }
      context "when email exists" do
        let(:email) { other_user.email }

        it { is_expected.to eq(false_response) }
      end

      context "when email does NOT exist" do
        let(:email) { "new_email@a.com" }

        it { is_expected.to eq(true_response) }
      end
    end

    context "when user is NOT nil (when updating account)" do
      let(:user) { create(:user) }

      context "when email exists" do
        let(:email) { other_user.email }

        it { is_expected.to eq(false_response) }
      end

      context "when email does NOT exist" do
        let(:email) { "new_email@a.com" }

        it { is_expected.to eq(true_response) }
      end

      context "when email is the same as present" do
        let(:email) { user.email }

        it { is_expected.to eq(true_response) }
      end
    end
  end
end
