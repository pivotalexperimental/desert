module Desert
  class VersionChecker
    class << self
      def current_rails_version_matches?(version_requirement)
        version_matches?(::Rails::VERSION::STRING, version_requirement)
      end

      def version_matches?(version, version_requirement)
        Gem::Version::Requirement.new([version_requirement]).satisfied_by?(Gem::Version.new(version))
      end

      def rails_version_is_below_1990?
        result = current_rails_version_matches?('<1.99.0')
        result
      end

      def rails_version_is_below_rc2?
        current_rails_version_matches?('<1.99.1')
      end

      def rails_version_is_1991?
        current_rails_version_matches?('=1.99.1')
      end
    end
  end
end
