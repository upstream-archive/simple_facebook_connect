require 'zlib'
require 'digest/md5'

module SimpleFacebookConnect
  module UserExtension
    
    def self.included(base)
      base.class_eval do
        before_save :build_email_hash, :if => :email_changed?
      end
    end
  
    private

    def build_email_hash
      str = email.strip.downcase
      self.email_hash = "#{Zlib.crc32(str)}_#{Digest::MD5.hexdigest(str)}"
    end

  end
end