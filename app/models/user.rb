class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :permissions, class_name: "NamespacePermission"

  field :name, type: String
  field :email, type: String
  field :verified_email, type: Boolean
  field :picture, type: String

  after_create :create_user_namespace

  validates :email, presence: true, uniqueness: true

  def jwt(exp = 24.hours.from_now)
    JWT.encode({ user_id: self.id.to_s, exp: exp.to_i }, ENV['DEEP_THOUGHT__AUTH__JWT_SECRET_KEY'])
  end

  # JWT::ExpiredSignature
  def self.find_by_jwt(jwt)
    return if jwt.blank?
    self.find_by(id: JWT.decode(jwt, ENV['DEEP_THOUGHT__AUTH__JWT_SECRET_KEY'])[0]["user_id"])
  end

  def self.create_or_update_by_google_oauth(userinfo)
    user = User.find_by(email: userinfo["email"])
    
    if user.present?
      user.update_attributes!(userinfo.slice("name", "verified_email", "picture"))
      return user
    end
    
    user = User.create(userinfo.slice("name", "email", "verified_email", "picture"))

    return user if user.persisted?
  end

  def namespace
    @namespace ||= Namespace.find_by(name: email)
  end

  def create_user_namespace
    nsp = Namespace.create(name: self.email)
    permissions.create(namespace: nsp, permissions: ['owner'])
  end
end
