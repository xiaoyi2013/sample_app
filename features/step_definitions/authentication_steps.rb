Given /^a user visits the signin page$/ do
  visit signin_path
end

Given /^he submits invalid signin information$/ do
  click_button "Sign in"
end

Given /^he should see an error message$/ do
  page.should have_selector('div.alert.alert-error')
end

Given /^the user has an account$/ do
  @user = User.create(name: "test2050", email: "test2050@gmail.com",
                              password: "test2050", password_confirmation: "test2050")
end

Given /^the user submits valid signin information$/ do
  Fill_in "Email",     with: @user.email
  Fill_in "Password", with: @user.password
  click_button "Sign in"
end

Given /^he should see his profile page$/ do
  page.should have_selector('title', text:@user.name)
end

Given /^he should see a signout link$/ do
  page.should have_link('Sign out', href: signout_path)
end
