# Rails Lite

[![Code Climate](https://codeclimate.com/github/timothylevi/rails_lite.png)](https://codeclimate.com/github/timothylevi/rails_lite)

Light MVC framework utilizing WEBrick's server and cookie storing functionality to imitate how Rails handles routes, controllers. Uses regular expressions to match routes.

### Run the specs
There are rspec specs in the `spec` directory and ruby code for you to test with in the `test` directory. The specs were written with _you_ in mind ;) Run them in this order they should generally follow the progression of the project.

#### Suggested Order
0.  `rspec spec/controller_base_spec.rb`
0.  `rspec spec/session_spec.rb`
0.  `rspec spec/params_spec.rb`
0.  `rspec spec/router_spec.rb`
0.  `rspec spec/integration_spec.rb`

If you're feeling extra fancy you can run [guard](https://github.com/guard/guard)!
just type `guard`
