require "./spec_helper"
require "../src/snyk"

describe Snyk do
  it "should have version" do
    (Snyk::VERSION).should_not be_nil
  end
end

describe Snyk::Client do
  it "should require a SNYK_TOKEN" do
    without_token do
      expect_raises(Snyk::Error) do
        Snyk::Client.new
      end
    end
  end

  it "should have a default API URL" do
    with_token do
      client = Snyk::Client.new
      client.url.should_not be_nil
    end
  end

  it "should take a URL as an argument" do
    with_token do
      url = "https://example.com/api/v1"
      client = Snyk::Client.new(url)
      client.url.should eq url
    end
  end
end
