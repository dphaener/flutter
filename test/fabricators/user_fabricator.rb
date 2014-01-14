Fabricator(:user) do
  email do 
    sequence(:email) do |i|
      "derrick#{i}@example.com"
    end
  end

  screen_name do
    sequence(:screen_name) do |i|
      "derrickreimer#{i}"
    end
  end

  full_name "Derrick Reimer"
  url "http://example.com"
end
