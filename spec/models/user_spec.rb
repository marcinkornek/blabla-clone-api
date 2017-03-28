# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) do
    create(:user, first_name: "James", last_name: "Bond", email: "james.bond@a.com",
                  date_of_birth: 20.years.ago, uid: "11111111", provider: "facebook")
  end
  let(:auth) do
    {
      uid: "11111111",
      provider: "facebook",
      email: "james.bond@a.com",
      first_name: "James",
      last_name: "Bond",
    }
  end

  describe "#age" do
    subject { user.age }

    context "date_of_birth present" do
      it "returns age" do
        is_expected.to eq(20)
      end
    end

    context "date_of_birth is nil" do
      before { user.update(date_of_birth: nil) }

      it { is_expected.to be_nil }
    end
  end

  describe "#full_name" do
    subject { user.full_name }

    it "returns first name with first letter of last name" do
      is_expected.to eq("James B")
    end
  end

  describe ".find_for_oauth(auth)" do
    subject { described_class.find_for_oauth(auth) }

    context "when user already registered with email and password" do
      before { user.update(uid: nil, provider: nil) }

      it "returns user" do
        is_expected.to eq(user)
      end

      it "does not create new user" do
        expect { subject }.not_to change { User.count }
      end
    end

    context "when user already registered with oauth" do
      it "returns user" do
        is_expected.to eq(user)
      end

      it "does not create new user" do
        expect { subject }.not_to change { User.count }
      end
    end

    context "when user not registered" do
      before { user.update(uid: nil, provider: nil, email: "other.email@a.com") }

      it "returns new user with valid attributes", :aggregate_failures do
        expect(subject.provider).to eq(auth[:provider])
        expect(subject.uid).to eq(auth[:uid])
        expect(subject.first_name).to eq(auth[:first_name])
        expect(subject.last_name).to eq(auth[:last_name])
        expect(subject.email).to eq(auth[:email])
      end

      it "does creates new user" do
        expect { subject }.to change { User.count }.by(1)
      end
    end
  end
end
