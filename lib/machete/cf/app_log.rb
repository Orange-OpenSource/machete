require 'machete/system_helper'

module Machete
  module CF
    class AppLog

      attr_reader :app

      def initialize(app)
        @app = app
      end

      def contents
        Machete.logger.info "On Host: $ #{command}"
        result = SystemHelper.run_cmd(recent_logs)
        Machete.logger.info result
        result
      end

      private

      def recent_logs
        "cf logs #{app.name} --recent"
      end
    end
  end
end