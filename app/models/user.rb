class User < ActiveRecord::Base
  has_one :employee, autosave: true

  scope :search_query, lambda {|query|
    term = "%#{query.try(:downcase)}%"    
    where('LOWER(users.name) LIKE ? OR LOWER(users.email) LIKE ? OR LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ?', term, term, term, term)
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # def from_omniauth(auth_hash)
  #   user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
  #   user.name = auth_hash['info']['name']
  #   user.email = auth_hash['info']['email']
  #   user.image = auth_hash['info']['image']
  #   user.first_name = auth_hash['info']['first_name']
  #   user.last_name = auth_hash['info']['last_name']
  #   user.url = auth_hash['info']['urls'][user.provider.capitalize]
  #   # user.save!
  #   puts user.to_yaml
  #   user
  # end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    # puts "Finding user: #{data}"
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      # puts "User found: #{user.id}"
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      # puts "User by email: #{registered_user}"
      if registered_user
        # puts "Found #{registered_user.id}"
        return registered_user
      else
        # puts "Not found in User DB, trying Employee"
        employee = Employee.where(email: data["email"]).first
        if employee.present?
          user = User.create(name: data["name"],
            provider:access_token.provider,
            email: data["email"],
            first_name: employee.first_name,
            last_name: employee.last_name,
            uid: access_token.uid,
            image_url: access_token.extra.raw_info["picture"],
            password: Devise.friendly_token[0,20],
            roles: User.roles_from_job_title(employee.job_title)
          )
          employee.user_id = user.id
          employee.save 
        end
        return user
      end
    end
  end

  # See this post: https://github.com/ryanb/cancan/wiki/ability-for-other-users
  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, :to => :ability

  # For authorization
  ROLES = %i[admin manager student teacher staff employee inventory carpool librarian]

  def roles=(roles)
    roles = [*roles].map { |r| r.to_sym }
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_role?(role)
    roles.include?(role)
  end

  def admin?
    self.has_role? :admin
  end

  # For API authentication
  def generate_auth_token
    token = SecureRandom.hex
    self.update_columns(auth_token: token)
    token
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil)
  end

  # Class Methods
  
  def self.valid_role?(string)
    ROLES.include? string.downcase.to_sym
  end

  def self.roles_from_job_title(job_title)
    job_title.split(',').map(&:strip).map(&:downcase).map(&:to_sym) & ROLES
  end
end
