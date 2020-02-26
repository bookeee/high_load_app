def value
  [1,2,3,4,5].sample
end

posts_amount = 300
evaluations_amount = 200

posts_amount.times do |n|
  puts "Iteration nubmer #{n}"
  resp = Faraday.post('http://localhost:3000/api/v1/posts') do |req|
    req.headers['Content-Type'] = 'application/json'
    req.body = { post: {title: "test_post_title#{n}",
                        content: "test content",
                        ip:  "222.444.111.#{n}",
                        login: "test_login_#{n}" } }.to_json
  end

  if n < evaluations_amount
    resp = Faraday.post('http://localhost:3000/api/v1/evaluations') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { evaluation: {post_id: "#{n}",
                                value: value} }.to_json
    end
  end

end

# in seconds
top_posts_caching_time = 600
# object count
top_posts_limit = 210000

Settings::Caching.create!(top_posts_caching_time: top_posts_caching_time, top_posts_limit: top_posts_limit)