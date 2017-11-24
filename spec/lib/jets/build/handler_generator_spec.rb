require "spec_helper"

describe "HandlerGenerator" do
  context "controller" do
    let(:generator) do
      Jets::Build::HandlerGenerator.new("app/controllers/posts_controller.rb")
    end

    it "generates a node shim" do
      generator.generate
      # okay to use tmp_app_root because we just have generated it above
      content = IO.read("#{Jets::Build.tmp_app_root("full")}/handlers/controllers/posts_controller.js")
      expect(content).to include("handlers/controllers/posts_controller.create") # handler
      expect(content).to include("exports.create") # 1st function
      expect(content).to include("exports.update") # 2nd function
    end
  end

  context "job" do
    let(:generator) do
      Jets::Build::HandlerGenerator.new("app/jobs/hard_job.rb")
    end

    it "generates a node shim" do
      generator.generate
      content = IO.read("#{Jets::Build.tmp_app_root("full")}/handlers/jobs/hard_job.js")
      expect(content).to include("handlers/jobs/hard_job.dig") # handler
      expect(content).to include("exports.dig")
    end
  end
end
