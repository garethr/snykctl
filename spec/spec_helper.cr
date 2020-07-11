require "spec"

def with_token(&block)
  ENV.clear
  ENV["SNYK_TOKEN"] = "aaa"
  yield
end

def without_token(&block)
  ENV.clear
  yield
end
