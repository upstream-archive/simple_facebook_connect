When /I sign up via facebook/ do
  get fb_authenticate_path
  response.redirected_to.should include('facebook.com')
  # go to facebook and come back with auth token
  post fb_connect_path, auth_token: '3e4a22bb2f5ed75114b0fc9995ea85f1'
  visit response.redirected_to
end

When /I sign in via facebook/ do
  When 'I sign up via facebook'
end

Then 'my facebook id should be set' do
  User.last.fb_uid.should == 8055 # taken from xml fixture
end

Given /a user who is connected via facebook/ do
  User.make fb_uid: 8055 # make from machinist
end