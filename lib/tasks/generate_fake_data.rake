namespace :generate do
  desc "Creates a bunch of fake journeys to seed the development environment"
  task :fake_data => :environment do
    domain = Faker::Internet.domain_name

    site_pages = []
    (1..Random.rand(5)+3).each do
      site_pages.push(Faker::Internet.url(domain))
    end

    (1..Random.rand(5)+1).each do
      user = User.create(
        ip: Faker::Internet.ip_v4_address
      )
    end

    user_count = User.count

    (1..Random.rand(5)+3).each do

      user = User.offset(Random.rand(user_count)).limit(1).first

      start_time = Random.rand(5).days.ago

      journey = Journey.create(
        user_id: user.id,
        created_at: start_time
      )

      time = start_time
      (1..Random.rand(7)+1).each do
        page = site_pages[Random.rand(site_pages.length)-1]

        Event.create(
          journey: journey,
          user_id: user.id,
          slug: page,
          created_at: time
        )
        time = time + Random.rand(14).minutes
      end
    end
  end
end
