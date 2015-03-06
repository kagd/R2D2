
describe 'github/index' do
  let(:feb_commit){ FactoryGirl.create :commit, date: Date.parse('February 21, 2015') }
  let(:jan_commit){ FactoryGirl.create :commit, date: feb_commit.date + -1.month }
  let(:dec_commit){ FactoryGirl.create :commit, date: jan_commit.date + -1.month }
  let(:commits){ Commit.all }

  describe 'JSON format' do
    before(:each) do
      FactoryGirl.create :commit_language
      dec_commit

      service = CommitService.new commits
      site_commits = service.group_by_year_month
      assign :site_commits, site_commits
      assign :total_commits, Commit.all.count
      assign :total_repos, Commit.uniq.pluck(:repo_full_name).count
      assign :language_counts, CommitLanguageService.percentages

      render
    end

    it 'should have years on the root' do
      expect(rendered).to have_json_path 'site_commits/2015'
    end

    it 'should have years on the root' do
      expect(rendered).to have_json_path 'site_commits/2014'
    end

    it 'should have months under a year' do
      expect(rendered).to have_json_path 'site_commits/2015/January'
    end

    it 'should have months under a year' do
      expect(rendered).to have_json_path 'site_commits/2014/December'
    end

    it 'should have commits under a month' do
      expect(rendered).to have_json_path 'site_commits/2014/December/0/repo_full_name'
    end

    it 'should have commits under a month' do
      expect(rendered).to have_json_path 'site_commits/2015/January/0/repo_full_name'
    end
  end
end
