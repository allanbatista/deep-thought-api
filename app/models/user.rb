class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String  

  validates :email, presence: true, uniqueness: true
end
