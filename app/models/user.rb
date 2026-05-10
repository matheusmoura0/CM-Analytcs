class User < ApplicationRecord
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[admin editor reporter] }
  
  ROLES = {
    reporter: 'reporter',
    editor: 'editor',
    admin: 'admin'
  }.freeze
  
  def admin?
    role == 'admin'
  end
  
  def editor?
    role == 'editor'
  end
  
  def reporter?
    role == 'reporter'
  end
  
  def can_access_all_sections?
    admin? || editor?
  end
  
  def can_access_section?(section)
    admin? || editor? || (reporter? && own_sections.include?(section))
  end
  
  def own_sections
    permissions['sections'] || []
  end
end
