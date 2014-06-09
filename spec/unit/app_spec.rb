require './spec/spec_helper'
require 'machete/app'

describe Machete::App do

  context "when using a database" do
    let(:app) { Machete::App.new('path/app_name', with_pg: true) }

    before do
      allow(Machete).to receive(:logger).and_return(double.as_null_object)

      # capture all run_cmd arguments for easier debugging
      @run_commands = []
      allow_any_instance_of(Machete::SystemHelper).to receive(:run_cmd) do |_, *ary|
        @run_commands.push ary.first
        ""
      end

      allow_any_instance_of(Machete::App).to receive(:generate_manifest).and_return(nil)
      allow(Dir).to receive(:chdir).and_yield

      app.push
    end

    it "runs every command once" do
      expect(@run_commands.uniq).to eq(@run_commands)
    end

    it "pushes the app without starting it" do
      expect(@run_commands).to include("cf push app_name --no-start")
    end

    it "sets the DATABASE_URL environment variable with default DB" do
      expect(@run_commands).to include("cf set-env app_name DATABASE_URL postgres://buildpacks:buildpacks@10.245.0.30:5524/buildpacks")
    end

    it "pushes the app once" do
      expect(@run_commands).to include("cf push app_name")
    end

    describe "specifying a different database" do
      let(:app) { Machete::App.new('path/app_name', with_pg: true, database_name: "wordpress") }

      it "sets the DATABASE_URL environment variable with default DB" do
        expect(app).to have_received(:run_cmd).with("cf set-env app_name DATABASE_URL postgres://buildpacks:buildpacks@10.245.0.30:5524/wordpress")
      end
    end
  end
end