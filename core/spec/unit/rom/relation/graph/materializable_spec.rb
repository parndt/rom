RSpec.describe ROM::Relation::Graph do
  include_context 'gateway only'
  include_context 'users and tasks'

  def t(*args)
    ROM::Processor::Transproc::Functions[*args]
  end

  let(:users) do
    Class.new(ROM::Memory::Relation) do
      auto_map false

      def by_name(name)
        restrict(name: name)
      end
    end.new(users_dataset)
  end

  let(:tasks) do
    Class.new(ROM::Memory::Relation) do
      auto_map false

      def for_users(_users)
        self
      end

      def by_title(title)
        restrict(title: title)
      end
    end.new(tasks_dataset)
  end

  it_behaves_like 'materializable relation' do
    let(:mapper) do
      t(:combine, [[:tasks, name: :name]])
    end

    let(:relation) do
      ROM::Relation::Graph.new(users.by_name('Jane'), [tasks.for_users]) >> mapper
    end
  end
end
