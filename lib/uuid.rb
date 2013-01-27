require 'securerandom'

module UUID
  def uuid
    SecureRandom.uuid.gsub(/-/, '')
  end
end
