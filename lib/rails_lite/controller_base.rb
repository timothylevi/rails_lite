require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'


class ControllerBase
  attr_reader :params, :req, :res, :name

  # setup the controller
  def initialize(req, res, route_params ="/")
    @req = req
    @res = res
    @name = self.class.to_s.underscore
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    @res.body = content
    @res.content_type = type
    session.store_session(@res)
    raise "Already rendered" if already_rendered?
    @already_built_response = true
  end

  # helper method to alias @already_rendered
  def already_rendered?
    @already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
    @res.header["location"] = url
    @res.status = 302
    session.store_session(@res)
    raise "Already rendered" if already_rendered?
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    contents = File.read("views/#{self.name}/#{template_name}.html.erb")
    template = ERB.new("<%= contents %>").result(binding)
    render_content(template, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(action_name)
    send(action_name) || (render action_name)
  end
end
