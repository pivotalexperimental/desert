module ActionView #:nodoc:
  class Base #:nodoc:
    def find_template_extension_from_handler(template_path, formatted = nil)
      checked_template_path = formatted ? "#{template_path}.#{template_format}" : template_path

      view_paths.each do |view_path|
        self.class.template_handler_extensions.each do |extension|
          file_path = File.join(view_path, "#{checked_template_path}.#{extension}")
          if File.exist?(file_path)
            return formatted ? "#{template_format}.#{extension}" : extension.to_s
          end
        end
      end
      nil
    end
  end
end
