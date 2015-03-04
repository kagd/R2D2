class CommitPresenter < DigitalOpera::Presenter::Base
  def as_json(include_root=false)
    {
      repo_full_name: self.repo_full_name,
      message: self.message,
      date: self.date,
      additions: self.additions,
      deletions: self.deletions,
      number_of_files: self.number_of_files
    }
  end
end
