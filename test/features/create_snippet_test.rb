require 'test_helper'

class CreateSnippet < Capybara::Rails::TestCase
  test "snippet successfully created" do
    visit new_snippet_path
    fill_in "snippet[title]", with: 'Sum Array'
    fill_in "snippet[language]", with: 'Javascript'
    fill_in "snippet[code]", with: 'array.reduce((prev, cur) => prev + cur, 0)'
    click_button "Create Snippet"

    assert_content page, "Sum Array"
  end

  test "cannot create snippet without title" do
    visit new_snippet_path
    fill_in "snippet[language]", with: 'Javascript'
    fill_in "snippet[code]", with: '//Code without title'
    click_button "Create Snippet"

    assert_content page, "Title can't be blank"
  end

end
