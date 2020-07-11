require "./spec_helper"

require "../src/snykctl"

describe SnykCtl do
  it "should have version" do
    (SnykCtl::VERSION).should_not be_nil
  end
end
