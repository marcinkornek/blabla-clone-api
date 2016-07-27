require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) do
    FactoryGirl.create(:user,
      first_name: "James",
      last_name: "Bond",
      email: "james.bond@a.com",
      birth_year: 20.years.ago,
      uid: "11111111",
      provider: "facebook"
    )
  end

  let(:auth) do
    {
      :uid => "11111111",
      :provider => "facebook",
      :email => "james.bond@a.com",
      :first_name => "James",
      :last_name => "Bond"
    }
  end

  describe ".find_for_oauth(auth)" do
    context "when user already registered with email and password" do
      before { user.update(uid: nil, provider: nil) }

      it "returns user" do
        expect(User.find_for_oauth(auth)).to eq(user)
      end

      it "does not create new user" do
        expect{ User.find_for_oauth(auth) }.not_to change{ User.count }
      end
    end

    context "when user already registered with oauth" do
      it "returns user" do
        expect(User.find_for_oauth(auth)).to eq(user)
      end

      it "does not create new user" do
        expect{ User.find_for_oauth(auth) }.not_to change{ User.count }
      end
    end

    context "when user not registered" do
      before { user.update(uid: nil, provider: nil, email: 'other.email@a.com') }

      it "returns new user with valid attributes" do
        expect(User.find_for_oauth(auth).provider).to eq(auth[:provider])
        expect(User.find_for_oauth(auth).uid).to eq(auth[:uid])
        expect(User.find_for_oauth(auth).first_name).to eq(auth[:first_name])
        expect(User.find_for_oauth(auth).last_name).to eq(auth[:last_name])
        expect(User.find_for_oauth(auth).email).to eq(auth[:email])
      end

      it "does creates new user" do
        expect{ User.find_for_oauth(auth) }.to change{ User.count }.by(1)
      end
    end
  end

  describe "#age" do
    context "birth_year present" do
      it "returns age" do
        expect(user.age).to eq(20)
      end
    end

    context "birth_year is nil" do
      before { user.update(birth_year: nil) }

      it "returns nil" do
        expect(user.age).to be_nil
      end
    end
  end

  describe "#full_name" do
    it "returns first name with first letter of last name" do
      expect(user.full_name).to eq("James B")
    end
  end
end
