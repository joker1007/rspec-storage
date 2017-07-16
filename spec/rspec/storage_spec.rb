require "spec_helper"

describe RSpec::Storage do
  it "has a version number" do
    expect(RSpec::Storage::VERSION).not_to be nil
  end

  context "with s3 scheme" do
    it do
      expect(RSpec::Storage::S3).to receive(:handle_location)
      config = RSpec::Core::Configuration.new
      config.add_formatter("json", "s3://example.com/result.json")
    end
  end

  context "with gs scheme" do
    it do
      expect(RSpec::Storage::GCS).to receive(:handle_location)
      config = RSpec::Core::Configuration.new
      config.add_formatter("json", "gs://example.com/result.json")
    end
  end
end
