require 'webrick'
require 'rails_lite'

describe "the symphony of things" do
  let(:req) { WEBrick::HTTPRequest.new(:Logger => nil) }
  let(:res) { WEBrick::HTTPResponse.new(:HTTPVersion => '1.0') }

  before(:all) do
    class Ctrlr < ControllerBase
      def route_render
        render_content("testing", "text/html")
      end

      def route_does_params
        render_content("got ##{ params["id"] }", "text/text")
      end

      def update_session
        session[:token] = "testing"
        render_content("hi", "text/html")
      end
    end
  end

  describe "controller sessions" do
    let(:ctrlr) { Ctrlr.new(req, res) }

    it "exposes a session via the session method" do
      ctrlr.session.should be_instance_of(Session)
    end

    it "saves the session after rendering content" do
      ctrlr.update_session
      res.cookies.count.should == 1
      JSON.parse(res.cookies[0].value)["token"].should == "testing"
    end
  end
end
