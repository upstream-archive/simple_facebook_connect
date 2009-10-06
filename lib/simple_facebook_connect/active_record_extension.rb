module SimpleFacebookConnect
  module ActiveRecordExtension
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def facebook_user
        include SimpleFacebookConnect::UserExtension
      end
    end
  end
end