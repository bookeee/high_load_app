Evaluation.delete_all
Match.delete_all
Post.delete_all
Rating.delete_all
Statistics.delete_all
Persona::Session.delete_all
Persona::User.delete_all
Settings::Caching.delete_all



# in seconds
top_posts_caching_time = 600
# object count
top_posts_limit = 210000

Settings::Caching.create!(top_posts_caching_time: top_posts_caching_time, top_posts_limit: top_posts_limit)


def value
  [1,2,3,4,5].sample
end

posts_amount = 200000
@evaluations_amount = 10000
matches_amount = 50000

def create_post(n, evaluation: true)
  resp = Faraday.post('http://localhost:3000/api/v1/posts') do |req|
    req.headers['Content-Type'] = 'application/json'
    req.body = { post: {title: "test_post_title#{n}",
                        content: "test content",
                        ip:  "222.444.111.#{n}",
                        login: "test_login_#{n}" } }.to_json

    if n < @evaluations_amount && evaluation
      create_evaluation(n)
    end
  end
end

def create_evaluation(n)
  resp = Faraday.post('http://localhost:3000/api/v1/evaluations') do |req|
    req.headers['Content-Type'] = 'application/json'
    req.body = { evaluation: {post_id: "#{n + 1}",
                              value: value} }.to_json
  end
end


posts_amount.times do |n|
  puts "Iteration nubmer #{n}"
  create_post(n)
  if n < matches_amount
    create_post(n, evaluation: false)
  end

  # uncomment it to get stats about queries for these endpoints
  #Faraday.get("http://localhost:3000/api/v1/top_posts/#{n}")
  #Faraday.get("http://localhost:3000/api/v1/matches")

end

