require 'machete/host/log'
require 'bundler'

module Machete
  class VagrantCWDMissingError < StandardError; end

  class Host
    def run command
      check_vagrant_cwd

      result = ''
      Bundler.with_clean_env do
        result = `vagrant ssh -c '#{command}' 2>&1`
      end
      result
    end

    private
    def check_vagrant_cwd
      raise VagrantCWDMissingError, 'VAGRANT_CWD environment variable is not set' unless ENV['VAGRANT_CWD']
    end
  end
end