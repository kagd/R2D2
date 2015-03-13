
describe BitbucketService do
  let(:service){ BitbucketService.new }
  let(:repo_name_1){ 'advantage-plan' }
  let(:repo_name_2){ 'breakroom' }
  let(:author_username){ ENV['BITBUCKET_AUTHOR'] }
  let(:author_full_name){ ENV['BITBUCKET_FULL_NAME'] }
  let(:non_author_username){ 'noiseunion' }

  before(:each) do
    # quiet the service
    service.stubs(:talk)
  end

  describe '#repos' do
    it 'should return the repo names' do
      VCR.use_cassette("repos") do
        expect(service.repos).to include repo_name_1
        expect(service.repos).to include repo_name_2
      end
    end
  end

  describe '#user_changesets' do
    let(:repo_user_changeset_authors){ service.user_changesets(repo_name_1).map{ |cs| cs['author'] } }
    let(:repo_changeset_authors){ service.user_changesets(repo_name_1); service.commits.map{ |cs| cs['author'] } }

    it 'should return user changesets for a single repo' do
      VCR.use_cassette("changesets/advantage-plan") do
        expect(repo_user_changeset_authors.uniq).to include author_username
      end
    end

    it 'should return user changesets for a single repo' do
      VCR.use_cassette("changesets/advantage-plan") do
        expect(repo_user_changeset_authors.uniq).to include author_full_name
      end
    end

    it 'should return user changesets for a single repo' do
      VCR.use_cassette("changesets/advantage-plan") do
        expect(repo_user_changeset_authors.uniq.size).to eq 2
      end
    end

    it 'should NOT return other users changesets for a single repo' do
      VCR.use_cassette("changesets/advantage-plan") do
        expect(repo_user_changeset_authors).to_not include non_author_username
      end
    end

    it 'should set all commits' do
      VCR.use_cassette("changesets/advantage-plan") do
        user_commits = service.user_changesets(repo_name_1)
        expect(service.commits.size).to be > user_commits.size
      end
    end

    it 'should set all commits' do
      VCR.use_cassette("changesets/advantage-plan") do
        user_commits = service.user_changesets(repo_name_1)
        expect(service.commits.size).to be > user_commits.size
      end
    end

    it 'should have pulled back all commits' do
      VCR.use_cassette("changesets/advantage-plan") do
        user_commits = service.user_changesets(repo_name_1)
        total_commit_count = service.send(:v1, "repositories/#{ENV['BITBUCKET_OWNER']}/#{repo_name_1}/changesets")['count']

        expect(service.commits.size).to eq total_commit_count
      end
    end
  end

  describe '#changeset_diff' do
    #NOTE: Since this is testing an actual commit across 2 files, the numbers
    # are the expected changes
    let(:sha){ 'ec7d502' }

    it 'should return additions of a commit' do
      VCR.use_cassette("changesets/#{sha}/diff") do
        expect(service.changeset_diff(repo_name_1, sha)[:additions]).to eq 2
      end
    end

    it 'should return deletions of a commit' do
      VCR.use_cassette("changesets/#{sha}/diff") do
        expect(service.changeset_diff(repo_name_1, sha)[:deletions]).to eq 3
      end
    end
  end

  describe '#run' do
    it 'should creeate a commit for each user_commit' do
      # limit it down to only 1 repo
      service.stubs(:repos).returns [repo_name_1]

      VCR.use_cassette("changesets/advantage-plan") do
        VCR.use_cassette("changesets/advantage-plan/diffs") do
          expect{ service.run }.to change{ Commit.count }.to( service.user_changesets(repo_name_1).size )
        end
      end
    end

    it 'should create a commit_language for each file' do
      service.stubs(:repos).returns [repo_name_1]
      
      VCR.use_cassette("changesets/advantage-plan") do
        VCR.use_cassette("changesets/advantage-plan/diffs") do
          expected_count = service.user_changesets(repo_name_1).reduce(0){|memo, changeset| memo + changeset['files'].size }
          expect{ service.run }.to change{ CommitLanguage.count }.to( expected_count )
        end
      end
    end
  end
end
