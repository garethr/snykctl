require "./spec_helper"
require "../src/snyk"

describe Snyk do
  it "should have version" do
    (Snyk::VERSION).should_not be_nil
  end
end

describe Snyk::Client do
  it "should have a default API URL" do
    client = Snyk::Client.new(token: "123")
    client.url.should_not be_nil
  end

  it "should take a URL as an argument" do
    url = "https://example.com/api/v1"
    client = Snyk::Client.new(token: "123", url: url)
    client.url.should eq url
  end
end
