ActiveRecord::Base.connection.execute('TRUNCATE TABLE users RESTART IDENTITY CASCADE')
ActiveRecord::Base.connection.execute('TRUNCATE TABLE authorizations RESTART IDENTITY')
ActiveRecord::Base.connection.execute('TRUNCATE TABLE questions RESTART IDENTITY')
ActiveRecord::Base.connection.execute('TRUNCATE TABLE answers RESTART IDENTITY')


user = User.create(name: 'Bob', email: 'test@exmample.com', password: 'thepassword', admin: true)
user2 = User.create(name: 'Bill', email: 'test_bill@exmample.com', password: 'thepassword', admin: false)

q1 = Question.create(user_id: user.id, title: 'President', body: 'Who will be the next president?')
q2 = Question.create(user_id: user2.id, title: 'Weather', body: 'Will the Weather be warm?')

Question.create(user_id: user.id, title: 'Summer', body: 'Will the Summner be warm?')
Question.create(user_id: user2.id, title: 'Spring', body: 'Will the Spring be warm?')
Question.create(user_id: user2.id, title: 'Fall', body: 'Will the Fall be warm?')
Question.create(user_id: user.id, title: 'Winter', body: 'Will the Winter be warm?')


Answer.create(user_id: user.id, question_id: q1.id, body: 'Human man')
Answer.create(user_id: user.id, question_id: q1.id, body: 'Human woman')
Answer.create(user_id: user2.id, question_id: q1.id, body: 'Reptiloid man')
Answer.create(user_id: user2.id, question_id: q1.id, body: 'Reptiloid woman')
Answer.create(user_id: user2.id, question_id: q1.id, body: 'Someone else')


Answer.create(user_id: user.id, question_id: q2.id, body: 'Yes, sure')
Answer.create(user_id: user.id, question_id: q2.id, body: 'May be')
Answer.create(user_id: user.id, question_id: q2.id, body: 'Never')
Answer.create(user_id: user2.id, question_id: q2.id, body: 'For sure')
Answer.create(user_id: user2.id, question_id: q2.id, body: 'Who knows')