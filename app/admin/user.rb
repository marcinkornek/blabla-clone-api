ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  scope :all, default: true

  index do
    selectable_column
    id_column
    column :email
    column :full_name do |user|
      user.full_name
    end
    column :gender
    column "player_id", :player_id
    column :last_seen_at
    column :created_at
    actions
  end

  filter :id
  filter :email
  filter :player_id_not_null, label: "OneSignal player_id present", as: :boolean
  filter :gender, as: :select, collection: proc { User.genders }
  filter :role, as: :select, collection: proc { User.roles }
  filter :sign_in_count
  filter :current_sign_in_at
  filter :created_at
end
