namespace :db do
  task populate: :environment do

    List.destroy_all
    Todo.destroy_all

    10.times do
      list = List.new(name: Faker::HipsterIpsum.words.map(&:capitalize).join(' ')).tap { |l| l.save! }
      3.times do 
        Todo.new({
          list_id: list.id, 
          title: Faker::HipsterIpsum.words(6).join(' '),
          finished: Random.rand(0..1).zero?
        }).save 
      end
    end
  end
end