require 'spec_helper'

module Machete
  module CF
    describe PushApp do
      let(:app) { double(:app, name: 'app_name', src_directory: 'path/to/src') }
      subject(:push_app) { PushApp.new }

      before do
        allow(Dir).
          to receive(:chdir).
               with('path/to/src').
               and_yield
      end

      context 'default arguments' do
        before do
          allow(SystemHelper).to receive(:run_cmd).with('cf push app_name')
        end

        specify do
          push_app.execute(app)
          expect(SystemHelper).to have_received(:run_cmd)
          expect(Dir).to have_received(:chdir)
        end
      end

      context 'start argument is false' do
        before do
          allow(SystemHelper).to receive(:run_cmd).with('cf push app_name --no-start')
        end

        specify do
          push_app.execute(app, start: false)
          expect(SystemHelper).to have_received(:run_cmd)
          expect(Dir).to have_received(:chdir)
        end
      end
    end
  end
end