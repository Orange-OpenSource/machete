module Machete
  class VendorDependencies
    VENDOR_SCRIPT = 'package.sh'

    def execute(app)
      Dir.chdir(app.src_directory) do
        return unless File.exist?(VENDOR_SCRIPT)

        Machete.logger.action('Vendoring dependencies before push')
        vendor_dependencies
      end
    end

    private

    def vendor_dependencies
      cmd_output = Bundler.with_clean_env do
        SystemHelper.run_cmd("./#{VENDOR_SCRIPT}")
      end

      handle_error(cmd_output)
    end

    def handle_error(cmd_output)
      if SystemHelper.exit_status != 0
        raise "Failed to vendor dependencies:\n#{cmd_output}"
      end
    end
  end
end