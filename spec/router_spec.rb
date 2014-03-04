require 'webrick'
require 'rails_lite'
require 'rspec'

describe Route do
  let(:req) { WEBrick::HTTPRequest.new(:Logger => nil) }
  let(:res) { WEBrick::HTTPResponse.new(:HTTPVersion => '1.0') }


  describe "#matches?" do
    it "matches simple regular expression" do
      index_route = Route.new(Regexp.new("^/users$"), :get, "x", :x)
      req.stub(:path) { "/users" }
      req.stub(:request_method) { :get }
      index_route.matches?(req).should be_true
    end

    it "matches regular expression with capture" do
      index_route = Route.new(Regexp.new("^/users/(?<id>\\d+)$"), :get, "x", :x)
      req.stub(:path) { "/users/1" }
      req.stub(:request_method) { :get }
      index_route.matches?(req).should be_true
    end

    it "correctly doesn't matche regular expression with capture" do
      index_route = Route.new(Regexp.new("^/users/(?<id>\\d+)$"), :get, "UsersController", :index)
      req.stub(:path) { "/statuses/1" }
      req.stub(:request_method) { :get }
      index_route.matches?(req).should be_false
    end
  end
end

describe Router do
  let(:req) { WEBrick::HTTPRequest.new(:Logger => nil) }
  let(:res) { WEBrick::HTTPResponse.new(:HTTPVersion => '1.0') }

  describe "#add_route" do
    it "adds a route" do
      subject.add_route(1, 2, 3, 4)
      subject.routes.count.should == 1
      subject.add_route(1, 2, 3, 4)
      subject.add_route(1, 2, 3, 4)
      subject.routes.count.should == 3
    end
  end

  describe "#match" do
    it "matches a correct route" do
      subject.add_route(Regexp.new("^/users$"), :get, :x, :x)
      req.stub(:path) { "/users" }
      req.stub(:request_method) { :get }
      matched = subject.match(req)
      matched.should_not be_nil
    end
  end

  describe "http method (get, put, post, delete)" do
    it "adds methods get, put, post and delete" do
      router = Router.new
      (router.methods - Class.new.methods).should include(:get)
      (router.methods - Class.new.methods).should include(:put)
      (router.methods - Class.new.methods).should include(:post)
      (router.methods - Class.new.methods).should include(:delete)
    end

    it "adds a route when an http method method is called" do
      router = Router.new
      router.get Regexp.new("^/users$"), ControllerBase, :index
      router.routes.count.should == 1
    end
  end
end
