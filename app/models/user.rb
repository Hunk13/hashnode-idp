class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[keycloakopenid]

  def self.from_omniauth(auth)
    auth = JSON.parse auth.to_json, object_class: OpenStruct
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email            = auth.info.email
      user.first_name       = auth.info.first_name
      user.last_name        = auth.info.last_name
      user.password         = Devise.friendly_token[0, 20]
      user.save
    end
  end
end
