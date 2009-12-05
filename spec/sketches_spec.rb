require "spec"
require "sketches"

describe "Basic Sketches usage" do
  before(:each) do
    @file_to_open = nil
    Sketches.config :editor => lambda { |fn| @file_to_open = fn; "" }
  end

  it "should open a sketch from a given file" do
    sketch_from "test_file"
    @file_to_open.should == "test_file"
  end

  it "should open a sketch in a temp directory" do
    sketch
    @file_to_open.should match(/sketch.*\.rb$/)
  end
end