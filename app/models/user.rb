class User < ActiveRecord::Base

  ROLES = { :visitor => 1, :user => 2, :admin => 3 }
  PERMISSIONS = { :visitor => [], 
                  :user => [:project_create, :project_edit, :user_edit] }

  has_many :participations
  has_many :pledges
  has_and_belongs_to_many :projects, :join_table => 'users_projects'
  attr_accessor :password_confirmation

#  validates_presence_of :login, :password
  validates_uniqueness_of :login, :allow_nil => true
  validates_uniqueness_of :e_mail, :allow_nil => true
  validates_confirmation_of :password
  validates_length_of :login, :maximum => 20, :allow_nil => true
  validates_length_of :password, :maximum => 50, :allow_nil => true
  validates_length_of :firstname, :maximum => 100, :allow_nil => true
  validates_length_of :lastname, :maximum => 100, :allow_nil => true
  validates_length_of :e_mail, :maximum => 100, :allow_nil => true
  validates_format_of :e_mail, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
    :if => Proc.new { |user| !user.e_mail.nil? && !user.e_mail.empty? }
 
  def before_create
    write_attribute('role', ROLES[:visitor]) unless self.role
  end

  def fullname
    !self.firstname.nil? ? "#{self.firstname} #{self.lastname}" : self.login
  end

  def after_validation
    # password validation is done, we can safely encrypt
    self.password = User.encrypt_pwd(self.password) unless self.password.blank? || self.password_confirmation.blank?
  end

  def self.authenticate(login, password)
    user = self.find_by_login(login)
    if user
      provided_pwd = User.encrypt_pwd(password)
      user = nil if provided_pwd != user.password
    end
    user
  end

  def role
    r = read_attribute('role')
    ROLES.each_pair { |key, val| return key if r == val }
    nil
  end
  def role=(r)
    write_attribute('role', ROLES[r])
  end

  private

  def self.encrypt_pwd(pwd)
    Digest::SHA1.hexdigest(pwd)
  end
end
