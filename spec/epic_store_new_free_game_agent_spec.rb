require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::EpicStoreNewFreeGameAgent do
  before(:each) do
    @valid_options = Agents::EpicStoreNewFreeGameAgent.new.default_options
    @checker = Agents::EpicStoreNewFreeGameAgent.new(:name => "EpicStoreNewFreeGameAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
