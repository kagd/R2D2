
describe GithubController do
  let(:feb_commit){ FactoryGirl.create :commit, date: Date.parse('February 21, 2015') }
  let(:jan_commit){ FactoryGirl.create :commit, date: feb_commit.date + -1.month }
  let(:dec_commit){ FactoryGirl.create :commit, date: jan_commit.date + -1.month }
  let(:go_to_index){ get :index, format: :json }

  describe '#index' do
    before(:each) do
      FactoryGirl.create :commit_language
      dec_commit
    end

    it 'should have a list of years on the root' do
      go_to_index
      expect(assigns(:site_commits).keys).to eq ["2015","2014"]
    end

    it 'should have months under year 2015' do
      go_to_index
      expect(assigns(:site_commits)["2015"].keys).to eq ["February","January"]
    end

    it 'should have months under year 2014' do
      go_to_index
      expect(assigns(:site_commits)["2014"].keys).to eq ["December"]
    end

    it 'should have a list of commits under a month' do
      go_to_index
      class_names = assigns(:site_commits)["2015"]["February"].map{|commit| commit.class }

      expect(class_names.all?{|class_name| class_name == CommitPresenter }).to eq true
    end

    it 'should have a count of all commits' do
      go_to_index
      expect(assigns(:total_commits)).to eq 3
    end

    it 'should have a list of all repos' do
      jan_commit.update_attribute :repo_full_name, "kagd/C3PO"
      go_to_index
      expect(assigns(:total_repos)).to eq 2
    end

    it 'should list language_counts' do
      go_to_index
      expect(assigns(:language_counts)).to be_present
    end
  end
end
